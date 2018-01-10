%% Structure From Motion From Multiple Views
% Structure from motion (SfM) is the process of estimating the 3-D structure 
% of a scene from a set of 2-D views. It is used in many applications, such 
% as robot navigation, autonomous driving, and augmented reality. This 
% example shows you how to estimate the poses of a calibrated camera from 
% a sequence of views, and reconstruct the 3-D structure of the scene up to
% an unknown scale factor.

% Copyright 2015 The MathWorks, Inc. 

%% Overview
% This example shows how to reconstruct a 3-D scene from a sequence of 2-D
% views taken with a camera calibrated using the
% <matlab:helpview(fullfile(docroot,'toolbox','vision','vision.map'),'visionCameraCalibrator'); Camera Calibrator app>.
% The example uses a |viewSet| object to store and manage the data
% associated with each view, such as the camera pose and the image points,
% as well as matches between points from pairs of views. 
%
% The example uses the pairwise point matches to estimate the camera pose of
% the current view relative to the previous view. It then links the
% pairwise matches into longer point tracks spanning multiple views using
% the |findTracks| method of the |viewSet| object. These tracks then serve
% as inputs to multiview triangulation using the |triangulateMultiview|
% function and the refinement of camera poses and the 3-D scene points
% using the |bundleAdjustment| function.
%
% The example consists of two main parts: camera motion estimation and
% dense scene reconstruction. In the first part, the example estimates the
% camera pose for each view using a sparse set of points matched across the
% views. In the second part, the example iterates over the sequence of
% views again, using |vision.PointTracker| to track a dense set of points
% across the views, to compute a dense 3-D reconstruction of the scene.
%
% The camera motion estimation algorithm consists of the following steps:
%
% # For each pair of consecutive images, find a set of point
% correspondences. This example detects the interest points using the
% |detectSURFFeatures| function, extracts the feature descriptors using the
% |extractFeatures| functions, and finds the matches using the
% |matchFeatures| function. Alternatively, you can track the points across
% the views using |vision.PointTracker|.
% # Estimate the relative pose of the current view, which is the camera
% orientation and location relative to the previous view. The example uses
% a helper function |helperEstimateRelativePose|, which calls
% |estimateEssentialMatrix| and |relativeCameraPose|.
% # Transform the relative pose of the current view into the coordinate
% system of the first view of the sequence.
% # Store the current view attributes: the camera pose and the image
% points.
% # Store the inlier matches between the previous and the current view.
% # Find point tracks across all the views processed so far.
% # Use the |triangulateMultiview| function to compute the initial 3-D
% locations corresponding to the tracks.
% # Use the |bundleAdjustment| function to refine the camera poses and the
% 3-D points.
% Store the refined camera poses in the |viewSet| object.

%% Read the Input Image Sequence
% Read and display the image sequence.

% Use |imageDatastore| to get a list of all image file names in a
% directory.
imageDir = fullfile('..','data','rgb');
imds = imageDatastore(imageDir);

% Display the images.
figure
% montage(imds.Files, 'Size', [20, 20]);

% Convert the images to grayscale.
images = cell(1, numel(imds.Files));
for i = 1:numel(imds.Files)
    I = readimage(imds, i);
    % images{i} = rgb2gray(I);
    images{i} = I;
end

title('Input Image Sequence');

%% Load Camera Parameters
% Load the |cameraParameters| object created using the 
% <matlab:helpview(fullfile(docroot,'toolbox','vision','vision.map'),'visionCameraCalibrator'); Camera Calibrator app>.

load(fullfile(imageDir,'..', 'camera.mat'));

%% Create a View Set Containing the First View
% Use a |viewSet| object to store and manage the image points and the
% camera pose associated with each view, as well as point matches between
% pairs of views. Once you populate a |viewSet| object, you can use it to
% find point tracks across multiple views and retrieve the camera poses to
% be used by |triangulateMultiview| and |bundleAdjustment| functions.

% Undistort the first image.
I = undistortImage(images{1}, cameraParams); 

% Detect features. Increasing 'NumOctaves' helps detect large-scale
% features in high-resolution images. Use an ROI to eliminate spurious
% features around the edges of the image.
border = 50;
roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
prevPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);

% Extract features. Using 'Upright' features improves matching, as long as
% the camera motion involves little or no in-plane rotation.
prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);

% Create an empty viewSet object to manage the data associated with each
% view.
vSet = viewSet;

% Add the first view. Place the camera associated with the first view
% and the origin, oriented along the Z-axis.
viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

%% Add the Rest of the Views
% Go through the rest of the images. For each image
%
% # Match points between the previous and the current image.
% # Estimate the camera pose of the current view relative to the previous
%   view.
% # Compute the camera pose of the current view in the global coordinate 
%   system relative to the first view.
% # Triangulate the initial 3-D world points.
% # Use bundle adjustment to refine all camera poses and the 3-D world
%   points.

for i = 2:numel(images)
    disp(i)
    % Undistort the current image.
    I = undistortImage(images{i}, cameraParams);
    
    % Detect, extract and match features.
    currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);    
    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
        'MaxRatio', .7, 'Unique',  true);
    
    % Select matched points.
    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));
    
    % Estimate the camera pose of current view relative to the previous view.
    % The pose is computed up to scale, meaning that the distance between
    % the cameras in the previous view and the current view is set to 1.
    % This will be corrected by the bundle adjustment.
    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        matchedPoints1, matchedPoints2, cameraParams);
    
    % Add the current view to the view set.
    vSet = addView(vSet, i, 'Points', currPoints);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));
    
    % Get the table containing the previous camera pose.
    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};
        
    % Compute the current camera pose in the global coordinate system 
    % relative to the first view.
    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, i, 'Orientation', orientation, ...
        'Location', location);
    
    % Find point tracks across all views.
    tracks = findTracks(vSet);

    % Get the table containing camera poses for all views.
    camPoses = poses(vSet);

    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    % Refine the 3-D world points and camera poses.
    [xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
        tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
        'PointsUndistorted', true);

    % Store the refined camera poses.
    vSet = updateView(vSet, camPoses);

    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end

%% Display Camera Poses
% Display the refined camera poses and 3-D world points.

% Display camera poses.
camPoses = poses(vSet);
figure;
plotCamera(camPoses, 'Size', 0.2);
hold on

% Exclude noisy 3-D points.
goodIdx = (reprojectionErrors < 5);
xyzPoints = xyzPoints(goodIdx, :);

% Display the 3-D points.
pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-5, loc1(1)+4]);
ylim([loc1(2)-5, loc1(2)+4]);
zlim([loc1(3)-1, loc1(3)+20]);
camorbit(0, -30);

title('Refined Camera Poses');

%% Compute Dense Reconstruction
% Go through the images again. This time detect a dense set of corners,
% and track them across all views using |vision.PointTracker|.

% Read and undistort the first image
I = undistortImage(images{1}, cameraParams); 

% Detect corners in the first image.
prevPoints = detectMinEigenFeatures(I, 'MinQuality', 0.001);

% Create the point tracker object to track the points across views.
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 6);

% Initialize the point tracker.
prevPoints = prevPoints.Location;
initialize(tracker, prevPoints, I);

% Store the dense points in the view set.
vSet = updateConnection(vSet, 1, 2, 'Matches', zeros(0, 2));
vSet = updateView(vSet, 1, 'Points', prevPoints);

% Track the points across all views.
for i = 2:numel(images)
    disp(i)
    % Read and undistort the current image.
    I = undistortImage(images{i}, cameraParams); 
    
    % Track the points.
    [currPoints, validIdx] = step(tracker, I);
    
    % Clear the old matches between the points.
    if i < numel(images)
        vSet = updateConnection(vSet, i, i+1, 'Matches', zeros(0, 2));
    end
    vSet = updateView(vSet, i, 'Points', currPoints);
    
    % Store the point matches in the view set.
    matches = repmat((1:size(prevPoints, 1))', [1, 2]);
    matches = matches(validIdx, :);        
    vSet = updateConnection(vSet, i-1, i, 'Matches', matches);
end

% Find point tracks across all views.
tracks = findTracks(vSet);

% Find point tracks across all views.
camPoses = poses(vSet);

% Triangulate initial locations for the 3-D world points.
xyzPoints = triangulateMultiview(tracks, camPoses,...
    cameraParams);

% Refine the 3-D world points and camera poses.
[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(...
    xyzPoints, tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
    'PointsUndistorted', true);

%% Display Dense Reconstruction
% Display the camera poses and the dense point cloud.

% Display the refined camera poses.
figure;
plotCamera(camPoses, 'Size', 0.2);
hold on

% Exclude noisy 3-D world points.
goodIdx = (reprojectionErrors < 5);

% Display the dense 3-D world points.
pcshow(xyzPoints(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-5, loc1(1)+4]);
ylim([loc1(2)-5, loc1(2)+4]);
zlim([loc1(3)-1, loc1(3)+20]);
camorbit(0, -30);

title('Dense Reconstruction');

%% References
%
% [1] M.I.A. Lourakis and A.A. Argyros (2009). "SBA: A Software Package for
%     Generic Sparse Bundle Adjustment". ACM Transactions on Mathematical
%     Software (ACM) 36 (1): 1-30.
%
% [2] R. Hartley, A. Zisserman, "Multiple View Geometry in Computer
%     Vision," Cambridge University Press, 2003.
%
% [3] B. Triggs; P. McLauchlan; R. Hartley; A. Fitzgibbon (1999). "Bundle
%     Adjustment: A Modern Synthesis". Proceedings of the International
%     Workshop on Vision Algorithms. Springer-Verlag. pp. 298-372.

displayEndOfDemoMessage(mfilename)

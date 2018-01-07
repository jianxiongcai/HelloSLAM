%%%
% Hello SLaM 
% Essential & [R t] Extraction
%%%
clear;
clc;

% Preprocessing
load('cameraParams.mat');
dList = dir('../../data1/rgb/*.pgm');
features = cell(2,length(dList));
validPts = cell(1,length(dList));
essential = cell(1,length(dList)-1);
RT = cell(1,length(dList)-1);
inliers = cell(1,length(dList)-1);

% Extract Feature Points
for i = 1:length(dList)
    tic
    im = imread(fullfile(dList(i).folder,dList(i).name));
    %ims{i} = rgb2gray(ims{i});
    features{1,i} = detectSURFFeatures(im);
    features{2,i} = extractFeatures(im,features{1,i});
    toc
end

% Estimate Essential Matrix
for i = 1:length(dList)-1
    indexPairs = matchFeatures(features{2,i},features{2,i+1});
    matchedPoints1 = features{1,i}(indexPairs(:,1));
    matchedPoints2 = features{1,i+1}(indexPairs(:,2));
    [essential{i},inliers] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,cameraParams);
    inlierPoints1 = matchedPoints1(inliers);
    inlierPoints2 = matchedPoints2(inliers);
    [relativeOrientation,relativeLocation] = relativeCameraPose(essential{i},cameraParams,inlierPoints1,inlierPoints2);
    [rotationMatrix,translationVector] = cameraPoseToExtrinsics(relativeOrientation,relativeLocation);
    RT{i} = [rotationMatrix,translationVector'];
end


save('RT.mat','RT');
save('essential.mat','essential');
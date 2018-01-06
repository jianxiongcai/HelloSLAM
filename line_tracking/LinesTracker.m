classdef LinesTracker < handle
    % this class is used to track lines among adjacent sequence images
    % each line get a sequence number and record in which image it appear
    % and coresponding coordinates
    
    properties
        % the line tracking, each line is a struct
        lines_tracking;
        
        % previous data
        img_pre;
        features_pre;
        points_pre;
        % the indexs of lines in previous image
        lines_idx_pre;
    end
    
    methods
        % given the first image and coresponding lines for adding
        % TODO
        function obj = LinesTracker(img,lines_in)
            % Input:
            %       img:            Gray Scale Image
            %       lines_in:       A set of liens in 2D image plane
            % extract feature and store it into features_pre
            points = detectSURFFeatures(img);
            [features, points] = extractFeatures(img, points);
            obj.features_pre = features;
            
            % TODO, precess lines_in
        end
        
        % add the next img after the previous one
        % TODO
        function add_img(obj,img,lines)
            % Input:
            %       img:            Gray Scale Image
            %       lines:          A set of lines in 2D image plane
            
            % compute the homography matrix from the image to the last one
            points_raw = detectSURFFeatures(img);
            [features, points_raw] = extractFeatures(img, points_raw);
            index_pairs = matchFeatures(features, obj.features_pre, 'Unique', true);
            
            points_matched = points_raw(index_pairs(:,1), :);
            points_pre_matched = obj.points_pre(index_pairs(:,2), :);
            
            % H transfrom image from current image to the previous one
            tform = estimateGeometricTransform(points_matched, points_pre_matched,...
            'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
            H = tform.T';
        
            % store points and features to previous one
            obj.img_pre = img;
            obj.features_pre = features;
            obj.points_pre = points_raw;
            
            % for each line in this image, match it with the last one, if
            % it is one line, append it to lines.
            lines = H * lines;
            
            % Otherwise, create a new line.
            
        end
    end
end


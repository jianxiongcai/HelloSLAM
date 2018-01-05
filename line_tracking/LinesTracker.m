classdef LinesTracker < handle
    % this class is used to track lines among adjacent sequence images
    % each line get a sequence number and record in which image it appear
    % and coresponding coordinates
    
    properties
        % the line tracking, each line is a struct
        lines_tracking
        img_pre;
        % the indexs of lines in previous image
        lines_idx_pre;
    end
    
    methods
        % given the first image and coresponding lines for adding
        % TODO
        function obj = LinesTracker(img,lines_in)
            
        end
        
        % add the next img after the previous one
        % TODO
        function add_img(img,lines)
            % compute the homography matrix from the image to the last one
            
            % for each line in this image, match it with the last one, if
            % it is one line, append it to lines.
            
            % Otherwise, create a new line.
        end
    end
end


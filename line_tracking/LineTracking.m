classdef LineTracking < handle
    % This class represent a line being tracking among different images.
    
    properties
        lines_2d;
        line_3d;            % the 3D representation of the line
    end
    
    methods
        function obj = LineTracking(img_idx,line_in)
            % Create a new LineTracking Object
            obj.lines_2d = struct('img_idx',img_idx,'line',line_in);
        end
        
        function add_line(obj,img_idx,line_in)
            % add a new 2D line into the line object 
            obj.lines_2d = [obj.lines_2d; struct('img_idx',img_idx,'line',line_in)];
        end
        
        % TODO
        % get the 2D line representation on image plane in img_idx
        function get_line(img_idx)
        end
    end
end


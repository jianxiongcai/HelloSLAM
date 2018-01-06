% merge all lines in the image

function [ lines_res ] = merge_lines_img(dist_thres, angular_thres, eli_thres, txt_path )
% Input:
%       dist_thres:             the distance threshold for determine
%                               whether to merge two lines
%       angular_thres:          the angular threshold for determine
%                               whether to merge two lines
%       eli_thres:              lines > the threshold will be kept
%       txt_path:               the path to read lines
    % read in all lines from the image
    lines = read_in_lines(txt_path);
    i = 1;
    while ( i <= size(lines,2) )
        line_i = lines(:,i);
        % merge lines with line i
        j = 1;
        offset = 0;
        while ( j <= size(lines,2) )
            if (i == j)
                j = j + 1;
                continue;
            end
            flag = is_similiar(dist_thres,angular_thres, line_i, lines(:,j));
            if (flag == 1)
                % merge lines
                line_i = line_merging( line_i, lines(:,j));
                
                %discard the jth element
                lines = [lines(:,1:j-1) lines(:,j+1:end)];
                
                % update ith element
                if (i>j)
                    i = i - 1;
                end
                lines(:,i) = line_i;
            else
                j = j + 1;
            end
        end
        i = i + 1;
    end
    
    
    % elimite lines with distance smaller then threshold
    lines_res = [];
    for i = 1:1:size(lines,2)
        if (get_line_length(lines(:,i)) > eli_thres)
            lines_res = [lines_res lines(:,i)];
        end
    end
end

function [flag] = is_similiar(threshold,angular_threshold, line1, line2)
    % determine whether to merge this two lines or not
    ori1 = get_line_oriention(line1);
    ori2 = get_line_oriention(line2);
    theta = abs(ori1-ori2);
    if (theta > pi/2)
        theta = pi - theta;
    end
    % check angle difference
    if ( theta > angular_threshold)
        flag = 0;
        return ;
    end
    
    % check if any endpoint lines in another line
    % if any point is on the line
    if ((point_to_line_dist(line1(1:2,1),line2(1:4,1)) < 10) ||...
            (point_to_line_dist(line1(3:4,1),line2(1:4,1)) < 10) ||...
            (point_to_line_dist(line2(1:2,1),line1(1:4,1)) < 10) ||...
            (point_to_line_dist(line2(3:4,1),line1(1:4,1)) < 10))
        flag = 1;
        return ;
    end
    
    % check the endpoints difference
    if ((get_distance(line1(1:2,1), line2(1:2,1)) < threshold) ||...
            (get_distance(line1(3:4,1), line2(1:2,1)) < threshold) || ...
            (get_distance(line1(1:2,1), line2(3:4,1)) < threshold) || ...
            (get_distance(line1(3:4,1), line2(3:4,1)) < threshold))
        flag = 1;
    else
        flag = 0;
    end
end
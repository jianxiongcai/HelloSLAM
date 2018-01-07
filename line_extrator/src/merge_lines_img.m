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
    lines_raw = read_in_lines(txt_path);
    % merge lines until no lines can be merged again
    merge_flag = 0;
    while(merge_flag == 0)
        [lines,merge_flag] = merge_lines(lines_raw,dist_thres,angular_thres);
    end
    
    % elimite lines with distance smaller then threshold
    lines_res = [];
    for i = 1:1:size(lines,2)
        if (get_line_length(lines(:,i)) > eli_thres)
            lines_res = [lines_res lines(:,i)];
        end
    end
    
    % merge all lines that is similar
    [lines_res] = merge_similar_final(lines_res, 0.01*1080);
end

function [lines, merge_flag] = merge_lines(lines_raw,dist_thres,angular_thres)
    % merge all lines
    merge_flag = 0;
    lines = [];
    for i = 1:1:size(lines_raw,2)
        matched_flag = 0;
        line_i = lines_raw(:,i);
        for j = 1:1:size(lines,2)
            flag = is_similiar(dist_thres,angular_thres, line_i, lines(:,j)) || ...
                is_overlapping(line_i,lines(:,j));
            if (flag == 1)
                % merge lines
                line_new = line_merging( line_i, lines(:,j));
                lines(:,j) = line_new;
                matched_flag = 1;
                merge_flag = 1;
                break;
            end
        end
        
        if (matched_flag == 0)
            % add the line to the final result
            lines = [lines lines_raw(:,i)];
        end
    end
end

function [lines_res] = merge_similar_final(lines, threshold)
    lines_res = [];
    for i = 1:1:size(lines,2)
        matched_flag = 0;
        ori1 = get_line_oriention(lines(:,i));
        for j = 1:1:size(lines_res,2)
            % if there is a match, merge the two lines
            ori2 = get_line_oriention(lines_res(:,j));
            % check orientation difference
            if (abs(ori1 - ori2) > 1/pi)
                continue;
            end
            % check distance difference
            if ((point_to_line_dist(lines(1:2,i),lines_res(:,j)) < threshold) &&...
                    (point_to_line_dist(lines(3:4,i),lines_res(:,j)) < threshold))
                line_new = line_merging( lines(:,i), lines_res(:,j));
                lines_res = [lines_res line_new];
                matched_flag = 1;
                break;
            end
        end
        
        if (matched_flag == 0)
            lines_res = [lines_res lines(:,i)];
        end
    end
end

function [flag] = is_similiar(threshold,angular_threshold, line1, line2)
    % determine whether to merge this two lines or not
    if ((get_distance(line1(1:2,1), line2(1:2,1)) < threshold) ||...
            (get_distance(line1(3:4,1), line2(1:2,1)) < threshold) || ...
            (get_distance(line1(1:2,1), line2(3:4,1)) < threshold) || ...
            (get_distance(line1(3:4,1), line2(3:4,1)) < threshold))
        ori1 = get_line_oriention(line1);
        ori2 = get_line_oriention(line2);
        theta = abs(ori1-ori2);
        if (theta > pi/2)
            theta = pi - theta;
        end
        if ( theta < angular_threshold)
            flag = 1;
        else
            flag = 0;
        end
        return;
    else
        flag = 0;
    end
end

function [flag] = is_overlapping(line1,line2)
    % determine if two lines are overlapping or not
    % check orientation
    ori1 = get_line_oriention(line1);
    ori2 = get_line_oriention(line2);
    if (abs(ori1 - ori2) > pi/180)
        flag = 0;
        return;
    end
    % check point to line difference
    threshold = 10;
    if ((point_to_line_dist(line1(1:2,:),line2) < threshold) ||...
            (point_to_line_dist(line1(3:4,:),line2) < threshold) ||...
            (point_to_line_dist(line2(1:2,:),line1) < threshold) ||...
            (point_to_line_dist(line2(3:4,:),line1) < threshold))
        flag = 1;
    else
        flag = 0;
    end
end

function [dist] = get_distance(point1, point2)
    dist = norm([point1(1)-point2(1), point1(2) - point2(2)]);
end
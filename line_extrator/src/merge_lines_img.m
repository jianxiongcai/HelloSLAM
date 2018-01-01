% merge all lines in the image

function [ lines ] = merge_lines_img(dist_threshold, angular_threshold, txt_path )
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
            flag = is_similiar(dist_threshold,angular_threshold, line_i, lines(:,j));
            if (flag == 1)
                % merge lines
                line_i = line_merging( line_i, lines(:,j));
                
                %discard the jth element
                lines = [lines(:,1:j-1) lines(:,j+1:end)];
                
                % update ith element
                if (i>j)
                    offset = offset + 1;
                end
                lines(:,i-offset) = line_i;
            else
                j = j + 1;
            end
        end
        i = i + 1;
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

function [dist] = get_distance(point1, point2)
    dist = norm([point1(1)-point2(1), point1(2) - point2(2)]);
end

function [lines] = read_in_lines(txt_path)
% Input:
%       txt_path:       the full name of the txt path
% Output:
%       lines:          4*n matrix (n lines)
    fid = fopen(fullfile('..','data',txt_path));
    lines_raw = textscan(fid,'%f %f %f %f %f %f %f');
    fclose(fid);
    for i = 1:1:4
        lines = [lines_raw{1} lines_raw{2} lines_raw{3} lines_raw{4}]';
    end
end
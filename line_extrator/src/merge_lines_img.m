% merge all lines in the image

function [ lines ] = merge_lines_img(threshold, txt_path )
    % read in all lines from the image
    lines = read_in_lines(txt_path);
    i = 1;
    while ( i <= size(lines,2) )
        line_i = lines(:,i);
        % merge lines with line i
        j = 1;
        while ( j <= size(lines,2) )
            if (i == j)
                j = j + 1;
            end
            flag = is_similiar(threshold, line_i, lines(:,j));
            if (flag == 1)
                % merge line
                disp(line_i);
                disp( lines(:,j));
                line_i = line_merging( line_i, lines(:,j));
                disp(line_i);
                % discard the jth element
                lines = [lines(:,1:j-1) lines(:,j+1:end)];
            else
                j = j + 1;
            end
        end
        i = i + 1;
    end
end

function [flag] = is_similiar(threshold, line1, line2)
    %TODO this part is wrong !!!
    if ((abs(line1(1) - line2(1)) < threshold) ||...
            (abs(line1(1) - line2(2)) < threshold) || ...
            (abs(line1(2) - line2(1)) < threshold) || ...
            (abs(line1(2) - line2(2)) < threshold))
        flag = 1;
    else
        flag = 0;
    end
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
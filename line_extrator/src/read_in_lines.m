function [lines] = read_in_lines(txt_path)
% Input:
%       txt_path:       the full name of the txt path
% Output:
%       lines:          4*n matrix (n lines)
    fid = fopen(txt_path);
    lines_raw = textscan(fid,'%f %f %f %f %f %f %f');
    fclose(fid);
    for i = 1:1:4
        lines = [lines_raw{1} lines_raw{2} lines_raw{3} lines_raw{4}]';
    end
end
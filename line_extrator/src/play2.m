% read in txt
txt_path = '../../data/171229T132838video/1514525318673.9.txt';
[lines] = read_in_lines(txt_path);
figure;
for i = 1:1:size(lines,2)
    plot_line(lines(:,i), 'b', 1);
    hold on;
end


[ lines ] = merge_lines_img(0.05*1080,pi/180, txt_path );

figure;
for i = 1:1:size(lines,2)
    plot_line(lines(:,i), 'r', 1);
    hold on;
end


return ;


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
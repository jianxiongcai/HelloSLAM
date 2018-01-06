% play
% test two lines
line1 = [0; 0; 1; 1];
% line2 = [1; 1; 2; 2];
line2 = [3; 3; 1.1; 1.6];

plot_line(line1,'r',1);
plot_line(line2,'r',1);

[ res_line ] = line_merging( line1, line2);

plot_line(res_line,'b',2);

function plot_line(line_in, color, width)
    line([line_in(1) line_in(3)], [line_in(2) line_in(4)],'Color',color,'LineWidth',width);
    hold on;
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
% play
% test two lines
line1 = [0; 0; 1; 1];
% line2 = [1; 1; 2; 2];
line2 = [1.5; 1; 3; 3];

plot_line(line1,'r',1);
plot_line(line2,'r',1);

[ res_line ] = line_merging( line1, line2);

plot_line(res_line,'b',2);

function plot_line(line_in, color, width)
    line([line_in(1) line_in(3)], [line_in(2) line_in(4)],'Color',color,'LineWidth',width);
    hold on;
end
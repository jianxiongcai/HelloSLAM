function plot_line(line_in, color, width)
    line([line_in(1) line_in(3)], [line_in(2) line_in(4)],'Color',color,'LineWidth',width);
    hold on;
end
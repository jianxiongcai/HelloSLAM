function plot_lines( lines )
figure;
for i = 1:1:size(lines,2)
    plot_line(lines(:,i), 'r', 1);
    hold on;
end


end


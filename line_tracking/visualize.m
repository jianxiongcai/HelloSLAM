% visualization 

addpath(fullfile('..','common'));
% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');
io = IOData(img_path, lines_path);

% start visualization
line_objs = line_tracker.lines_tracking;

for img_idx = 1:10:200
    % plot out lines in each image
    figure;
    imshow(io.read_pgm(img_idx));
    for i = 7:1:7
    % for i = 1:1:size(line_objs,2)
        line_2d = line_objs(i).get_line(img_idx);
        if (size(line_2d,1) ~= 0)
            plot_line(line_2d,'g',1);
            hold on;
        end
        disp(strcat('Done: ', num2str(i)));
    end 
    pause(3);
end


function plot_line(line_in, color, width)
    line([line_in(1) line_in(3)], [line_in(2) line_in(4)],'Color',color,'LineWidth',width);
    hold on;
end
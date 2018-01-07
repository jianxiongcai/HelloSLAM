% visualization 

addpath(fullfile('..','common'));
% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');
io = IOData(img_path, lines_path);

% start visualization
line_objs = line_tracker.lines_tracking;


figure;
imshow(io.read_pgm(1));
hold on;

img_idx = 2;

for i = 1:1:size(line_objs,2)
    line_2d = line_objs(i).get_line(1);
    if (isempty(line_2d) == 0)
        plot_line(line_2d,'g',1);
    end
    hold on;
end
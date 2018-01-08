% visualization 

addpath(fullfile('..','common'));
% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');
io = IOData(img_path, lines_path);

% start visualization
line_objs = line_tracker.lines_tracking;

for i = 1:1:1
    figure;
    lines = line_objs(i).lines_2d;
    for j = 3:1:4
        figure;
        img_idx = lines(j).img_idx;
        line_2d = lines(j).line;
        imshow(io.read_pgm(img_idx));
        hold on;
        plot_line(line_2d,'g',1);
        hold off;
        
    end
    
end
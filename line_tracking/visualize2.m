% visualization 

addpath(fullfile('..','common'));
% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');
io = IOData(img_path, lines_path);

% start visualization
line_objs = line_tracker.lines_tracking;


figure;
img_idx = 10011;

while (1)
    [img, flag] = io.read_pgm(img_idx);
    if (flag == 0)
        break;
    end
    
    imshow(img);
    hold on;

    for i = 1:1:size(line_objs,2)
        line_2d = line_objs(i).get_line(img_idx);
        if (isempty(line_2d) == 0)
            plot_line(line_2d,'g',1);
        end
        hold on;
    end
    hold off;
    
    pause(0.5);
    img_idx = img_idx + 1;
end
% test line tracking
addpath(fullfile('..','common'));

% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');

% check existance of line tracker
if (exist(img_path) == 0)
    error('Folder data does not exist');
end

io = IOData(img_path, lines_path);
idx = 10001;
while(1)
    disp(strcat('Processing: ', num2str(idx)));
    [img, flag] = io.read_pgm(idx);
    if (flag == 0)
        break;
    end
    
    lines = io.read_lines(idx);
    
    % for the first frame
    if (idx == 10001)
        % initialization
        line_tracker = LinesTracker(img,lines, idx);
        idx = idx + 1;
        continue;
    end
    
    % for other frames
    line_tracker.add_img(img,lines,idx);
    
    idx = idx + 1;
end

line_tracker.eliminate_useless(3);
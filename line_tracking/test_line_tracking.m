% test line tracking
addpath(fullfile('..','common'));

% initialization
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');

io = IOData(img_path, lines_path);

for idx = 1:10:500
    disp(strcat('Processing: ', num2str(idx)));
    img = io.read_pgm(idx);
    lines = io.read_lines(idx);
    % for the first frame
    if (idx == 1)
        % initialization
        line_tracker = LinesTracker(img,lines, 1);
        continue;
    end
    % for other frames
    line_tracker.add_img(img,lines,idx);
end

line_tracker.eliminate_useless(3);
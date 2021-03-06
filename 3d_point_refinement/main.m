clc;
clear;

% Input matching lines.
addpath('../line_tracking');
load('../data/tracking.mat');

% Input RT and Essential.
load('../essential_extractor/src/RT.mat');
load('../essential_extractor/src/essential.mat');
line_tracker.eliminate_useless(5);

% World_Point Refinement.
W = [];
% How many differnet lines.
for i = 1:size(line_tracker.lines_tracking, 2) 
    % How many frames for one line.
    for j = 1:size(line_tracker.lines_tracking(i).lines_2d, 2)-1 
        idx = line_tracker.lines_tracking(1,i).lines_2d(j).img_idx-10000;
        line_A = line_tracker.lines_tracking(1,i).lines_2d(j).line;
        line_B = line_tracker.lines_tracking(1,i).lines_2d(j+1).line;
        if (sum(abs(line_A-line_B)) < 100)
            T = get_3D_point(essential{idx}, RT{idx}, [line_A(1:2,:); 1], [line_A(3:4,:); 1], [line_B(1:2,:); 1], [line_B(3:4,:); 1]);
            for m = idx-1:-1:1
                T = [RT{m}; 0 0 0 0]*T;
            end
            W = [W T];
        end
    end
end

visualization(W)


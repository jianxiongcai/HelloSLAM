clc;
clear;

% Input matching lines.
addpath('../line_tracking');
load('../data/tracking.mat');

% Input RT and Essential.
load('../essential_extractor/src/RT.mat');
load('../essential_extractor/src/essential.mat');

% World_Point Refinement.
W = [];
% How many differnet lines.
for i = 1:size(line_tracker.lines_tracking, 2) 
    % How many frames for one line.
    idx = line_tracker.lines_tracking(1,i).lines_2d(1).img_idx-10000;
    if (idx == 1)
        line_A = line_tracker.lines_tracking(1,i).lines_2d(1).line;
        line_B = line_tracker.lines_tracking(1,i).lines_2d(2).line;
        T = get_3D_point(essential{idx}, RT{idx}, [line_A(1:2,:); 1], [line_A(3:4,:); 1], [line_B(1:2,:); 1], [line_B(3:4,:); 1]);
        W = [W T]
    end
end

visualization(W)
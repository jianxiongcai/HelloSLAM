% visualize any data
path1 = fullfile('171229T133050video','1514525483859.749.pgm');
path2 = fullfile('171229T133050video-merge','1514525483859.749.mat');
path1 = fullfile('..','..','data',path1);
path2 = fullfile('..','..','data',path2);

imshow(imread(path1));
load(path2);
plot_lines(lines);
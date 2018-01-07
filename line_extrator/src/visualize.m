% visualize any data
figure;
for idx = 10001:5:10200
    path1 = strcat(num2str(idx),'.pgm');
    path2 = strcat(num2str(idx),'.mat');
    path1 = fullfile('..','..','data','rgb',path1);
    path2 = fullfile('..','..','data','lines',path2);

    load(path2);
    imshow(imread(path1));
    plot_lines(lines);
    
    pause(0.25);
end
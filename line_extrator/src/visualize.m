% visualize any data
figure;
for idx = 10140:1:10140
    disp(idx)
    path1 = strcat(num2str(idx),'.pgm');
    path2 = strcat(num2str(idx),'.mat');
    path1 = fullfile('..','..','data','rgb',path1);
    path2 = fullfile('..','..','data','lines',path2);

    load(path2);
    imshow(imread(path1));
    plot_lines(lines);
    
    pause(0.5);
end
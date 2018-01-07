addpath('../../common')

img_path = fullfile('..','..','data','rgb');
lines_path = fullfile('..','..','data','lines');
io = IOData(img_path,lines_path);

figure;
for idx = 10011:1:10021
    imshow(io.read_pgm(idx));
    pause(0.2);
end

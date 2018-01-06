% test IOData
img_path = fullfile('..','data','rgb');
lines_path = fullfile('..','data','lines');
io = IOData(img_path,lines_path);

[img,flag]  = io.read_pgm(61);
imshow(img);
disp(flag);
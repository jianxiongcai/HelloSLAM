addpath(fullfile('..','common'));

img_path = fullfile('..','data','TUM');
lines_path = fullfile('..','data','lines');

saving_path = fullfile('..','data','rgb');
mkdir(saving_path);

io = IOData(img_path,lines_path);

idx = 1;
while(1)
    [img, flag] = io.read_png(idx);
    
    % check if file exist
    if (flag == 0)
        break;
    end
    
    saving_name = fullfile(saving_path,strcat(num2str(idx),'.pgm'));
    imsave(img,saving_name);
    disp(saving_name);
end
disp('Done');
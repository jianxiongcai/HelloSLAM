% read in vedio frames
vedio_path = fullfile('..','..','data','1','Video-2017-12-18-18-59-21_0280.mov');
saving_folder = fullfile('..','..','data','1','rgb');

% create saving path
try
    mkdir(saving_folder);
catch 
    disp('[OK] Create saving folder');
end

% extract frames and save to the folder
v = VideoReader(vedio_path);
frame_id = 1;
while (hasFrame(v))
    f = readFrame(v);
    % save each indivual frames to file system
    file_path = fullfile(pwd,saving_folder,strcat(num2str(frame_id),'.png'));
    imwrite(f,file_path);
    frame_id = frame_id + 1;
end
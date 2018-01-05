% read in video frames
% video_paths = {'activity_room_1_video','activity_room_2_video','dorm_room_1_video','dorm_room_2_data','elevator_1_video','elevator_2_video'};
data_dir = fullfile('..','..','data');
video_paths = dir(fullfile(data_dir,'*.mp4'));
video_path = fullfile(data_dir,video_paths(1).name);
[~,video_name,~] = fileparts(video_path);

% saving_folder = fullfile(data_dir,video_name);
saving_folder = fullfile(data_dir,'rgb');
mkdir(saving_folder);

% extract frames and save to the folder
v = VideoReader(video_path);
frame_id = 1;
while hasFrame(v)
    f = readFrame(v);
    img =  imrotate(f,-90);
    % save each indivual frames to file system
    file_path = fullfile(pwd,saving_folder,strcat(num2str(frame_id),'.pgm'));
    imwrite(img,file_path);
    disp(strcat('[OK] frame_id: ',num2str(frame_id)));
        
    frame_id = frame_id + 1;
end
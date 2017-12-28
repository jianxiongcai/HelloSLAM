% read in vedio frames
vedio_paths = {'activity_room_1_video','activity_room_2_video','dorm_room_1_video','dorm_room_2_data','elevator_1_video','elevator_2_video'};
% vedio_paths = {'activity_room_1_video'};
% vedio_path = fullfile('..','..','data','test','Video-2017-12-18-20-31-46_0283.MOV');
% saving_folder = fullfile('..','..','data','test','rgb');

for k = 1:1:size(vedio_paths,2)
    vedio_path = fullfile('..','..','data',strcat(vedio_paths{k},'.mp4'));
    saving_folder = fullfile('..','..','data',vedio_paths{k});
    mkdir(saving_folder);
    
    % extract frames and save to the folder
    v = VideoReader(vedio_path);
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
end
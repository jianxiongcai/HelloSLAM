% read in video frames
% video_paths = {'activity_room_1_video','activity_room_2_video','dorm_room_1_video','dorm_room_2_data','elevator_1_video','elevator_2_video'};
video_paths = {'171229T132838video','171229T133050video'};


for k = 1:1:size(video_paths,2)
    video_path = fullfile('..','..','data',strcat(video_paths{k},'.mp4'));
    saving_folder = fullfile('..','..','data',video_paths{k});
    mkdir(saving_folder);
    
    % extract frames and save to the folder
    v = VideoReader(video_path);
    if(k == 1)frame_id = 1514525318573.9;
    else frame_id = 1514525450759.83;
    end
    cnt = 0;
    while hasFrame(v)
        f = readFrame(v);
        % img =  imrotate(f,-90);
        % save each indivual frames to file system
        file_path = fullfile(pwd,saving_folder,strcat(num2str(frame_id),'.pgm'));
        if mod(cnt,3) == 0
            imwrite(f,file_path);
            disp(strcat('[OK] frame_id: ',num2str(frame_id)));
        end
        frame_id = frame_id + 1/30 * 1000;
        cnt = cnt + 1;
    end
end
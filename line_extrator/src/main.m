% the main function for merging lines
% Remember to verify the threshold
[video_paths,video_names] = get_video_names(fullfile('..','..','data'));

for  i = 1:1:size(video_paths,2)
    [txt_paths, txt_names] = get_txt_paths(video_paths{i});
    saving_dir = fullfile('..','..','data',strcat(video_names{i},'-merge'));
    mkdir(saving_dir);
    
    parfor j = 1:size(txt_paths,2)
        disp(strcat('Processing ',txt_paths{j}));
        % read in all lines and merge lines
        lines = merge_lines_img(0.05*1080,pi/180,0.05*1080, txt_paths{j} );
        % save lines to txt files
        saving_name = fullfile(saving_dir,txt_names{j});
        [temp_path, temp_name] = fileparts(saving_name);
        mat_name = fullfile(temp_path, strcat(temp_name,'.mat'));
        save_lines(mat_name, lines);
    end
end


function [video_path, video_names] = get_video_names(dir_path)
    video_path = {};
    video_names = {};
    dirs = dir(dir_path);
    for i = 1:1:size(dirs,1)
        if ((dirs(i).isdir == 1) && (strcmp(dirs(i).name,'.') == 0) &&...
                (strcmp(dirs(i).name,'..')==0) &&...
                (strcmp(dirs(i).name,'__MACOSX')==0))
            video_path{end+1} = fullfile(dir_path,dirs(i).name);
            video_names{end+1} = dirs(i).name;
        end
    end
end

function [txt_paths, txt_names] = get_txt_paths(video_path)
    txt_paths = {};
    txt_names = {};
    files = dir(fullfile(video_path,'*.txt'));
    for i = 1:1:size(files,1)
        if (files(i).isdir == 0)
            txt_paths{end+1} = fullfile(video_path,files(i).name);
            txt_names{end+1} = files(i).name;
        end
    end
end

function save_lines(fname, lines)
    save(fname, 'lines');
end
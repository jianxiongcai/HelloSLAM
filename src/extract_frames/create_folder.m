function create_folder( folder )
% create a folder if it doesn't exist so far

% create saving path
try
    mkdir(folder);
catch 
    disp('[OK] Create saving folder');
end

end


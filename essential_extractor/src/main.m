%%%
% Hello SLaM 
% Essential & [R t] Extraction
%%%
clear;
clc;

load('cameraParams.mat');
dList = dir('../../data/180101T174834video/*.pgm');
features = cell(2,length(dList));
validPts = cell(1,length(dList));
essential = cell(1,length(dList)-1);
RT = cell(1,length(dList)-1);

K = cameraParams.IntrinsicMatrix';

for i = 1:length(dList)
    tic
    im = imread(fullfile(dList(i).folder,dList(i).name));
    %ims{i} = rgb2gray(ims{i});
    features{1,i} = detectSURFFeatures(im);
    features{2,i} = extractFeatures(im,features{1,i});
    toc
end

for i = 1:length(dList)-1
    indexPairs = matchFeatures(features{2,i},features{2,i+1});
    matchedPoints1 = features{1,i}(indexPairs(:,1));
    matchedPoints2 = features{1,i+1}(indexPairs(:,2));
    essential{i} = estimateEssentialMatrix(matchedPoints1,matchedPoints2,cameraParams);
    homoptsA = [matchedPoints1.Location ones(size(matchedPoints1.Location, 1), 1)]';
    A_temp = K\homoptsA;
    A_norms = sqrt(sum(A_temp.*A_temp));
    A_normalized = double(A_temp./repmat(A_norms, 3, 1));
    homoptsB = [matchedPoints2.Location ones(size(matchedPoints2.Location, 1), 1)]';
    B_temp = K\homoptsB;
    B_norms = sqrt(sum(B_temp.*B_temp));
    B_normalized = double(B_temp./repmat(A_norms, 3, 1));
    [RT{i}, ~] = opengv('fivept_stewenius_ransac', A_normalized, B_normalized);
end

save('RT.mat','RT');
save('essential.mat','essential');
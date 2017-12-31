function [g_sph, M] = extractManhattan(K,dList,Rraw,videopath)
    % Process the line datas from LSD
    lines = cell(size(dList,1),1);
    for i = 1:size(dList,1)
        fid = fopen(fullfile('..','data',videopath,dList(i).name));
        lines_raw = textscan(fid,'%f %f %f %f %f %f %f');
        fclose(fid);
        lines{i} = [lines_raw{1} lines_raw{2} lines_raw{3} lines_raw{4}];
    end
    M = cell(size(dList,1),1);
    % Create a discrete gaussian sphere of 10201 vectors, and one more dimension for votes.
    [sx,sy,sz] = sphere(100);
    g_sph = [sx(:) sy(:) sz(:)]';
    votes = zeros(1,10201);
    C = K;
    % lns: lines;lbg: beginning of line;led: end of line.
    for i = 1:size(dList,1)
       lns = lines{i,1}; 
       lbg = [lns(:,1:2) ones(size(lns,1),1)]';
       led = [lns(:,3:4) ones(size(lns,1),1)]';
       R = rotationVectorToMatrix(Rraw(i,:));
       % X_homo = R'*inv(K)*X
       C = R'*C;
       lbg_h = C\lbg;
       led_h = C\led;
       for j = 1:size(lns,1)
           a = lbg_h(:,j);
           b = led_h(:,j);
           pt = cross(a,b)./(norm(cross(a,b)));
%            parfor k = 1:10201
%                v = g_sph(:,k);
%                angle = abs(90-atan2d(norm(cross(pt,v)),dot(pt,v)));
%                if angle < 0.03*180/pi
%                    tmp = votes(1,k);
%                    tmp = tmp + sqrt(dot(pt,pt));
%                    votes(1,k) = tmp;
%                end
%            end
       end
    end
    sort_votes = sort(votes,'descend');
    [m,n] = find(sort_votes());
    C = K;
    for i = 1:size(dList,1)
       lns = lines{i,1};
       lbg = [lns(:,1:2) ones(size(lns,1),1)]';
       led = [lns(:,3:4) ones(size(lns,1),1)]';
    end
end
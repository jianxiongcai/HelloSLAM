function [P, M] = extractManhattan(K,dList,Rraw,vp)
    % Process the line datas from LSD
    lines = cell(size(dList,1),1);
    for i = 1:size(dList,1)
        fid = fopen(fullfile('..','data',vp,dList(i).name));
        lines_raw = textscan(fid,'%f %f %f %f %f %f %f');
        fclose(fid);
        lines{i} = [lines_raw{1} lines_raw{2} lines_raw{3} lines_raw{4}];
    end
    
    % lns: lines;lbg: beginning of line;led: end of line.
    M = cell(size(dList,1),1);
    for i = 1:size(dList,1)
       lns = lines{i,1}; 
       lbg = [lns(:,1:2) ones(size(lns,1),1)]';
       led = [lns(:,3:4) ones(size(lns,1),1)]';
       R = rotationVectorToMatrix(Rraw(i,:));
       % X_homo = R*inv(K)*X
       lbg_h = K\lbg;
       led_h = K\led;
       P = zeros(3,size(lns,1));
       VP = zeros(3,((size(lns,1)+1)*size(lns,1))/2);
       for j = 1:size(lns,1)
           a = lbg_h(:,j);
           b = led_h(:,j);
           norm(a)
           norm(b)
           pt = cross(a,b)./(norm(a)*norm(b));
           P(:,j) = pt;
       end
%        cnt_vp = 1;
%        for j = 1:(size(lns,1)-1)
%            for k = j+1:size(lns,1)
%                vp = cross(P(:,i),P(:,j));
%                VP(:,cnt_vp) = vp;
%                cnt_vp = cnt_vp + 1;
%            end
%        end
    end
    
    
    

end
%%%
% Preprocessing of Manhattan frame extraction.
% First we generate a gaussian sphere then project the lines onto the 
% gaussian sphere, which genenerates a intepretation plane. To cast the 
% votes, we find the norm vector of the intepretation plane and calculate 
% the angle between the norm vector and each vectors in the discretized 
% gaussian sphere. If the angle is smaller than a threshold (e.g. 0.03 rad)
% , then the vector on gaussian sphere will add the length of the line as 
% one vote.
%%%
function [g_sph,votes] = vote(K,dList,Rraw)
    % Create a discrete gaussian sphere of 10201 vectors, and one more 
    % dimension for votes.
    [sx,sy,sz] = sphere(100);
    g_sph = [sx(:) sy(:) sz(:)]';
    votes = zeros(1,10201);
    C = K;
    % Vote to the gaussian sphere
    % lns: lines;lbg: beginning of line;led: end of line.
    for i = 1:size(dList,1)
       disp(strcat('Voting: ',num2str(i)));
       load(fullfile(dList(i).folder,dList(i).name)); 
       lbg = [lines(1:2,:);ones(1,size(lines,2))];
       led = [lines(3:4,:);ones(1,size(lines,2))];
       R = rotationVectorToMatrix(deg2rad(Rraw(i,:)));
       % X_homo = R'*inv(K)*X
       C = R'*C;
       lbg_h = C\lbg;
       led_h = C\led;
       for j = 1:size(lines,1)
           a = lbg_h(:,j);
           b = led_h(:,j);
           pt = cross(a,b)./(norm(cross(a,b)));
           parfor k = 1:10201
               v = g_sph(:,k);
               % Calculate the angle between the norm and the sphere
               % vectors, if the angle is around 90 degrees, then vote the
               % length of the line to the corresponding votes.
               angle = acosd(dot(pt,v)/norm(pt)/norm(v));
               if (angle > 180)
                   angle = 360 - angle;
               end
               angle = abs(90-angle);
               if angle < rad2deg(0.02)
                   tmp = votes(1,k);
                   tmp = tmp + sqrt(dot(pt,pt));
                   votes(1,k) = tmp;
               end
           end
       end
    end
end
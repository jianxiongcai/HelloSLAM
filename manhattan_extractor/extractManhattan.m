function [M,lns] = extractManhattan(g_sph,votes,dList,Rraw,K)
    % Manhattan frame extraction(only extract the frame from 1st frame)
    sorted_votes = sort(votes,'descend');
    for i = 1:100
        z = [0;0;1];
        idx = find(votes == sorted_votes(i));
        ptz = g_sph(:,idx(1));
        angle = acosd(dot(ptz,z)/norm(ptz)/norm(z));
        if (angle > 180)
            angle = 360 - angle; 
        end
        if (angle < 40)
            man_z = ptz;
            break
        end
    end

    %man_z = [0;0;1];
    
    for i = 1:500
        idx = find(votes == sorted_votes(i));
        ptx = g_sph(:,idx(1));
        angle = acosd(dot(ptx,man_z)/norm(ptx)/norm(man_z));
        if (angle > 180)
            angle = 360 - angle; 
        end
        angle = abs(90 - angle);
        if (angle < 3)
            man_x = ptx;
            disp(i);
            break
        end
    end
    
    for i = 1:500
        idx = find(votes == sorted_votes(i));
        pty = g_sph(:,idx(1));
        angle1 = acosd(dot(pty,man_z)/norm(pty)/norm(man_z));
        if (angle1 > 180)
            angle1 = 360 - angle1; 
        end
        angle1 = abs(90 - angle1);
        angle2 = acosd(dot(pty,man_z)/norm(pty)/norm(man_z));
        if (angle2 > 180)
            angle2 = 360 - angle2; 
        end
        angle2 = abs(90 - angle2);
        if (angle1 < 20 && angle2 < 20)
            man_y = pty;
            disp(i);
            break
        end
    end
    
    C = K;
    
    M = [man_x man_y man_z]
    for i = 1:size(dList,1)
        disp(strcat('Marking: ',num2str(i)));
        lines = load(fullfile(dList(i).folder,dList(i).name));
        lns{i} = lines.lines;
        marker = zeros(1,size(lns{i},2));
        lbg = [lns{i}(1:2,:);ones(1,size(lns{i},2))];
        led = [lns{i}(3:4,:);ones(1,size(lns{i},2))];
        R = rotationVectorToMatrix(deg2rad(Rraw(i,:)));
        C = R'*C;
        lbg_h = C\lbg;
        led_h = C\led;
        for j = 1:size(lns{i},1)
            a = lbg_h(:,j);
            b = led_h(:,j);
            pt = cross(a,b)./(norm(cross(a,b)));
            for k = 1:3
                m = M(:,k);
                angle = acosd(dot(pt,m)/norm(pt)/norm(m));
                if (angle > 180)
                    angle = 360 - angle;
                end
                angle = abs(90 - angle);
                 if (angle < 5)
                    marker(:,j) = k;
                    break
                 end
            end
        end
        lns{i} = [lns{i};marker];
    end
            
end
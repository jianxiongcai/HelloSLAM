% calculate the minimum distance for the point to the line
function [dist] = point_to_line_dist(point,line)
    % make sure the line are of n*1
    if ((size(point,2) ~= 1) || (size(line,2) ~= 1))
        error('point/line is of wrong dimension')
    end
    % get the distance for the point to each endpoint
    d1 = get_distance(point, line(1:2,1));
    d2 = get_distance(point, line(3:4,1));
    
    % calculate the projection distance
    % projection on the line
    v = point-line(1:2,1);

    s = line(3:4,1) - line(1:2,1);
    sp1 = ((v'*s)/(s'*s)) * s;
    sp2 = sp1-s;
    % p is the projection point on the line
    p = line(1:2,1) + sp1;
    
    % if the projection point is in the line
    if (sp1'*sp2 < 0)
        dist = norm(p - point);
    else
        dist = min([d1 d2]); 
    end
end
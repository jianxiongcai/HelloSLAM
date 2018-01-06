% calculate the minimum distance for the point to the line
function [dist] = point_to_line_dist(point,line)
    % get the distance for the point to each endpoint
    d1 = get_distance(point, line(1:2,1));
    d2 = get_distance(point, line(3:4,1));
    
    % calculate the projection distance
    % projection on the line
    v1 = point-line(1:2,1);
    v2 = point-line(3:4,1);
    % if the projection point is in the line
    if (v1'*v2 < 0)
        s = line(1:2,1) - line(3:4,1);
        sp = ((v1'*s)/(s'*s)) * s;
        dist = norm(v1-sp);
    else
        dist = min([d1 d2]); 
    end
end

function [dist] = get_distance(point1, point2)
    dist = norm([point1(1)-point2(1), point1(2) - point2(2)]);
end
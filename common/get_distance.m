function [dist] = get_distance(point1, point2)
    dist = norm([point1(1)-point2(1), point1(2) - point2(2)]);
end
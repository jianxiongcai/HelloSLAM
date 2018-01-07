function [ d ] = compute_lines_dist( line1, line2 )
    % get the distance between two line with endpoint computation
    d1 = point_to_line_dist(line1(1:2,1),line2(1:4,1));
    d2 = point_to_line_dist(line1(3:4,1),line2(1:4,1));
    d3 = point_to_line_dist(line2(1:2,1),line1(1:4,1));
    d4 = point_to_line_dist(line2(3:4,1),line1(1:4,1));
    d = min([d1 d2 d3 d4]);

end


% get the line orientation in rad.
% Input: A line
% Output: a number [0,pi)
function [ori] = get_line_oriention(line_in)
    % chcek input demision
    if ((size(line_in,1) < 4) || (size(line_in,2) ~= 1))
        error('The line is of wrong demision');
    end
    y = line_in(4) - line_in(2);
    x = line_in(3) - line_in(1);
    ori = atan(y/x);
    
    if (ori < 0)
        ori = ori + pi;
    end
end
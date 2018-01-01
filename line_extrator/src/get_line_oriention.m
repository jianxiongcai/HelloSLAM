function [ori] = get_line_oriention(line_in)
    y = line_in(4) - line_in(2);
    x = line_in(3) - line_in(1);
    ori = atan(y/x);
    
    if (ori < 0)
        ori = ori + pi;
    end
end
function [width] =  get_line_width(line_in)
    width = norm([line_in(1)-line_in(3); line_in(2) - line_in(4)]);
end
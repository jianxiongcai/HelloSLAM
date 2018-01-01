function [length] =  get_line_length(line_in)
    length = norm([line_in(1)-line_in(3); line_in(2) - line_in(4)]);
end
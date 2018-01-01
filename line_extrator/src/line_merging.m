% merge two line using the approach proposed in the paper:
% Tavares, J. (1995). 
% A new approach for merging edge line segments. RecPad95, (January). 
% Retrieved from http://repositorio-aberto.up.pt/handle/10216/420

function [ res_line ] = line_merging( line1, line2)
% Input:
%   line1, line2:           two lines to be merge, in the form of
%                           [x1; y1; x2; y2]
width1 = get_line_width(line1);
width2 = get_line_width(line2);
% starting point
a = [line1(1); line1(2)];
b = [line1(3); line1(4)];
c = [line2(1); line2(2)];
d = [line2(3); line2(4)];

% centroid
G = [(width1 * (a(1) + b(1)) + width2 * (c(1) + d(1)))/(2*(width1 + width2));...
    (width1 * (a(2) + b(2)) + width2 * (c(2) + d(2)))/(2*(width1 + width2))];

theta1 = get_line_oriention(line1);
theta2 = get_line_oriention(line2);

% theta G is garteened to lie widthin 0-180(pi)
thetaG = (width1 * theta1 + width2 * theta2)/(width1 + width2);

% from frame G to frame W
R = [cos(thetaG) -sin(thetaG); sin(thetaG) cos(thetaG)];
T = [G(1); G(2)];

% translate points from world frame to G frame
ag = R' * (a - T);
bg = R' * (b - T);
cg = R' * (c - T);
dg = R' * (d - T);

% the final starting point and end point
% take the largest element along x direction
Sg = [min([ag(1) bg(1) cg(1) dg(1)]); 0];
Fg = [max([ag(1) bg(1) cg(1) dg(1)]); 0];

S = R * Sg + T;
F = R * Fg + T;

res_line = [S; F];

end

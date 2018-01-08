% World_Point Refinement.

% This Part includes two parts. The first is using the endpoint in frame A
% to calculate the epipolar line in frame B. The intersection with the line
% in frame B means the position of the endpoints. It is meanless to do in 
% an opposite way because we do not know which frame is more accurate.
% The second part is used the refined endpoint to calculate the world
% coordinates of these endpoints.

function world_point = get_3D_point(E, RT, start_A, end_A, start_B, end_B)
% E is the essential matrix. (3*3)
% RT is the rotation and transformation from frame A to B.
% start and end only means the endpoints of lines, no direct difference. A 
% and B means two frames. All points illustrates in homography. (3*1)

% Calculate the epipolar lines in opposite frames.
epipolar_line_start_A = E*start_A;
epipolar_line_end_A = E*end_A;
k1 = -epipolar_line_start_A(1,1)/epipolar_line_start_A(2,1);
b1 = -epipolar_line_start_A(3,1)/epipolar_line_start_A(2,1);
k2 = -epipolar_line_end_A(1,1)/epipolar_line_end_A(2,1);
b2 = -epipolar_line_end_A(3,1)/epipolar_line_end_A(2,1);

% Calculate the line in frame B.
start_B = start_B./start_B(3,1);
end_B = end_B./end_B(3,1);
x1 = start_B(1,1);
y1 = start_B(2,1);
x2 = end_B(1,1);
y2 = end_B(2,1);
k = (y1-y2)/(x1-x2);
b = (x1*y2-x2*y1)/(x1-x2);

% Calculate the intersection point with current line and epipolar line.
new_start_B = [(b1-b)/(k-k1); (k*b1-b*k1)/(k-k1); 1];
new_end_B =  [(b2-b)/(k-k2); (k*b2-b*k2)/(k-k2); 1];

% Calculate the world frame cordinates for these two endpoints.
X1 = start_A(1,1);
Y1 = start_A(2,1);
X2 = new_start_B(1,1);
Y2 = new_start_B(2,1);
A = [X1*[0,0,1,0]-[1,0,0,0];
     Y1*[0,0,1,0]-[0,1,0,0];
     X2*RT(3,:)-RT(1,:);
     Y2*RT(3,:)-RT(2,:)];
[~,~,V] = svd(A);
world_point = V(:,4)./V(4,4);

X1 = end_A(1,1);
Y1 = end_A(2,1);
X2 = new_end_B(1,1);
Y2 = new_end_B(2,1);
B = [X1*[0,0,1,0]-[1,0,0,0];
     Y1*[0,0,1,0]-[0,1,0,0];
     X2*RT(3,:)-RT(1,:);
     Y2*RT(3,:)-RT(2,:)];
[~,~,V] = svd(B);
world_point = [world_point V(:,4)./V(4,4)];

end

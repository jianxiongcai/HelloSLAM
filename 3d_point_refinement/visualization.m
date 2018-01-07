% Visualization.
% This is the final part in this project, mainly focus on output all the
% lines after detecting, tracting, merging, refining and as a display of 
% 3D line cloud.

function visualization(world_points)

% World_points should be a matrix with size like 3*2n, the three rows are 
% xyz coordinates for endpoints. And for each two columns, the first column 
% is endpoint A, and the second is endpoint B. The two are counted as a 
% line.

figure;
hold on;
for i = 1:2:size(world_points, 2)
    X = world_points(1,i:i+1);
    Y = world_points(2,i:i+1);
    Z = world_points(3,i:i+1);
    plot3(X,Y,Z)
end

end
% Find world coordinates for feature points.

function world_point = find_3D_point(points_A, points_B, R)

    world_point = zeros(size(points_A,2), 4);

    for i = 1:size(points_A,2)
        X1 = points_A(1,i);
        Y1 = points_A(2,i);
        X2 = points_B(1,i);
        Y2 = points_B(2,i);
        A = [X1*[0,0,1,0]-[1,0,0,0];
             Y1*[0,0,1,0]-[0,1,0,0];
             X2*R(3,:)-R(1,:);
             Y2*R(3,:)-R(2,:)];
        [~,~,V] = svd(A);
        world_point(i, :) = V(:,4)'./V(4,4);
    end

end
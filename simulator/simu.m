% tracking simulator
function [line1, line2,R,T,E] = simu(line_3d)
    pointS = [line_3d(1:3); 1];
    pointE = [line_3d(4:6); 1];

    P1 = [eye(3,3) zeros(3,1)];
    % rotation and translation matrix
     R =     [1.0000         0         0;
              0    0.4081   -0.9129;
              0    0.9129    0.4081;];
    %R = eye(3);
    T = [1;1;1];
    % essential matrix
    Tx = [0 -T(3) T(2) ; T(3) 0 -T(1) ; -T(2) T(1) 0 ];
    E = R * Tx ;

    P2 = [R T];

    K = eye(3,3);

    line1_S = project_to_2d(K, P1, pointS);
    line1_E = project_to_2d(K, P1, pointE);
    line2_S = project_to_2d(K, P2, pointS);
    line2_E = project_to_2d(K, P2, pointE);

    line1 = [line1_S(1:2); line1_E(1:2)];
    line2 = [line2_S(1:2); line2_E(1:2)];

    E * line1_S;
    E * line1_E;
end
function [point2d] =  project_to_2d(K, P, point3d)
    point2d = K * P * point3d;
    point2d = point2d/point2d(3);
end
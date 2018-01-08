% tracking simulator
line_3d = [0;0;0;1;1;1];
pointS = [line_3d(1:3); 1];
pointE = [line_3d(4:6); 1];

P1 = [eye(3,3) zeros(3,1)];
% rotation and translation matrix
R = eye(3,3);
T = [1;1;0];
% essential matrix
Tx = [0 -T(3) T(2) ; T(3) 0 -T(1) ; -T(2) T(1) 0 ];
E = R * Tx;

P2 = [R T];

K = eye(3,3);

line1_S = K * P1 * pointS;
line1_E = K * P1 * pointE;
line2_S = K * P2 * pointS;
line2_E = K * P2 * pointE;

line1 = [line1_S(1:2); line1_E(1:2)];
line2 = [line2_S(1:2); line2_E(1:2)];
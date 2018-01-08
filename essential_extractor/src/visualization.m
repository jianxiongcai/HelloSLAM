%%%%%%%
% Hello SLaM 
% Visualization of the trajectory of the camera.
%%%%%%%

%%
clear;
clc;

load('RT.mat');
traj = [0;0;0;1];
for iter= 1:length(RT)
    traj = [traj [RT{iter};0 0 0 1] * traj(:,iter)];
end

figure
plot3(traj(1,:),traj(2,:),traj(3,:));
view(-90,90)
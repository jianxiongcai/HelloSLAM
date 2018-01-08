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

plot3(traj(1,1),traj(2,1),traj(3,1),'x');
plot3(traj(1,2:end),traj(2,2:end),traj(3,2:end));
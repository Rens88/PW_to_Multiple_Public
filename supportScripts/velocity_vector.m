function [vv] = velocity_vector (traj,time)

vv = (1 / (time(3) - time(1)) ) * (traj(3:size(traj,1),:) - traj(1:size(traj,1)-2,:)) ;
vv = [(1 / (time(2) - time(1)) ) * (traj(2,:) - traj(1,:)); vv];
vv = [vv; (1 / (time(2) - time(1)) ) * (traj(size(traj,1),:) - traj(size(traj,1)-1,:))];

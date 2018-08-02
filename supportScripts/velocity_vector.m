function [vv] = velocity_vector (traj,time)
% VELOCITY_VECTOR:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% Code made available in the Matlab library from Anne-Helen Olivier
%
% - traj = a vector containing the X and Y positions
% - time = the time corresponding to the trajectory
%
% Output:
% - vv = the velocity vector
vv = (1 / (time(3) - time(1)) ) * (traj(3:size(traj,1),:) - traj(1:size(traj,1)-2,:)) ;
vv = [(1 / (time(2) - time(1)) ) * (traj(2,:) - traj(1,:)); vv];
vv = [vv; (1 / (time(2) - time(1)) ) * (traj(size(traj,1),:) - traj(size(traj,1)-1,:))];

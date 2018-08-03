function [tti,mpd,vba] = interactionPredictions(p1,p2,time,varargin)
% INTERACTIONPREDICTIONS:
% Collision avoidance with multiple walkers: Sequential or simultaneous interactions?
%
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
%
% Submitted to: Frontiers in Psychology
%
% MATLAB Code used for the data analysis
%
% Any queries about the code should be addressed to rensmeerhoff@gmail.com
% Re-use of the code for non-commercial purposes is permitted with proper reference to the published article.
% Re-use of the code for commercial purposes needs to be requested with L. A. Meerhoff (rensmeerhoff@gmail.com)
%
%
% 10-06-2018 L.A. Meerhoff
% Last update of the code to make it readable for publication.
% Script computes three predictions of an interaction between objects in motion. 
% Predictions are made linearly, so will not be accurate for any non-linear trajectories.
% 
% INPUT:
% The required input consists of the X & Y positions and velocity vectors (also X & Y) of two moving objects/persons.
% 	p1 = (X-pos object 1, Y-pos object 1)
% 	p2 = (X-pos object 2, Y-pos object 2)
% 	time = the time-series corresponding to the positions.
%
% Optional input is 'absMPD' (1 = absolute MPD, 0 = signed MPD). 
% Absolute MPD will only assign positive values to MPD.
% The signed MPD will assign negative values to MPD when object 1 is crossing behind object 2.
%
% OUTPUT:
% Output consists of:
% tti --> time to interaction
% mpd --> minimal predicted distance
% vba --> velocity of bearing angle; Note that the computation of vba is unverified (Rens, 4-4-2017)
%

%%
absMPD = 1;
mult = 1;

if nargin == 5
    % absMPD 0 calculates signed MPD
    % absMPD 1 calculates absolute MPD
    absMPD = varargin{1};
end

% Compute the velocity vectors
v1 = velocity_vector(p1,time);
v2 = velocity_vector(p2,time);

% Note that the computation of vba is unverified (Rens, 4-4-2017)
ba = atan2(p2(:,2)-p1(:,2),p2(:,1)-p1(:,1));
vba = gradient(ba);

n = size(p1,1);
for i=1:n
    p1x = p1(i,1);
    p1y = p1(i,2);
    p2x = p2(i,1);
    p2y = p2(i,2);
    v1x = v1(i,1);
    v1y = v1(i,2);
    v2x = v2(i,1);
    v2y = v2(i,2);
    
    if absMPD == 0
        % the time until each of the participants reaches the position where the
        % trajectories cross
        
        % correction I implemented for virtual trajectories of exactly 0
        if v2x == 0
            v2x = 0.0001;
        end
        % X-position where the trajectories of object 1 and 2 intersect
        x_int = ((v1y / v1x) *  p1x - (v2y / v2x) * p2x + p2y - p1y) * (v1y/v1x - v2y/v2x)^-1;

        % Time until intersection for each object
        t1 = (x_int - p1x) / v1x;
        t2 = (x_int - p2x) / v2x;
        
        % Sign is based on who first reaches the intersection
        if t1 < t2
            mult = 1;
        else
            mult = -1;
        end
    end
    
    % Without velocity, MPD and TTI cannot be computed.
    if isnan(v1x) || isnan(v2x)
        mpd(i) = NaN;
        tti(i) = NaN;
        
    else
        
        ax = v2x-v1x;
        bx = p2x-p1x;
        
        ay = v2y-v1y;
        by = p2y-p1y;
        
        a = 2*(ax*ax+ay*ay);
        b = 2*(ax*bx+ay*by);
        p = [a b];
        
        if max(isnan(p)) == 1
            tti(i) = NaN;
        elseif isempty(roots(p))
            tti(i) = NaN;
        else
            tti(i) = roots(p);
        end
        
        pos1tti = [(p1x + v1x * tti(i)); (p1y + v1y * tti(i))];
        pos2tti = [(p2x + v2x * tti(i)); (p2y + v2y * tti(i))];
        
        mpd(i) = norm (pos2tti - pos1tti) * mult;
        
        if isnan(mpd(i))
            tti(i) = NaN;
        end
        
    end
end

end

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

end
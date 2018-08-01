% Collision avoidance with multiple walkers: Sequential or simultaneous interactions?
%
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
%
% Submitted to: Frontiers in Psychology
%
% MATLAB Code used for the data analysis
%
% Any queries about the code should be addressed to rensmeerhoff@gmail.com Re-use of the code for non-commercial purposes is permitted with proper reference to the published article. Re-use of the code for commercial purposes needs to be requested with L. A. Meerhoff (rensmeerhoff@gmail.com)
%
% 10-06-2018 L.A. Meerhoff \n
% This script can be used to try out interactionPredictions.m and dynamicGap.m with some mock-data.

nFrames = 100;

time = 1:nFrames;
p1(1,1) = -5;
p1(1,2) = 0;

p2(1,1) = -0.5;
p2(1,2) = -5;

p3(1,1) = 0.5;
p3(1,2) = -5;

% Distance they should cover in 100 frames
dist_BIG = [7 * 0.9 + rand(1)*0.2 7 * 0.9 + rand(1)*0.2 7 * 0.9 + ...
    rand(1)*0.2];
dist_SMALL = [rand(1)-0.5 rand(1)-0.5 rand(1)-0.5];

for i = 2:nFrames 
    % Big variation
    p1(i,1) = p1(i-1,1) + dist_BIG(1) / nFrames * (0.9 + rand(1)*0.2);
    p2(i,2) = p2(i-1,2) + dist_BIG(2) / nFrames * (0.9 + rand(1)*0.2);
    p3(i,2) = p3(i-1,2) + dist_BIG(3) / nFrames * (0.9 + rand(1)*0.2);
    
    % Small variation
    p1(i,2) = p1(i-1,2) + dist_SMALL(1) / nFrames * (0.95 + rand(1)*0.1);
    p2(i,1) = p2(i-1,1) + dist_SMALL(2) / nFrames * (0.95 + rand(1)*0.1);
    p3(i,1) = p3(i-1,1) + dist_SMALL(3) / nFrames * (0.95 + rand(1)*0.1);
end

% One way to establish the end of the interaction is based on the
% interpersonal distance. If it is at its minimum, it is no 
% longer useful to continue to compute DG:

% Interpersonal Distance
IPD12 = sqrt((p1(:,1) - p2(:,1)).^2 + (p1(:,2) - p2(:,2)).^2);
IPD13 = sqrt((p1(:,1) - p3(:,1)).^2 + (p1(:,2) - p3(:,2)).^2);

% Time at minimal distance
[~,tMD12] = min(IPD12);
[~,tMD13] = min(IPD13);

lastFrame_interactions = [tMD12 tMD13];

absMPD = 0;
[tti12,mpd12,vba12] = interactionPredictions(p1,p2,time,absMPD);
[tti13,mpd13,vba13] = interactionPredictions(p1,p3,time,absMPD);
out = dynamicGap(p1,p2,p3,time,lastFrame_interactions);
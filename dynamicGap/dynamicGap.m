% Collision avoidance with multiple walkers: Sequential or simultaneous interactions?
%
%
%
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
%
% Submitted to: Frontiers in Psychology
%
% MATLAB Code used for the data analysis
% %
% Any queries about the code should be addressed to rensmeerhoff@gmail.com
% Re-use of the code for non-commercial purposes is permitted with proper reference to the published article. Re-use of the code for commercial purposes needs to be requested with L. A. Meerhoff (rensmeerhoff@gmail.com).
%
% 10-06-2018 L.A. Meerhoff
% Last update of the code to make it readable for publication.
%
% INPUT:
% The required input consists of the X & Y positions and velocity vectors (also X & Y) of two moving objects/persons.
% p1 = (X-pos object 1, Y-pos object 1)
% p2 = (X-pos object 2, Y-pos object 2)
% p3 = (X-pos object 3, Y-pos object 3)
% v1 = (X-vel object 1, Y-vel object 1)
% v2 = (X-vel object 2, Y-vel object 2)
% v3 = (X-vel object 3, Y-vel object 3)
% lastFrame_interactions = (end12, end13) --> the last frame up until where the analysis should continue (typically until W1 has passed both W2 and W3.
%
% OUTPUT:
% The output is a struct containing timeseries of:
% - dynamicGap --> DG as used in the paper
% - gap_0_isClosed --> A version of DG where the gap is set to 0 when it
% was closed
% - gap12 --> The gap restriction with respect to W2
% - gap13 --> The gap restriction with respect to W3
% - WC --> the walker that is constraining the gap (upon which DG is based,
% i.e., the min(gap12,gap13)
% - DG_pct --> The percentage that each walker contributed to the gap. (not
% included in the publication)
%
%
%

function out = dynamicGap(p1,p2,p3,time,lastFrame_interactions)

% analysis stops after Pp1 has crossed both intersections
tend = max([lastFrame_interactions(1) lastFrame_interactions(2)]);

% Compute the velocity vectors
v1 = velocity_vector(p1,time);
v2 = velocity_vector(p2,time);
v3 = velocity_vector(p3,time);

n = size(p1,1);
temp.gap_0_isClosed = NaN(n,1);
temp.dynamicGap = NaN(n,1);
temp.gap12 = NaN(n,1);
temp.gap13 = NaN(n,1);
temp.WC = NaN(n,1); % Walker that Contributes
out = temp;
temp.lastFrame_interactions = lastFrame_interactions;

tempNo1 = temp;
tempNo2 = temp;
tempNo3 = temp;

cont1 = zeros(n,1);cont23 = cont1;

for i=1:tend
    if isnan(v1(i,1)) || isnan(v2(i,1)) || isnan(v3(i,1))
        temp.gap_0_isClosed(i) = NaN;
        temp.dynamicGap(i) = NaN;
        temp.gap12(i) = NaN;
        temp.gap13(i) = NaN;
    else
        p1x = p1(i,1);
        p1y = p1(i,2);
        p2x = p2(i,1);
        p2y = p2(i,2);
        p3x = p3(i,1);
        p3y = p3(i,2);
        
        v1x = v1(i,1);
        v1y = v1(i,2);
        v2x = v2(i,1);
        v2y = v2(i,2);
        v3x = v3(i,1);
        v3y = v3(i,2);
        
        % inserted this to avoid 0 velocity (only the case in VR
        % experiments)
        if v2x == 0
            v2x = .0001;
        end
        if v3x == 0
            v3x = .0001;
        end
        
        temp = calcGap(p1x,p1y,p2x,p2y,p3x,p3y,v1x,v1y,v2x,v2y,v3x,v3y,temp,i);
        if i ~= 1
            nov1 = v1(i-1,:);
            nov2 = v2(i-1,:);
            nov3 = v3(i-1,:);
            
            tempNo1 = calcGap(p1x,p1y,p2x,p2y,p3x,p3y,nov1(1),nov1(2),v2x,v2y,v3x,v3y,tempNo1,i);
            tempNo2 = calcGap(p1x,p1y,p2x,p2y,p3x,p3y,v1x,v1y,nov2(1),nov2(2),v3x,v3y,tempNo2,i);
            tempNo3 = calcGap(p1x,p1y,p2x,p2y,p3x,p3y,v1x,v1y,v2x,v2y,nov3(1),nov3(2),tempNo3,i);
            
            if temp.WC(i) == 2 % W2 contributed to dynamicGap
                cont1(i) = cont1(i-1) + abs(abs(temp.dynamicGap(i)) - abs(tempNo1.dynamicGap(i)));
                cont23(i) = cont23(i-1) + abs(abs(temp.dynamicGap(i)) - abs(tempNo2.dynamicGap(i)));
            elseif temp.WC(i) == 3
                cont1(i) = cont1(i-1) + abs(abs(temp.dynamicGap(i)) - abs(tempNo1.dynamicGap(i)));
                cont23(i) = cont23(i-1) + abs(abs(temp.dynamicGap(i)) - abs(tempNo3.dynamicGap(i)));
            else % not sure if this is possible. No assignment of contributing walker..
                dbstop if error
                erorr('check this, something wrong with WC')
            end
            
        end
    end
end
% % not sure about this one. Initially I only took gaps from first ~nan
% % value. If I revert back to it, I may want to apply it also to Pct cont.
% s = find(~isnan(temp.gap_0_isClosed),1,'first');s1 = find(~isnan(temp.dynamicGap),1,'first');
% s2 = find(~isnan(temp.gap12),1,'first');s3 = find(~isnan(temp.gap13),1,'first');
s = 1;s1 = 1;s2 = 1;s3 = 1;
out.gap_0_isClosed(s:tend) = temp.gap_0_isClosed(s:tend);
out.dynamicGap(s1:tend) = temp.dynamicGap(s1:tend);
out.gap12(s2:tend) = temp.gap12(s2:tend);
out.gap13(s3:tend) = temp.gap13(s3:tend);


% Could also choose to obtain timeSeries of PC here.
PercTotal1 = cont1(1:tend) ./ (cont1(tend) + cont23(tend) ) .* 100;
PercTotal23 = cont23(1:tend) ./ (cont1(tend) + cont23(tend) ) .* 100;
WC = temp.WC;
timePct2 = sum(WC == 2) / ( sum(WC == 2) + sum(WC == 3)) *100;
timePct3 = sum(WC == 3) / ( sum(WC == 2) + sum(WC == 3)) *100;
nrSwitches = nansum(abs(WC(2:end) - WC(1:end-1)));
out.DG_pct = [PercTotal1(end) PercTotal23(end) timePct2 timePct3 nrSwitches];
out.WC = WC;
end



% This is where the gap is actually computed.
function out = calcGap(p1x,p1y,p2x,p2y,p3x,p3y,v1x,v1y,v2x,v2y,v3x,v3y,in,i)

if i > 2 % virtualGap12prev doesnt exist at the start
    virtualGap12prev = in.virtualGap12prev;
    virtualGap13prev = in.virtualGap13prev;
end
gap_0_isClosed = in.gap_0_isClosed;
dynamicGap = in.dynamicGap;
gap12 = in.gap12;
gap13 = in.gap13;
lastFrame_interactions = in.lastFrame_interactions;
WC = in.WC;

% % 1)	With a given p and v, where will the trajectories intersect?
% time that Pp1 reaches intersection12
it12_1 = ( ( (p1y - p2y) / v2y) - ( (p1x - p2x) / v2x) ) / ((v1x / v2x ) - (v1y / v2y));
% time that Pp2 reaches intersection12
it12_2 = ( ( (p2y - p1y) / v1y) - ( (p2x - p1x) / v1x) ) / ((v2x / v1x ) - (v2y / v1y));
% time that Pp1 reaches intersection13
it13_1 = ( ( (p1y - p3y) / v3y) - ( (p1x - p3x) / v3x) ) / ((v1x / v3x ) - (v1y / v3y));
% time that Pp2 reaches intersection13
it13_3 = ( ( (p3y - p1y) / v1y) - ( (p3x - p1x) / v1x) ) / ((v3x / v1x ) - (v3y / v1y));

% interaction position
ip12(1) = p1x + v1x*it12_1;
ip12(2) = p1y + v1y*it12_1;
ip13(1) = p1x + v1x*it13_1;
ip13(2) = p1y + v1y*it13_1;

% % 2)	When the reference walker (i.e., Pp1) reaches ip, where is the other?
vip2(1) = p2x + v2x*it12_1;
vip2(2) = p2y + v2y*it12_1;
vip3(1) = p3x + v3x*it13_1;
vip3(2) = p3y + v3y*it13_1;

% % 3)	Determine virtual gap (vg) between Pps
virtualGap12 = sqrt(abs(ip12(1,1) - vip2(1,1)).^2 + abs(ip12(1,2) - vip2(1,2)).^2 );
virtualGap13 = sqrt(abs(ip13(1,1) - vip3(1,1)).^2 + abs(ip13(1,2) - vip3(1,2)).^2 );

% % 4) Determine if Pp1 has already passed the communal point
if i > lastFrame_interactions(1) % vdc12 < cdc12
    % Pp1 already crossed ip12, therefore gap should not be updated
    virtualGap12 = virtualGap12prev;
end
if i > lastFrame_interactions(2)
    % Pp1 already crossed ip13, therefore gap should not be updated
    virtualGap13 = virtualGap13prev;
end

% % 5) Classify the gap size based on vg
if (it12_1 < it12_2 && it13_1 < it13_3) || (it12_1 > it12_2 && it13_1 > it13_3)
    % closed gap
    gap_0_isClosed(i) = 0;
    [preGap1, WCtemp] = min([virtualGap12 virtualGap13]); % WC = Walker that Contributes
    dynamicGap(i) = -preGap1;
else
    % open gap
    gap_0_isClosed(i) = min([virtualGap12 virtualGap13]);
    [dynamicGap(i), WCtemp]  = min([virtualGap12 virtualGap13]);
end

WC(i) = WCtemp + 1; % + 1 to equal 2 & 3 corresponding to W2 & W3
if (it12_1 > it12_2)
    gap12(i) = - virtualGap12;
else
    gap12(i) = virtualGap12;
end
if (it13_1 > it13_3)
    gap13(i) = - virtualGap13;
else
    gap13(i) = virtualGap13;
end
virtualGap12prev = virtualGap12;
virtualGap13prev = virtualGap13;

out.gap_0_isClosed = gap_0_isClosed;
out.dynamicGap = dynamicGap;
out.gap12 = gap12;
out.gap13 = gap13;
out.gap23 = gap13 - gap12;
out.virtualGap12prev = virtualGap12prev;
out.virtualGap13prev = virtualGap13prev;
out.lastFrame_interactions = lastFrame_interactions;
out.it12_1 = it12_1;
out.it13_1 = it13_1;
out.WC = WC;
end

function [vv] = velocity_vector (traj,time)

vv = (1 / (time(3) - time(1)) ) * (traj(3:size(traj,1),:) - traj(1:size(traj,1)-2,:)) ;
vv = [(1 / (time(2) - time(1)) ) * (traj(2,:) - traj(1,:)); vv];
vv = [vv; (1 / (time(2) - time(1)) ) * (traj(size(traj,1),:) - traj(size(traj,1)-1,:))];

end
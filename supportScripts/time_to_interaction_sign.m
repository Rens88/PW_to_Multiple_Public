% Rens Meerhoff
% Input required is the position and velocity vectors of two agents.
% Optional input is 'absMPD' (1 = absolute MPD, 0 = signed MPD)

% Output consists of:
% tti --> time to interaction
% mpd --> minimal predicted distance
% cba --> constant bearing angle
% % NICOLAS: Note that the computation of cba is unverified (Rens, 4-4-2017)

function [tti,mpd,cba] = time_to_interaction_sign(p1,v1,p2,v2,varargin)
absMPD = 1;
mult = 1;
if nargin == 5
    % absMPD 0 calculates signed MPD
    % absMPD 1 calculates absolute MPD
    absMPD = varargin{1};
    
end

% NICOLAS: Note that the computation of cba is unverified (Rens, 4-4-2017)
ba = atan2(p2(:,2)-p1(:,2),p2(:,1)-p1(:,1));
cba = gradient(ba);

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
        x_int = ((v1y / v1x) *  p1x - (v2y / v2x) * p2x + p2y - p1y) * (v1y/v1x - v2y/v2x)^-1;
        t1 = (x_int - p1x) / v1x;
        t2 = (x_int - p2x) / v2x;
        
        if t1 < t2
            mult = 1;
        else
            mult = -1;
        end
    end
    
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
        % %                 figure(1)
        % %                 plot([L1_x1 L1_x2],[L1_y1 L1_y2],':b');hold on;
        % %                 plot([L2_x1 L2_x2],[L2_y1 L2_y2],':r');hold on;
        % %
        % %                 plot(pos1tti(1), pos1tti(2),'*b');
        % %                 plot(pos2tti(1), pos2tti(2),'*r'); % position when distance is min
        % %
        % %                 plot(p1(1,1), p1(1,2),'xb');
        % %                 plot(p2(1,1), p2(1,2),'xr'); % starting position
        % %
        % %                 plot(p1x, p1y,'<b')
        % %                 plot(p2x, p2y,'^r') % current pos
        % %
        % %                 plot(intersect(1),intersect(2),'ok') % position where tracks cross.
        % %                 plot([intersect(1) L1_x2],[intersect(2) L1_y2],'--b');hold on;
        % %                 plot([intersect(1) L2_x2],[intersect(2) L2_y2],'--r');hold on;
        % % %         % % % % % % % % %
        % % %
        
    end
end

end
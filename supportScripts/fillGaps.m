%% 28-5-2013, Rens Meerhoff
% Fill gaps of missing data
% Where 'in' contains the data in
% Optional input is the old_time and new_time, which otherwise are
% specified as the length of 'in'.

function [out, gaps, longestGap] = fillGaps(in,varargin)

temp = find(isnan(in));
gaps = temp;
temp2 = [0;find(temp(2:end) - temp(1:end-1) > 1); length(temp)];
longestGap = max(temp2(2:end) - temp2(1:end-1));


if nargin == 1
    orig_time(1,:) = 1:length(in);
    new_time = orig_time;
else
    orig_time = varargin{1};
    new_time = varargin{2};
end

ind = isnan(in(:,1));
in(ind,:) = [];

orig_time(ind) = [];


out = interp1(orig_time,in,new_time,'spline');

end
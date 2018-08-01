function [av, sd, n, se] = dataSummary(data)
% Summarizing data
av = nanmean(data,2);
sd = nanstd(data,0,2);
nse = nansum(~isnan(data),2);%min(sum(~isnan(data),2));
se = sd ./ sqrt(nse);
n = min(nse);
end
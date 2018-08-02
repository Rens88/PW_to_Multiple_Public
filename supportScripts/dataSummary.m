function [av, sd, n, se] = dataSummary(data)
% DATASUMMARY:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% Summarizing data
av = nanmean(data,2);
sd = nanstd(data,0,2);
nse = nansum(~isnan(data),2);%min(sum(~isnan(data),2));
se = sd ./ sqrt(nse);
n = min(nse);
end
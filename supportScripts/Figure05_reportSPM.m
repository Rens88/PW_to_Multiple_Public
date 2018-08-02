function Figure05_reportSPM(out)
% FIGURE05_REPORTSPM:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% out - contains the data from PW_to_Multiple_Public.mat
% varargin - contains which formations should be included and whether the figures should be combined in a subplot
%
% collection of scripts to run figure 05, the overview of SPM analyses

%%
[d2_125,d1,output3D,outputLabel3D,output3D_DG,output3D_ID,outputLabel3D_gap] = ...
    combineAll_ResultsLMM(out,2:10,1); % Figures 1, 2 & 5: Formation [0 & 2m 0 deg] & 2m 90 deg, W23 averaged

end
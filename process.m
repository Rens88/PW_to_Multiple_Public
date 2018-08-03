%% Rens Meerhoff - 01-08-2018
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology

%% This file
% can be used to call the relevant support scripts to create the indicated
% figures. It includes a succinct description of the data. The code is made
% available so researchers can use, improve or explore the data used for
% the paper described above. Please reference the paper when using any of
% the code.

% This script is the summary script to analyze the data:
% PW_to_Multiple_Public.mat
% The available data is organized in a struct with 120 trials by 4
% different experimental groups.
% For each trial, the following information is presented in the struct:

%% PW_to_Multiple_Public.mat
% This struct contains all (meta)data relevant for the paper.
% - timeseries variables that were computed based on the raw
% data separately contain the data from each group and each trial*:
% -> timeSeries - The time is in seconds.
% -> universalTimeSeriesTend - The time is in seconds where all trials are
%       synchronized on t(end)
% -> multiverseTimeSeries - The time is relative from t(start) = 0% until
%       t(end) = 100%
% -> timeSeriesLabel - The labels that indicate which variable is stored in
%       which column
% -> rawMovementData - The (unordered) raw movement with the X and Y
%       coordinates of walker 1, 2 and 3
%
% Additionally, there is a range of metaData available:
% - formation - The formation of which walker is in which position.
% - formationLabel - The labels corresponding to formation
%
% - adaptation - Information about each walkers' adaptation.
% - adpatationLabel - the labels explaining the columns of adaptation.
%
% - crossed - Some information about who crossed in front.
% - crossedLabel - The labels explaining crossed
%
% - timing - Some information about the timing within a trial
% - timingLabel - The labels explaining timing
%
% - MPDinversions - Some information about whether inversions occurred
% - MPDinversionsLabel - The labels explaining MPDinversions
%
% - roles - The roles of each walker
% - rolesLabel - The labels explaining roles
%
% - nDGswitch - The number of times the closest walker (i.e., the one
%       determining DG) switched during a trial.
%
% - posnegStart - An indicator value that was used to assess on which side
%       the trial started.
%
% *with i referring to the columns (i.e., groups) and j referring to the rows (i.e., trials):
% if any(j == [10 11 30 31 50 51 70 71 90 91 110 111])
%--> dyadic interactions
% if i == 4 && j == 69
%--> the trial with missing data at the start of the the trial (the remaining data is still in the .mat file)
% if out{j,i}.formation(10) == .3
%--> a formation that was not a part of the experiment (in the scripts, it is always skipped)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data and add library
addpath('supportScripts')

addpath(['supportScripts' filesep 'SPM'])
load(['data' filesep 'PW_to_Multiple_Public.mat'])
% Create a folder to store the figures if it doesn't already exist
if ~exist('Figs','dir')
    disp('NOTE: There was no <Figs> folder, so it was created automatically.')
    disp('All plots are stored in this folder:')
    disp([cd filesep 'Figs'])
    mkdir('Figs')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting procedures as used for manuscript submitted to Frontiers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Figure 2:
% A) the participants? speed over time in a triadic trial that
% was used to establish tstart. B) the participants? change in heading over
% time. C) Interpersonal distance between W1 & W2 and between W1 & W3 from
% which the time at minimal distance (tMD) can be derived.
Figure02(out)

%% Figure 3:
% Exemplar data of one triadic trial showing the difference
% between the Minimal Predicted Distance (MPD, panel A), Interaction
% Distance (ID, panel B) and Dynamic Gap (DG, panel C). The solid and
% dashed line refer to the interactions between Walker1 (W1) & Walker 2
% (W2) (i.e., interaction between W1 and W2, I12), and between W1 and W3
% (i.e., interaction between W1 and W3, I13), respectively. The vertical
% lines in panel B indicate which interaction had the smallest absolute ID
% and upon which DG was based. The dotted horizontal line extending I12 in
% panel A and B denotes that the specific values were no longer updated as
% the time of minimal distance (tMD12) had already passed. See also Video 1
% in the supplementary material for an animated display.
Figure03(out);
Video_Figure03_presentation(out)

%% Figure 4:
% Positioning of all walkers in three exemplar triadic
% interactions where W1 was predicted to cross in front (panel A), through
% (panel B) and behind (panel C) the gap. The ? indicates the current
% position of each walker. The solid lines up until ? depict the
% trajectory up until the current point in time. The dashed lines from ?
% denote the predicted trajectories upon which the future positions of each
% walker are at the instant of minimal distance (tMD12) (*) and tMD13 (?).
% The distance between each * and ? corresponds with the ID, which is
% projected on the right in each panel as a portal that Walker 1 (W1) is
% predicted to pass through (panel B) or not (panel A and C). DG is the
% distance to the closest side of the projected portal.
Figure04(out);% % % %

%% Figure 5 (INCLUDES the SPM statistics):
% Mean (? SE) the minimal predicted distance between Walker 1 & 2 and
% between Walker 1 & 3 (MPD12, dashed line; MPD13, dotted line,
% respectively) over time per formation. A horizontal line above the plots
% indicates when MPD12 (?) and MPD13 (?) are significantly different from
% the pairwise MPDDyadic (solid line) after a Bonferroni correction was
% applied. When the difference did not start at tstart, small vertical
% bars were added to indicate first instant MPD was different from
% MPDDyadic.
Figure05_reportSPM(out); % Includes SPM

%% Figure 6:
% Gap crossing behavior (i.e., in front, through or behind) of Walker 1
% (W1) relative to the other walkers in the triadic trials as a percentage
% per starting formation.
Figure06(out)

%% Figure 7:
% Distribution of the Interaction Distance (ID) in the triadic trials to
% both Walker 2 (W2) and Walker 3 (W3) at tstart (panel A) and tend (panel
% B). The colors indicate the final crossing order, the open circles
% indicate trials with a Dynamic Gap (DG) inversion. The dashed horizontal
% and vertical lines indicate the border between crossing in front and
%behind the other walker. When crossing behind both W2 and W3 (IDs < 0 m)
% or in front of both W2 and W3 (IDs > 0 m), the gap between them is closed
% for Walker 1 (W1).
Figure07_reportInversion(out,'MPD',.1)
Video_Figure07_paper(out,'MPD',1,.1)

%% Figure 8:
% Average (?SE) Dynamic Gap (DG) over time in the triadic trials comparing
% through without (solid), and with inversion (dotted), around with
% (dashed), and without inversion (dash-dot). Positive DG values denote
% that the gap between Walker 2 and 3 (W2 and W3) is predicted to be open
% for Walker 1 (W1). Conversely, Negative DG values predict a closed gap.
% The DG value at tend represents the gap crossing behavior. Each of these
% lines was significantly different from each other from tstart until tend;
% except for through and around with inversion, and for through with and
% without inversion. For the latter two, the significance bars above the
% figure indicate when the difference was significant.
alphaCorrection = 6;
for i = 0:6
    DG = Figure08_reportDG(out,'MPD',i,alphaCorrection,.1); % DG
end
% Note that in the paper i = 2 was reported:
Figure08_reportDG(out,'MPD',2,6,.1); % DG
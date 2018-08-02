01-08-2018
Rens Meerhoff
For questions, contact rensmeerhoff@gmail.com.

Data from
'Collision avoidance with multiple walkers Sequential or simultaneous interactions'
Authored by Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
Submitted to Frontiers in Psychology

Note that the data itself will be made available through the journal's website.
To run the sample analyses, download the data and store it in a folder called 'data' (this folder).

The code can be found on https://github.com/Rens88/PW_to_Multiple_Public
The generic code to run the dynamic gap analysis is stored in the folder 'dynamicGap'.
The folder 'supportScripts' contains all support scripts necessary to run 'process.m', which contains the code to run the analyses that were presented in the paper.

*****************************
PW_to_Multiple_Public.mat 
This struct contains all (meta)data relevant for the paper.
- timeseries variables that were computed based on the raw
data separately contain the data from each group and each trial*:
-> timeSeries - The time is in seconds.
-> universalTimeSeriesTend - The time is in seconds where all trials are 
      synchronized on t(end)
-> multiverseTimeSeries - The time is relative from t(start) = 0% until
      t(end) = 100%
-> timeSeriesLabel - The labels that indicate which variable is stored in
      which column
-> rawMovementData - The (unordered) raw movement with the X and Y 
      coordinates of walker 1, 2 and 3

Additionally, there is a range of metaData available:
- formation - The formation of which walker is in which position.
- formationLabel - The labels corresponding to formation

- adaptation - Information about each walkers' adaptation.
- adpatationLabel - the labels explaining the columns of adaptation.

- crossed - Some information about who crossed in front.
- crossedLabel - The labels explaining crossed

- timing - Some information about the timing within a trial
- timingLabel - The labels explaining timing

- MPDinversions - Some information about whether inversions occurred
- MPDinversionsLabel - The labels explaining MPDinversions

- roles - The roles of each walker
- rolesLabel - The labels explaining roles

- nDGswitch - The number of times the closest walker (i.e., the one
      determining DG) switched during a trial.

- posnegStart - An indicator value that was used to assess on which side
      the trial started.

*with i referring to the columns (i.e., groups) and j referring to the rows (i.e., trials):
if any(j == [10 11 30 31 50 51 70 71 90 91 110 111])
--> dyadic interactions
if i == 4 && j == 69
--> the trial with missing data at the start of the the trial (the remaining data is still in the .mat file)
if out{j,i}.formation(10) == .3
--> a formation that was not a part of the experiment (in the scripts, it is always skipped)
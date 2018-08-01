% collection of scripts to run figure 05, the overview of SPM analyses

function Figure05_reportSPM(out)

[d2_125,d1,output3D,outputLabel3D,output3D_DG,output3D_ID,outputLabel3D_gap] = ...
    combineAll_ResultsLMM(out,2:10,1); % Figures 1, 2 & 5: Formation [0 & 2m 0 deg] & 2m 90 deg, W23 averaged

disp('Paint: Crop legend, white fill starting positions, crop figure')

end
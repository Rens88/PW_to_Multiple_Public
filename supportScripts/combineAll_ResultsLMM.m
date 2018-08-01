% Create a 3D dataset that can be easily accessed for comparing time-series
% with PW and each of the other formations
% Allows you also to create all possible plots, comparing the pairwise
% formation with each of the group formations.

function [d_out, d1,output3D,outputLabel3D,output3D_DG,output3D_ID,outputLabel3D_gap] = combineAll_ResultsLMM(out,varargin)
%% Reference participant
% 2 = W2, 3 = W3, 23 = both W2 & W3
refPp = 2:3;
%% Reference variable
% 2 = MPD, 6 = gradient(MPD) ... (could include more, but will have to
% changes axes and filenames
refVar = 2;
%% Omit trials with inversion
% 0 = include all trials, 1 = omit trials where MPD(start) = -MPD(end)
omitInversion = 0;
%% Split plots for crossing order
% 0 = merge crossing 1st and 2nd, 1 = plot separately W1 crossing 1st and 2nd
splitCrossingOrder = 0;
%% formations to be included
if nargin == 1
    formationsInd = 2:10;
else
    formationsInd = varargin{1};
end
%% Whether all plots should be combined in one awesome subplot
if nargin == 3
    combine_for_paper = 1;
else
    combine_for_paper = 0;
end
count_d = 0;
saveInfo =[];
save_d2_W2 = [];
save_d2_W3 = [];

W1first = [];
W1first_pw = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
countPlot = 0;
inclCorrection = 1; % always include, it simply means that negative MPDs always correspond with an MPD opposite of the MPD at crossing.
for refPpind = refPp
    mult_ntrial = 1;
    if refPpind == 2
        refPpString = 'W2';
    elseif refPpind == 3
        refPpString = 'W3';
    elseif refPpind == 23
        refPpString = '23';
        if countPlot == 0
            countPlot = 216;
            mult_ntrial = 2;
        end
    else
        error('couldnt establish pp')
    end
    for refVarind = refVar
        
        if refVarind == 2
            ystring = 'MPD (m)';
            var = 'MPDpos';
            YVals = [0 3 -3 3]; % specifying for both the left and right plot
        elseif refVarind == 6
            ystring = 'MPD gradient (m/s)';
            var = 'MPDvel';
            % Wide axis range
            % YVals = [-0.323e-03 .2053e-03 -4 4]; % specifying for both the left and right plot
            % More conservative
            YVals = [-0.0443e-03 .1199e-03 -4 4]; % specifying for both the left and right plot
        end
        
        for omitInversioInd = omitInversion
            if omitInversioInd  == 0
                inv = 'incInv';
            else
                inv = 'excInv';
            end
            
            for splitCrossingOrderInd = splitCrossingOrder
                
                fieldstring = 'multiverseTimeSeries'; % could change this to 'universalTimeSeries' or universalTimeSeriesRel3'
                fieldstringDG = 'universalTimeSeriesTend';
                [nframe, nvar] = size(out{1,1}.(fieldstring));
                firstFrame = 1;
                lastFrame = 1000;
                [nframeDG, nvar] = size(out{1,1}.(fieldstringDG)(firstFrame:lastFrame,:));
                
                ntrial = 48*mult_ntrial; % there are 48 trials per formation
                nform = 10; % there are 10 formation (where PW is included as a formation)
                
                output3D = NaN(nframe,ntrial,nform);
                output3D_DG  = NaN(nframeDG,ntrial,nform);
                output3D_ID  = NaN(nframeDG,ntrial,nform);
                outputLabel3D_gap = NaN(1,ntrial,nform);
                outputLabel3D = NaN(1,ntrial,nform);
                crossOrder3D = NaN(1,ntrial,nform);
                for i = 1:4
                    for j = 1:120
                        if ~(i == 4 && j == 69)
                            
                            if max(j == [10 11 30 31 50 51 70 71 90 91 110 111]) ~= 1
                                pairWise = 0;
                                if refPpind == 2
                                    curCol = refVarind;
                                elseif refPpind == 3
                                    curCol = refVarind+1;
                                elseif refPpind == 23
                                    curCol = [refVarind refVarind+1];
                                else
                                    error('wrong refPp selected')
                                end
                                if out{j,i}.formation(10) ~= .3 % exclude 0.3 m
                                    W1first = [W1first; out{j,i}.crossed(1:2)];
                                end
                            else
                                pairWise = 1;
                                curCol = refVarind;
                                W1first_pw = [W1first_pw; out{j,i}.crossed(1)];
                            end
                            temp = out{j,i}.(fieldstring)(:,curCol(1));
                            tempDG = out{j,i}.(fieldstringDG)(firstFrame:lastFrame,55);
                            tempID12 = abs(out{j,i}.(fieldstringDG)(firstFrame:lastFrame,56));
                            tempID13 = abs(out{j,i}.(fieldstringDG)(firstFrame:lastFrame,57));
                            
                            curForm = out{j,i}.formation(8)+2;
                            
                            if pairWise == 1
                                curForm = 1;
                            end
                            % crossOrder: 1 is W1inf, -1 = W1beh
                            crossOrder = (temp(nframe) / abs(temp(nframe)));
                            gap = tempDG(end) / abs(tempDG(end)); % 1 = through, -1 = around
                            if inclCorrection == 1
                                temp = temp*crossOrder;
                            end
                            curTrial = find(isnan(output3D(1,:,curForm)),1,'first');
                            % inversion: 1 is no inversion, -1 = inversion
                            inversion = (temp(1)/abs(temp(1))) * (abs(temp(nframe)) / abs(temp(nframe)));
                            if ~(omitInversioInd == 1 && inversion == -1)
                                output3D(1:nframe,curTrial,curForm) = temp(1:nframe,:);
                                output3D_ID(1:nframeDG,curTrial,curForm) = tempID12(1:nframeDG,:);
                                
                            end
                            crossOrder3D(1,curTrial,curForm) = crossOrder;
                            if any(curForm == [9 10])
                                Label3D = 1; % purple
                            elseif any(curForm == [5 2 3 7])
                                Label3D = 2; % green
                            elseif any(curForm == [6 4 8])
                                Label3D = 3; % yellow
                            else
                                Label3D = 4;
                            end
                            outputLabel3D(1,curTrial,curForm) = Label3D;
                            
                            if refPpind == 23 && pairWise == 0
                                % and now for W3
                                temp = out{j,i}.(fieldstring)(:,curCol(2));
                                
                                curForm = out{j,i}.formation(8)+2;
                                
                                if pairWise == 1
                                    curForm = 1;
                                end
                                % crossOrder: 1 is W1inf, -1 = W1beh
                                crossOrder = (temp(nframe) / abs(temp(nframe)));
                                
                                if inclCorrection == 1
                                    temp = temp*crossOrder;
                                end
                                curTrial = find(isnan(output3D(1,:,curForm)),1,'first');
                                % inversion: 1 is no inversion, -1 = inversion
                                inversion = (temp(1)/abs(temp(1))) * (abs(temp(nframe)) / abs(temp(nframe)));
                                if ~(omitInversioInd == 1 && inversion == -1)
                                    output3D(1:nframe,curTrial,curForm) = temp(1:nframe,:);
                                    % output3D_DG(1:nframeDG,curTrial,curForm) = tempDG(1:nframeDG,:);
                                    if isnan(tempDG(1))
                                        disp('hi')
                                    end
                                    output3D_DG(1:nframeDG,curTrial-1,curForm) = tempDG(1:nframeDG,:);
                                    for q = 1:nframeDG
                                        if tempID13(q,:) < tempID12(q,:)
                                            output3D_ID(q,curTrial-1,curForm) = tempID13(q,:);
                                        end
                                    end
                                    
                                    
                                end
                                crossOrder3D(1,curTrial,curForm) = crossOrder;
                                if any(curForm == [9 10])
                                    Label3D = 1;
                                elseif any(curForm == [5 2 3 7])
                                    Label3D = 2;
                                elseif any(curForm == [6 4 8])
                                    Label3D = 3;
                                else
                                    Label3D = 4;
                                end
                                outputLabel3D(1,curTrial,curForm) = Label3D;
                                outputLabel3D_gap(1,curTrial-1,curForm) = gap ;
                            end
                        end
                    end
                end
                
                formations = {'Pairwise','0m_000deg','2m_000deg', ...
                    '4m_000deg','2m_-45deg','4m_-45deg','2m_090deg',...
                    '4m_090deg','2m_045deg','4m_045deg'};
                
                if splitCrossingOrderInd == 0
                    splitTrials = 1;
                    ord = 'all';
                    
                else
                    splitTrials = [1 2];
                    
                end
                % SPM comparison with PW as reference:
                xstring = 'Time (%)';
                for j = splitTrials
                    
                    for i = formationsInd % for each formation
                        if splitCrossingOrderInd == 0
                            selTrial = 1:ntrial;
                            selTrialPW = selTrial;
                        else
                            selTrial = crossOrder3D(1,:,i) == (j*2 - 3);
                            selTrialPW  = crossOrder3D(1,:,1) == (j*2 - 3);
                            if j == 1
                                ord = 'inf';
                            else
                                ord = 'beh';
                            end
                        end
                        d1 = output3D(:,selTrialPW,1); % Reference condition (PW)
                        d2 = output3D(:,selTrial,i); % Tested condition (formation = i-2)
                        
                        countPlot = countPlot + 1;
                        if countPlot < 10
                            countPlotString = ['00' num2str(countPlot)];
                        elseif countPlot < 100
                            countPlotString = ['0' num2str(countPlot)];
                        else
                            countPlotString = num2str(countPlot);
                        end
                        
                        curString.refFormString = 'Pairwise';
                        curString.var = var;
                        curString.form = formations{i};
                        curString.ord = ord;
                        curString.refPp = refPpString;
                        curString.inv = inv;
                        curString.countPlotString = countPlotString;
                        if combine_for_paper == 0
                            frameDiff = spm_run_MPI(d1',d2',curString,xstring,ystring,YVals);
                            timeDiffSign = find(frameDiff == 1,1,'first');
                            disp(timeDiffSign)
                        else
                            %%
                            %%%%%%%%%%%%%%%%%%%%% THIS IS WHERE I RUN SPM
                            
                            alpha = 0.05/8; % manual bonferroni correction
                            [frameDiff, saveInfo] = spm_run_MPI_for_paper(d1',d2',curString,xstring,alpha,saveInfo);
                            timeDiffSign = find(frameDiff == 1,1,'first');
                            if ~isempty(timeDiffSign )
                                timeDiffSign(2) = find(frameDiff == 1,1,'last');
                            end
                            disp([num2str(round(timeDiffSign./size(d1,1).*100),2) '%'])
                            
                            if i > 2 % exclude pairwise AND 0.3m
                                if strcmp(refPpString,'W2')
                                    save_d2_W2 = [save_d2_W2  d2];
                                else
                                    save_d2_W3 = [save_d2_W3  d2];
                                end
                            end
                        end
                        
                        count_d = count_d +1;
                        d_out{count_d} = d2;
                        
                    end
                end
            end
        end
    end
end

% Any inversion happening for PW
tmp1 = nansum(any(d1(:,:)<0));
tmp2 = length(any(d1(:,:)<0));
tmp3 = round(tmp1 / tmp2 * 100);
disp(['Inversion occurred at some instant in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the PAIRWISE interactions'])

% Any inversion happening for W2
tmp1 = nansum(any(save_d2_W2(:,:)<0));
tmp2 = length(any(save_d2_W2(:,:)<0))-1; % -1 because 1 trial is NaN
tmp3 = round(tmp1 / tmp2 * 100);
disp(['Inversion occurred at some instant in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the W12 interactions'])
% Any inversion happening for W3
tmp1 = nansum(any(save_d2_W3(:,:)<0));
tmp2 = length(any(save_d2_W3(:,:)<0))-1;% -1 because 1 trial is NaN
tmp3 = round(tmp1 / tmp2 * 100);
disp(['Inversion occurred at some instant in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the W13 interactions'])

% W1 First
% PW
tmp1 = nansum(W1first_pw(1:48));
tmp2 = length(W1first_pw(1:48));
tmp3 = round(tmp1 / tmp2 * 100);
disp(['W1 first in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the PAIRWISE interactions'])
% W12
tmp1 = sum(W1first(1:383,1));
tmp2 = 383;
tmp3 = round(tmp1 / tmp2 * 100);
disp(['W1 first in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the W12 interactions'])
% W13
tmp1 = sum(W1first(1:383,2));
tmp2 = 383;
tmp3 = round(tmp1 / tmp2 * 100);
disp(['W1 first in ' num2str(tmp1) ' out of ' num2str(tmp2) ' = ' num2str(tmp3) '% of the W13 interactions'])



end
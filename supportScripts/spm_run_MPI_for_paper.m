function [frameDiff,saveInfo] = spm_run_MPI_for_paper(d1,d2,curString,xstring,alphaLevel,saveInfo)
% SPM_RUN_MPI_FOR_PAPER
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% d1 = list of all time-series (equal length) set-up with n-trials as rows and n-timepoints as columns
% d2 = same but for second condition
% conditions = is string input of 2 conditions
% filename = input of filename that serves both as the title in the plot
% and as the filename the figure is saved.
% xstring
%
%
% Example:
% d1 = rand(1000,10);
% d2 = rand(1000,10);
% conditions{1} = 'Condition 1';
% conditions{2} = 'Condition 2';
% filename = 'test';
% xstring = 'Time';
% ystring = 'Output';

%%
expColor = [ 0 0 0];
W12Color = 'r';
W13Color = 'b';

row_000deg = 2;
row_045deg = 1;
row_090deg = 4;
row_m45deg = 3;

sbform([row_000deg row_045deg row_090deg row_m45deg]) = [4 2 8 6];

if strcmp(curString.form,'0m_000deg')
    frameDiff = NaN;
    return
elseif strcmp(curString.form,'2m_000deg')
    sb = row_000deg*3 -1;
elseif strcmp(curString.form,'4m_000deg')
    sb = row_000deg*3 -0;
elseif strcmp(curString.form,'2m_045deg')
    sb = row_045deg*3 -1;
elseif strcmp(curString.form,'4m_045deg')
    sb = row_045deg*3 -0;
    
elseif strcmp(curString.form,'2m_090deg')
    sb = row_090deg*3 -1;
elseif strcmp(curString.form,'4m_090deg')
    sb = row_090deg*3 -0;
elseif strcmp(curString.form,'2m_-45deg')
    sb = row_m45deg*3 -1;
elseif strcmp(curString.form,'4m_-45deg')
    sb = row_m45deg*3 -0;
end

tempFigDir =  'Figs\';
if exist(tempFigDir,'dir') ~= 7
    disp('NOTE: There was no <\Figs\temp> folder, so it was created autmatically.')
    disp('All plots are stored in this folder.')
    mkdir(tempFigDir)
end


if any(any(isnan(d1(:,:))))
    nanCol = any(isnan(d1'));
    if all(d1(nanCol,:))
        % Whole column is empty, simply omit it
        ind = logical(any(isnan(d1'))-1);
        d1 = d1(ind,:);
        disp('WARNING: Empty column was omitted')
    else
        error('missing data, consider filtering or omitting completely')
    end
end

if any(any(isnan(d2(:,:))))
    nanCol = any(isnan(d2'));
    if all(d2(nanCol,:))
        % Whole column is empty, simply omit it
        ind = logical(any(isnan(d2'))-1);
        d2 = d2(ind,:);
        disp('WARNING: Empty column was omitted')
    else
        error('missing data, consider filtering or omitting completely')
    end
end

options   = struct('two_tailed',1);
SPM = spm1d_stats_ttest2(d1, d2);
SPMi = spm1d_inference(SPM, alphaLevel, options);
frameDiff = abs(SPMi.z) > SPMi.zstar;

firstDiff = find(frameDiff == 1,1,'first');
lastDiff = find(frameDiff == 1,1,'last');

% Plot:
fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92;y_width = 22; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);

figHandle = figure(11);%'Position',[100,100,800,350]);
subplot(4,3,sb)
box off
if sb == 1
    title('0.6m Radius')
elseif sb == 2
    title('2m Radius')
elseif sb == 3
    title('4m Radius')
end

if strcmp(curString.refPp,'W2')
    condColor = W12Color;
elseif strcmp(curString.refPp,'W3')
    condColor = W13Color;
end
stString = ':';
if strcmp(curString.refPp,'W2')
    % cheeky legend
    plot([-10 -9],[0 0],'Color',W12Color,'LineStyle','--', 'LineWidth', 1.6);hold on;
    plot([-10 -9],[0 0],'Color',W13Color,'LineStyle',':', 'LineWidth', 1.6);
    plot([-10 -9],[0 0],'Color',expColor, 'LineWidth', 1.6);
    
    [hA0,hA1] = spm1d_plot_meanSE(d1);
    set(hA0, 'color',expColor)
    set(hA1, 'facecolor', expColor )
    set(hA0, 'LineWidth', 1.2)
    stString = '--';
end
hold all
[hB0,hB1] = spm1d_plot_meanSE(d2);


set(hB0, 'color',condColor )
set(hB1, 'facecolor', condColor )
set(hB0, 'lineStyle', stString)
set(hB0, 'LineWidth', 1.6)
frameTime = 1:688;
if strcmp(curString.refPp,'W3') && ~isempty(firstDiff)
    
    frameWHY(1:688) = 2.355;
    l=      plot(frameTime(frameDiff),frameWHY(frameDiff),':b', 'LineWidth', 1.6);
    set(l,'clipping','off')
    
    if any(sb == [6 9 12])    % if there is also a difference for W12.
        text( 1.07*(((lastDiff - firstDiff) / 2) + firstDiff-1),2.435,'*','Color','b','FontSize',14,'HorizontalAlignment','Center')
    else
        text( ((lastDiff - firstDiff) / 2) + firstDiff-1,2.435,'*','Color','b','FontSize',14,'HorizontalAlignment','Center')
    end
    if firstDiff ~= 1
        
        saveInfo = [saveInfo ; sb firstDiff lastDiff frameWHY(1) 0 0 1];
    end
    
elseif strcmp(curString.refPp,'W2') && ~isempty(firstDiff)
    frameWHY(1:688) = 2.3;
    
    l= plot( frameTime(frameDiff),frameWHY(frameDiff),'--r', 'LineWidth', 1.6);hold on;
    
    set(l,'clipping','off')
    
    if any(sb == [6 9 12]) % if there is also a difference for W13.
        text( .93*(((lastDiff - firstDiff) / 2) + firstDiff-1),2.48,'\Delta','Color','r','FontSize',9,'HorizontalAlignment','Center')
    else
        text( ((lastDiff - firstDiff) / 2) + firstDiff-1,2.48,'\Delta','Color','r','FontSize',9,'HorizontalAlignment','Center')
    end
    
    if firstDiff ~= 1
        
        saveInfo = [saveInfo ; sb firstDiff lastDiff frameWHY(1) 1 0 0];
        
    end
    
end


if  ~isempty(firstDiff)
    [~,maxz] = max(abs(SPMi.z));
    disp([curString.form ', ' curString.refPp])
    disp(['SPM sign: z(1, ' num2str(SPMi.df(2)) ') = ' num2str(SPMi.z(maxz)) ', p = ' num2str(SPMi.p)])
    disp(['SPM sign: z(1, ' num2str(SPMi.df(2)) ') = ' num2str(SPMi.z(maxz)) ', CORRECTED p = ' num2str(SPMi.p*(.05/alphaLevel))])
end

legendString1 = [    curString.refFormString '_' curString.ord '_' curString.inv];
legendString2 = [curString.form '_' curString.ord '_' curString.refPp '_' curString.inv];
for q = 1:length(legendString1)
    if strcmp(legendString1(q),'_')
        tempName1(q) = ' ';
    else
        tempName1(q) = legendString1(q);
    end
end
for q = 1:length(legendString2)
    if strcmp(legendString2(q),'_')
        tempName2(q) = ' ';
    else
        tempName2(q) = legendString2(q);
    end
end

set(gca,'XTick',[0 (size(d1,2)/4)*1 (size(d1,2)/4)*2 (size(d1,2)/4)*3 (size(d1,2)/4)*4] , ...
    'XTickLabel',{'0','','50','','100'})
set(gca,'XLim',[0 size(d1,2) ])
set(gca,'YLim',[0 2.25],'YTick',[0 .5 1 1.5 2 ],'YTickLabel',{'0','','1','','2'})

xlabel(xstring)
ylabel('\itMPD\rm (m)')

if strcmp(curString.form,'4m_045deg') && strcmp(curString.refPp,'W3') % last one.
    
    for q = 1:size(saveInfo,1)
        
        subplot(4,3,round(saveInfo(q,1)));hold on;
        l= plot( [ frameTime(saveInfo(q,2)) frameTime(saveInfo(q,2))],[saveInfo(q,4)-.1 saveInfo(q,4)+.1],'-','Color',saveInfo(q,5:7), 'LineWidth', 1.6);hold on;
        set(l,'clipping','off')
        l= plot( [ frameTime(saveInfo(q,3)) frameTime(saveInfo(q,3))],[saveInfo(q,4)-.1 saveInfo(q,4)+.1],'-','Color',saveInfo(q,5:7), 'LineWidth', 1.6);hold on;
        
        set(l,'clipping','off')
    end
    for q = [2 3 5 6 8 9 11 12]
        subplot(4,3,q)
        pos = get(gca, 'Position');
        pos = pos.*[1 1 1 .9];
        set(gca, 'Position', pos)
        
        % Legend name
        if q == 3
            lg = legend('W12 (\Delta)','W13 (*)','PW','Location','NorthEast');
            pos = [0.856041667095075 0.870886424475085 0.150493749995715917 0.0449369025068967];
            pos = pos.*[.98 1.0 1 1];
            
            set(lg,    'Position',pos)%,...
            % 'FontSize',fontsize-1)
            
            legend('boxoff');
            
        end
    end
    
    sbPlus = [1 4 7 10];
    for q = 1:4
        subplot(4,3,sbPlus (q))
        nform = sbform(q);
        % % Add formation visualization:
        Center = [0.5 0.5];%[size(d1,2)/1.6 mean(YVals(3:4))];%[340 -2];
        Radius = [.7 .7];%[size(d1,2)/1.5 (YVals(4)-YVals(3))/1.5];%[300 2];
        % visualizeFormation(nform,Center,Radius)
        hold off
        visualizeFormation_PosOnly_noRadius(nform,Center,Radius)
        % axis([0 1 0 1])
        axis([.2427 .827778 .1454 .8663])
        axis off
    end
    if alphaLevel == .05
        corString = '_uncorrected';
    else
        corString = '_corrected';
    end
    filename = 'Fig05_all_formation_for_paper';
    print(figHandle, '-dtiff', '-r300', [tempFigDir filename corString '.tiff'])
    
    close(figHandle)
end

end
function DG = Figure08_reportDG(out,basedOn,comparison,alphaCorrectie,ingThreshold,varargin)
% FIGURE08_REPORTDG:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% Comparison indicates which colours are maintained and which are turned to
% black and white.
%
% out - contains the data from PW_to_Multiple_Public.mat
% basedOn - contains the (string) reference measure that is compared:
% - MPD = minimal predicted distance (or Distance at Closest approach * code is confirmed to work for MPD
% - BA = the bearing angle
% - ID = the intersection distance
% - DGvel = the gradient of the dynamic gap
% comparison = an integer that specifies which trials are compared (closed, closing, opened, opening)
% alphaCorrectie = the number of multiple comparisons for which alpha needs to be corrected
% ingThreshold = which definition of opening and closing should be used (i.e., the minimum change required to label a trial as closING or openING)
% varargin = (DGvelYes) can be 0 => DG, 1 => DGvel, 2 => betadot
%
% if ingThreshold is 0 --> the previous definition of opening and closing
% if it is any other number then that number corresponds to the last
% percentage where an inverted DG occurred.

%%
plotAsLog = 0;
if nargin > 5
    DGvelYes = varargin{1};
    if DGvelYes == 2
        plotAsLog = varargin{2};
    end
else
    DGvelYes = 0;
end
darkRed = [170 0 0]/255;

lightRed = [255 128 128]/255;

lightGreen = [153 255 153]/255;
darkGreen = [0 150 0] / 255;

%
close all

ct = distinguishable_colors(5);
colorSpecGrey = [100 100 100;0 0 0;160 160 160]/255;
colorSpecGrey = [1 0 0;0 1 0;1 1 0; 0 1 1];
lightGrey = [180 180 180]/255;
darkGrey = lightGrey;%[100 100 100]/255;

if comparison == 0
    colorSpecGrey = [darkRed; lightGreen; darkGreen; lightRed;];
    compString = 'all';
    indAllTrials = 1:4;
elseif comparison == 1
    colorSpecGrey = [darkRed; lightGreen; darkGrey; lightGrey;];
    compString = 'closing_open';
    indAllTrials = 1:2;
elseif comparison == 2
    colorSpecGrey = [darkRed; darkGrey; darkGreen; lightGrey;];
    compString = 'closing_opening';
    indAllTrials = [1 3];
elseif comparison == 3
    colorSpecGrey = [darkRed; lightGrey; darkGrey; lightRed;];
    compString = 'closing_closed';
    indAllTrials = [1 4];
elseif comparison == 4
    colorSpecGrey = [darkGrey; lightGreen; darkGreen; lightGrey;];
    compString = 'open_opening';
    indAllTrials = [2 3];
elseif comparison == 5
    colorSpecGrey = [lightGrey; lightGreen; darkGrey; lightRed;];
    compString = 'open_closed';
    indAllTrials = [2 4];
elseif comparison == 6
    colorSpecGrey = [darkGrey; lightGrey; darkGreen; lightRed;];
    compString = 'opening_closed';
    indAllTrials = [3 4];
    
end


lStyle{2} = '-';
lStyle{1} = '--';
lStyle{3} = ':';
lStyle{4} = '-.';
sp1 = 0; sp3 = 0; sp5 = 0;

sp3_1 = 0; sp3_2 = 0; sp3_3 = 0;
sp_cooc2 =0;sp_cooc1=0;sp_cooc3=0;sp_cooc4=0;

d1n = zeros(9,1);
condIn{1} = 'pw';
condIn{2} = '-45^{o}';
condIn{3} = '0^{o}';
condIn{4} = '45^{o}';
condIn{5} = '90^{o}';
pre_ls = [3 1 2 1 2 1 2 1 2];
pre_qq = [1 2 3 4 5 6 7 8 9];
curN = zeros(3,9);
% create the legend

fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92;y_width =6.5; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);
h15 = figure(15);



for sp = 1:2
    
    figure(15);hold on;
    plot([-1000 -1000],[1000 1001],'Color',colorSpecGrey(sp,:),'LineStyle',lStyle{sp})
end
% the new opening and closing
countIng = 0;
for i = 1:4
    for j = 1:120
        if ~any(j == [10 11 30 31 50 51 70 71 90 91 110 111])
            if ~(i == 4 && j == 69)
                countIng = countIng + 1;
                DGtemp = out{j,i}.universalTimeSeriesTend(:,61);
                opp = abs(DGtemp) ./ DGtemp ~= abs(DGtemp(1000)) / DGtemp(1000);
                if opp(end) ~= 0
                    error('foutje')
                end
                dopp = [1; opp(2:end) - opp(1:end-1)];
                ingTemp(countIng) = find(dopp ~= 0,1,'last');
                
            end
        end
    end
end
tmp =ingTemp;
for i = 1:4
    for j = 1:120
        if ~any(j == [10 11 30 31 50 51 70 71 90 91 110 111])
            if ~(i == 4 && j == 69)
                if out{j,i}.formation(10) ~= .3 % exclude smallest diameter
                    
                    temp = out{j,i}.timeSeries;
                    temp2 = out{j,i}.universalTimeSeriesTend;
                    
                    
                    if out{j,i}.crossed(3) == 1
                        % Crossed
                        sp = 1; % sp = subplot
                        sp1 = sp1+1;
                        curSP = sp1; % nth current subplot for averaging
                        sp3_2 = sp3_2+1;
                        curSP3 = sp3_2; % nth current subplot for averaging
                        cr = 1; % crossing (order)
                        cr3 = 2; % crossing (order)
                    elseif out{j,i}.crossed(1) == 1
                        % 1 crossed first
                        sp = 3;
                        sp3 = sp3+1;
                        cr = 2;
                        curSP = sp3;
                        sp3_1 = sp3_1+1;
                        curSP3 = sp3_1; % nth current subplot for averaging
                        cr3 = 1; % crossing (order)
                        if out{j,i}.crossed(2) == 0
                            error('2 cant have crossed behind')
                        end
                    else
                        % 1 crossed second
                        sp = 5;
                        sp3 = sp3+1;
                        cr = 2;
                        cr3 = 3; % crossing (order)
                        curSP = sp3;
                        sp3_3 = sp3_3+1;
                        curSP3 = sp3_3; % nth current subplot for averaging
                        if out{j,i}.crossed(2) == 1
                            error('2 cant have crossed in front')
                        end
                    end
                    
                    % Save data to plot averages
                    % NB: for cr == 1, gap 2 and gap 3 need to be ordered, otherwise
                    % averages mean nothing
                    if temp2(1000,56) > temp2(1000,57)
                        mostNeg = 57;
                        mostPos = 56;
                    else
                        mostNeg = 56;
                        mostPos = 57;
                    end
                    if temp2(1000,59) > temp2(1000,60)
                        mostNeg_NewDG = 60;
                        mostPos_NewDG = 59;
                    else
                        mostNeg_NewDG = 59;
                        mostPos_NewDG = 60;
                    end
                    
                    
                    MPD12{cr3}(:,curSP3) = temp2(:,59);
                    MPD13{cr3}(:,curSP3) = temp2(:,60);
                    MPDmin{cr3}(:,curSP3) = temp2(:,61);
                    
                    
                    ing = 0; % closING or openING
                    
                    % MPD based - DG inversion
                    if strcmp(basedOn,'MPD')
                        DGinv{cr3}(curSP3) = 0;
                        if ingThreshold == 0
                            if abs(temp2(1,61)) / temp2(1,61) ~= abs(temp2(1000,61)) / temp2(1000,61)
                                %                         '..ing'
                                ing = 1; % closING or openING
                                DGinv{cr3}(curSP3) = 1;
                            end
                        else
                            DGtemp = out{j,i}.universalTimeSeriesTend(:,61);
                            opp = abs(DGtemp) ./ DGtemp ~= abs(DGtemp(1000)) / DGtemp(1000);
                            dopp = [0; opp(2:end) - opp(1:end-1)];
                            
                            if find(dopp ~= 0,1,'last')/10 >= ingThreshold
                                
                                %                         '..ing'
                                ing = 1; % closING or openING
                                DGinv{cr3}(curSP3) = 1;
                                %                                 disp([i j])
                            end
                            
                        end
                    elseif strcmp(basedOn,'BA')
                        DGinv{cr3}(curSP3) = 0;
                        if abs(temp2(1,61)) / temp2(1,61) ~= abs(temp2(1000,61)) / temp2(1000,61)
                            %                         '..ing'
                            ing = 1; % closING or openING
                            DGinv{cr3}(curSP3) = 1;
                        end
                    elseif strcmp(basedOn,'ID')
                        % ID based DG inversion
                        DGinv{cr3}(curSP3) = 0;
                        if abs(temp2(1,55)) / temp2(1,55) ~= abs(temp2(1000,55)) / temp2(1000,55)
                            %                         '..ing'
                            ing = 1; % closING or openING
                            DGinv{cr3}(curSP3) = 1;
                        end
                    end
                    
                    if ing == 0
                        % closed or open
                        if out{j,i}.crossed(3) == 1
                            % open
                            cooc = 2;
                            sp_cooc2 = sp_cooc2 +1;
                            curSP4 = sp_cooc2 ;
                        else
                            % closed
                            cooc = 4;
                            sp_cooc4 = sp_cooc4 +1;
                            curSP4 = sp_cooc4 ;
                        end
                    else
                        % closing or opening
                        if out{j,i}.crossed(3) == 1
                            % opening
                            cooc = 3;
                            sp_cooc1 = sp_cooc1 +1;
                            curSP4 = sp_cooc1 ;
                        else
                            % closing
                            cooc = 1;
                            sp_cooc3 = sp_cooc3 +1;
                            curSP4 = sp_cooc3 ;
                        end
                        
                    end
                    
                    nSwitch{cooc}(1,curSP4) = out{j,i}.nDGswitch;
                    DG_MPD_cooc{cooc}(:,curSP4) =  temp2(:,61);%tempMPDs(qut, ind(qut))*mult; % cooc = closing open opening closed
                    DG_ID_cooc{cooc}(:,curSP4) = temp2(:,55); % cooc = closing open opening closed
                    %                                     DG_BA_cooc{cooc}(:,curSP4) = temp2(:,65);
                    time = out{j,i}.universalTimeSeriesTend(:,39);
                    
                    tmp = velocity_vector([temp2(:,59) temp2(:,60)],time);
                    DGvel{cooc}(:,curSP4) =  sqrt(sum( tmp .^2,2));
                    
                    mult = abs(temp2(end,63)) / temp2(end,63);
                    tmp = (temp2(:,63)) .* mult;
                    tmp3 = tmp;
                    tmp2 = gradient(tmp);
                    
                    tmp99 = quantile(abs(tmp2),4);
                    tmp88 = tmp2(abs(tmp2)<=tmp99(4));
                    threshold = nanmean(tmp88)+10*nanstd(tmp88);
                    %                 tmp2(abs(tmp2)>(nanmean(abs(tmp2))+3*nanstd(abs(tmp2)))) = NaN;
                    %                 tmp2(abs(tmp2)>threshold) = NaN;
                    tmp77 = find(abs(tmp2)>threshold);%tmp77 = find(tmp>threshold);
                    if sum(tmp(tmp77) > 0) < sum(tmp(tmp77) <= 0)
                        % invert again
                        tmp = tmp .* -1;
                        tmp3 = tmp;
                        tmp2 = gradient(tmp);
                        
                        tmp99 = quantile(abs(tmp2),4);
                        tmp88 = tmp2(abs(tmp2)<=tmp99(4));
                        threshold = nanmean(tmp88)+10*nanstd(tmp88);
                        %                 tmp2(abs(tmp2)>(nanmean(abs(tmp2))+3*nanstd(abs(tmp2)))) = NaN;
                        %                 tmp2(abs(tmp2)>threshold) = NaN;
                        tmp77 = find(abs(tmp2)>threshold);%tmp77 = find(tmp>threshold);
                    end
                    tmp5 = tmp;
                    tmp4 = tmp2;
                    if ~isnan(tmp77)
                        for ii = 1:length(tmp77)
                            if tmp77(ii)+10 < 1000
                                tmp5(tmp77(ii)-10 : tmp77(ii)+10) = NaN;
                                tmp4(tmp77(ii)-10 : tmp77(ii)+10) = NaN;
                            end
                        end
                    end
                    tmp3 = fillGaps(tmp5);
                    if cooc == 2 && curSP4 == 149
                        figure(10);hold off
                        subplot(3,1,1);hold off
                        plot(tmp5);hold on;
                        tempYLIM = ylim;
                        plot(tmp);
                        set(gca,'XLim',[0 1000])
                        
                        set(gca,'YLim',tempYLIM)
                        if ~isempty(tmp77)
                            vline([min(tmp77)-10 max(tmp77+10)]);
                        end
                        title('was it necessary?')
                        
                        subplot(3,1,2);hold off
                        plot(tmp2,'b');hold on
                        plot(tmp4,'--r');hold on
                        set(gca,'XLim',[0 1000])
                        
                        hline((threshold));
                        title('gradient')
                        
                        subplot(3,1,3);hold off
                        plot(tmp3,'-b');hold on
                        plot(tmp5,'--k');
                        set(gca,'XLim',[0 1000])
                        
                        title('new and filled')
                    end
                    
                    
                    BetaDot{cooc}(:,curSP4) = (tmp3);
                    
                    Gap0_fcb{cr3}(:,curSP3) = temp2(:,55); % fcb = front crossed behind
                    Gap2_fcb{cr3}(:,curSP3) = temp2(:,mostPos); % fcb = front crossed behind
                    Gap3_fcb{cr3}(:,curSP3) = temp2(:,mostNeg); % fcb = front crossed behind
                end
            end
        end
    end
end
t0 = 1;%find(out{j,i}.universalTimeSeriesTend(:,58) == 0);
t100 = 1000;%find(out{j,i}.universalTimeSeriesTend(:,58) == 100);
time = out{j,i}.universalTimeSeriesTend(t0:t100,39);
titleText{1} = 'W1 Through W2 & W3';
titleText{2} = 'W1 In front W2 & W3';
titleText{3} = 'W1 Behind W2 & W3';

if strcmp(basedOn,'MPD')
    DG = DG_MPD_cooc;
    if DGvelYes == 1
        DG = DGvel;
    elseif DGvelYes == 2
        DG = BetaDot;
    end
    
elseif strcmp(basedOn,'BA')
    DG = DG_BA_cooc;
elseif strcmp(basedOn,'ID')
    DG = DG_ID_cooc;
elseif strcmp(basedOn,'DGvel')
    DG = DGvel;
end
for cr = 1:4
    [DG_av{cr}, DG_sd{cr}, DG_n{cr}, DG_se{cr}] = dataSummary(DG{cr}(t0:t100,:));
    %         [BetaDot_av{cr}, BetaDot_sd{cr}, BetaDot_n{cr}, BetaDot_se{cr}] = dataSummary((BetaDot{cr}(t0:t100-0,:)));
    
    figure(15);
    if plotAsLog == 1
        plot(time,log(DG_av{cr}),'Color',[0 0 0],'LineStyle',lStyle{cr},'LineWidth',1.1);hold on
        y1 = log(DG_av{cr} + DG_se{cr});
        y2 = log(DG_av{cr} - DG_se{cr});
    else
        plot(time,DG_av{cr},'Color',[0 0 0],'LineStyle',lStyle{cr},'LineWidth',1.1);hold on
        y1 = DG_av{cr}+DG_se{cr};
        y2 = DG_av{cr}-DG_se{cr};
    end
    jbfill(time',y2',y1',colorSpecGrey(cr,:),colorSpecGrey(cr,:),1,.5);
    
end

xlabel('Time (%)')
if strcmp(basedOn,'ID')
    YVals = [-2 2];
    
    %     why1 = 2.22;
    %     why2 = 2.16;
elseif strcmp(basedOn,'MPD')
    if DGvelYes == 0
        YVals = [-1.4 1.4];
        YVals2 = [-2.2 2.2];
        
        
        set(gca,'YTick',[-1 -.5 0 .5 1]);
        yString = '\itDG\rm (m)';
    elseif DGvelYes == 1 % DGvel
        YVals = [0 .1];
        YVals2 = [0 .15];
        set(gca,'YTick',[0 .05 .1]);
        %         yString = '\itDGvel\rm (m/%)';
        yString = '$$\dot{DG}$$ (m/s)';
        
    else % BetaDot
        
        if plotAsLog == 1
            YVals = [-12 -4];
            YVals2 = YVals;
            set(gca,'YTick',[-12 -10 -8 -6 -4]);
            yString = 'log($$\dot{\beta}$$) (deg/s)';
        else
            YVals = [0 0.0100282939420888];
            YVals2 = YVals;
            set(gca,'YTick',[0 0.002 0.004 0.006 0.008 0.01]);
            yString = 'Positive $$\dot{\beta}$$ (deg/s)';
            
        end
    end
    axis([0 100 YVals])
    
    
end
yl = ylabel(yString);
if DGvelYes ~= 0
    set(yl,'Interpreter','latex');
end

% YCorrection=1/(2.8*(YVals(2)-YVals(1)));
YCorrection = 2.8/((YVals(2)-YVals(1))) ;

why1 = (YVals(1)+1.4+1.62)/YCorrection;
why1 = YVals(1)+(1.4+1.62)/YCorrection;
% why2 = 1.56/2.8*(YVals(2)-YVals(1));

set(gca,'XTick',[0 25 50 75 100]);
figure(15)
box off

% Plot significant differences
alphaLevel = 0.05/alphaCorrectie; % manual bonferroni correction
if comparison == 1     % closing vs open
    d1 = DG{1}';
    d2 = DG{2}';
elseif comparison == 2 % closing vs opening
    d1 = DG{1}';
    d2 = DG{3}';
elseif comparison == 3 % closing vs closed
    d1 = DG{1}';
    d2 = DG{4}';
elseif comparison == 4 % open vs opening
    d1 = DG{2}';
    d2 = DG{3}';
elseif comparison == 5 % open vs closed
    d1 = DG{2}';
    d2 = DG{4}';
elseif comparison == 6 % opening vs closed
    d1 = DG{3}';
    d2 = DG{4}';
end

% closing vs open

if comparison ~= 0
    %%
    %%%%%%%%%%%%%%%%%%%%% THIS IS WHERE I RUN SPM
    options   = struct('two_tailed',1);
    SPM = spm1d_stats_ttest2(d1, d2);
    SPMi = spm1d_inference(SPM, alphaLevel, options);
    frameDiff = abs(SPMi.z) > SPMi.zstar;
    [~,maxz] = max(abs(SPMi.z));
    
    disp([compString 'SPM sign: z(1, ' num2str(SPMi.df(2)) ') = ' num2str(SPMi.z(maxz)) ', p = ' num2str(SPMi.p)])
    disp([compString 'SPM sign: z(1, ' num2str(SPMi.df(2)) ') = ' num2str(SPMi.z(maxz)) ', CORRECTED p = ' num2str(SPMi.p(1)*(.05/alphaLevel))])
    if comparison == 3 % manuele oplossing om tweede verschil weer te geven
        disp([compString 'SPM sign: z(1, ' num2str(SPMi.df(2)) ') = ' num2str(max(SPMi.z(790:end))) ', CORRECTED p = ' num2str(SPMi.p(2)*(.05/alphaLevel))])
    end
    frameWHY(1:1000) = why1;
    tmp = frameDiff(2:end) - frameDiff(1:end-1);
    tmp2 = find(tmp ~= 0);
    
    if frameDiff(1) == 0
        % not different at the start
        st = 0;
    else
        st = 1;
    end
    if isempty(tmp2)
        % different during the whole trial (or never different)
        if frameDiff(1) == 1
            % always different
            tstart = 1;
            tend = length(frameDiff);
            
            plot([time(tstart) time(tstart)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off');
            plot([time(tend) time(tend)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off')
            plot(time(tstart:tend),frameWHY(tstart:tend),'-k', 'LineWidth', 1.6,'clipping','off')
            text( time(round(1.0*(((tend - tstart) / 2) + tstart-1))),frameWHY(1)+.15/YCorrection,'*','Color',[0 0 0],'FontSize',14,'HorizontalAlignment','Center')
            
            disp(['Different from ' num2str(time(tstart)) ' until ' num2str(time(tend)) '%'])
            
        end
        
    else
        if st == 1
            corr = 1;
        else
            corr = 0;
        end
        for i = 1:2:length(tmp2)+corr % CONTINUE HERE TRYING TO MAKE IT WORK FOR MULTIPLE SIGN DIFFERENCES
            %             if length(tmp2) > 2
            %                 error('script not designed to cope with more than 2 periods of significance')
            %             end
            if st == 1
                
                if i == 1
                    tstart = 1;
                    tend = tmp2(i);
                else
                    tstart = tmp2(i-1);
                    if i-1 == length(tmp2)
                        tend = length(frameDiff);
                    else
                        tend =  tmp2(i);
                    end
                end
                
                plot([time(tstart) time(tstart)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off');
                plot([time(tend) time(tend)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off')
                plot(time(tstart:tend),frameWHY(tstart:tend),'-k', 'LineWidth', 1.6,'clipping','off')
                text( time(round(1.0*(((tend - tstart) / 2) + tstart-1))),frameWHY(1)+.15/YCorrection,'*','Color',[0 0 0],'FontSize',14,'HorizontalAlignment','Center')
                disp(['Different from ' num2str(time(tstart)) ' until ' num2str(time(tend)) '%'])
                
            else
                
                tstart = tmp2(i);
                if length(tmp2) < i+1
                    tend = length(frameDiff);
                else
                    tend = tmp2(i+1);
                end
                
                plot([time(tstart) time(tstart)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off');
                plot([time(tend) time(tend)],[frameWHY(1)-.15/YCorrection frameWHY(1)+.15/YCorrection],'-k', 'LineWidth', 1.6,'clipping','off')
                plot(time(tstart:tend),frameWHY(tstart:tend),'-k', 'LineWidth', 1.6,'clipping','off')
                text( time(round(1.0*(((tend - tstart) / 2) + tstart-1))),frameWHY(1)+.15/YCorrection,'*','Color',[0 0 0],'FontSize',14,'HorizontalAlignment','Center')
                disp(['Different from ' num2str(time(tstart)) ' until ' num2str(time(tend)) '%'])
            end
        end
    end
end

% total
ninv = sum([DGinv{1} DGinv{2} DGinv{3}] == 0);
inv = sum([DGinv{1} DGinv{2} DGinv{3}] == 1);
tot = length([DGinv{1} DGinv{2} DGinv{3}]);
perc = inv / tot * 100;
if comparison == 0
    disp(['Total: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
    % tabulate([nSwitch{1} nSwitch{2} nSwitch{3} nSwitch{4}])
end
ninvTotal = ninv;
invTotal = inv;

% through (and opening)
ninv = sum([DGinv{2} ] == 0);
inv = sum([DGinv{2} ] == 1);
tot = length([DGinv{2}]);
perc = inv / tot * 100;
if comparison == 0
    disp(['Through: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
    % tabulate([nSwitch{2} nSwitch{3}])
end
nOpening = inv;
nOpen = ninv;

% around (and closing)
ninv = sum([DGinv{1} DGinv{3}] == 0);
inv = sum([DGinv{1} DGinv{3}] == 1);
tot = length([DGinv{1} DGinv{3}]);
perc = inv / tot * 100;
if comparison == 0
    disp(['Around: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
    disp(' ')
    disp('Number of switches in walker with min(ID)')
    disp('Open')
    tabulate([nSwitch{2}])
    disp('Opening')
    tabulate([nSwitch{3}])
    disp('Closing')
    tabulate([nSwitch{1}])
    disp('Closed')
    tabulate([nSwitch{4}])
    
end
nClosing = inv;
nClosed = ninv;


fpath =  'Figs';
manualLegend()

pos = get(gca, 'Position');

if strcmp(basedOn,'ID')
    pos(1) = .08;
    pos(2) = .15;
    pos(3) = .87;
    pos(4) = .75;
elseif strcmp(basedOn,'MPD')
    pos(1) = .08; % lower limit horizontal
    pos(2) = .15; % lower limit vertical
    pos(3) = .72; % upper limit horizontal
    pos(4) = .718; % upper limit horizontal
elseif strcmp(basedOn,'BA')
    pos(1) = .08; % lower limit horizontal
    pos(2) = .15; % lower limit vertical
    pos(3) = .72; % upper limit horizontal
    pos(4) = .718; % upper limit horizontal
end


set(gca, 'Position', pos)
if comparison ~= 0
    disp(['Corrected for ' num2str(alphaCorrectie) ' tests'])
end
disp(' ')

filename5 = 'Fig08_MPI_Paper_cooc';
if DGvelYes == 1
    filename5 = 'Fig08_MPI_Paper_cooc_DGvel';
elseif DGvelYes == 2
    if plotAsLog == 1
        filename5 = 'Fig08_MPI_Paper_cooc_logBetaDot';
    else
        filename5 = 'Fig08_MPI_Paper_cooc_BetaDot';
        
    end
    
end
if ingThreshold ~= 0
    filename5 = [filename5 '_newIng'];
end
if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end
print( h15, '-r300' ,'-dtiff' ,[fpath filesep filename5 '_' basedOn '_' compString '.tiff']) % here you can specify filename extensions

% and add a plot for individual trials
% maybe change YVals?
h16 = figure(11);
YVals = YVals2;
YCorrection = 2.8/((YVals(2)-YVals(1))) ;

if length(indAllTrials) == 4
    indAllTrials = [2 4 1 3];
end
for i = indAllTrials
    if plotAsLog == 1
        plot(time,log(DG{i}),'Color',colorSpecGrey(i,:)); hold on
    else
        plot(time,DG{i},'Color',colorSpecGrey(i,:)); hold on
    end
    
end
xlabel('Time (%)')
yl = ylabel(yString);

axis([0 100 YVals])
set(gca,'XTick',[0 25 50 75 100]);

if DGvelYes ~= 0
    set(yl,'Interpreter','latex');
end
manualLegend()
box off
set(gca, 'Position', pos)

print( h16, '-r300' ,'-dtiff' ,[fpath filename5 '_' basedOn '_' compString '_ALLtrials.tiff']) % here you can specify filename extensions


    function manualLegend()
        
        x1 = [102.5 107.5];
        x2 = 110;
        x3 = 115;
        
        yt = (YVals(1)+1.4+1.3)/YCorrection;
        yt = YVals(1)+(1.4+1.3)/YCorrection;
        
        rectangle('Position',[x1(1) yt-.1/YCorrection 5 .2/YCorrection],'FaceColor',colorSpecGrey(2,:),'EdgeColor',colorSpecGrey(2,:),'Clipping','off')
        plot([x1(1) x1(1)+5],[yt yt],'k','LineStyle',lStyle{2},'clipping','off')
        
        text(x2,yt,'Open','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt,['(\itn\rm = ' num2str(nOpen) ')'],'clipping','off')
        
        yt = yt - .3/YCorrection;
        y1(1:2) = yt-.1/YCorrection;y2(1:2) = yt+.1/YCorrection;cr = cr +1 ;
        rectangle('Position',[x1(1) yt-.1/YCorrection 5 .2/YCorrection],'FaceColor',colorSpecGrey(3,:),'EdgeColor',colorSpecGrey(3,:),'Clipping','off')
        plot([x1(1) x1(1)+5],[yt yt],'k','LineStyle',lStyle{3},'clipping','off')
        text(x2,yt,'Opening','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt,['(\itn\rm = ' num2str(nOpening) ')'],'clipping','off')
        
        yt = (YVals(1)+1.4-.7)/YCorrection;
        yt = YVals(1)+(1.4-.7)/YCorrection;
        
        rectangle('Position',[x1(1) yt-.1/YCorrection 5 .2/YCorrection],'FaceColor',colorSpecGrey(1,:),'EdgeColor',colorSpecGrey(1,:),'Clipping','off')
        plot([x1(1) x1(1)+5],[yt yt],'k','LineStyle',lStyle{1},'clipping','off')
        text(x2,yt,'Closing','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt,['(\itn\rm = ' num2str(nClosing) ')'],'clipping','off')
        
        yt = yt - .3/YCorrection;
        rectangle('Position',[x1(1) yt-.1/YCorrection 5 .2/YCorrection],'FaceColor',colorSpecGrey(4,:),'EdgeColor',colorSpecGrey(4,:),'Clipping','off')
        plot([x1(1) x1(1)+5],[yt yt],'k','LineStyle',lStyle{4},'clipping','off')
        text(x2,yt,'Closed','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt,['(\itn\rm = ' num2str(nClosed) ')'],'clipping','off')
        
    end
end
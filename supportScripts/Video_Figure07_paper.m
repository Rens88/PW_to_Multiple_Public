function Video_Figure07_paper(out,basedOn,trail,ingThreshold)
% VIDEO_FIGURE07_PAPER:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% out - contains the data from PW_to_Multiple_Public.mat
% basedOn - contains the (string) reference measure that is compared:
% - MPD = minimal predicted distance (or Distance at Closest approach * code is confirmed to work for MPD
% - BA = the bearing angle
% - ID = the intersection distance
% - DGvel = the gradient of the dynamic gap
% ingThreshold = which definition of opening and closing should be used (i.e., the minimum change required to label a trial as closING or openING)
% if ingThreshold is 0 --> the previous definition of opening and closing
% if it is any other number then that number corresponds to the last
% percentage where an inverted DG occurred.
% - trail = a boolean that indicates whether a trail should be plotted to indicate the trajectory.
%

%%
darkRed = [170 0 0]/255;
lightRed = [255 128 128]/255;

lightGreen = [153 255 153]/255;
darkGreen = [0 150 0] / 255;

fontsize = 16;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92;y_width = 7.86*2; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);

close all
count = 0;

sp3_1 = 0; sp3_2 = 0; sp3_3 = 0;
sp1 = 0; sp3 = 0; sp5 = 0;

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
                    
                    MPD12{cr3}(:,curSP3) = temp2(:,2);
                    MPD13{cr3}(:,curSP3) = temp2(:,3);
                    
                    tempMPDs = abs(temp2(:,[2 3]));
                    [~,ind] = min(tempMPDs');
                    for qut = 1:1000
                        mult(qut) = 1;
                        if temp2(qut,2) > 0 && temp2(qut,3) < 0
                            % open
                        elseif temp2(qut,2) < 0 && temp2(qut,3) > 0
                            % open
                        else
                            % closed
                            mult(qut) = -1;
                        end
                        MPDmin{cr3}(qut,curSP3) = tempMPDs(qut, ind(qut))*mult(qut);
                    end
                    mostPos = 57;
                    
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
                    
                    Gap0_oc{cr}(:,curSP) = temp2(:,55); % oc = open closed
                    Gap2_oc{cr}(:,curSP) = temp2(:,mostPos); % oc = open closed
                    Gap3_oc{cr}(:,curSP) = temp2(:,mostNeg); % oc = open closed
                    
                    Gap0_fcb{cr3}(:,curSP3) = temp2(:,55); % fcb = front crossed behind
                    Gap2_fcb{cr3}(:,curSP3) = temp2(:,mostPos); % fcb = front crossed behind
                    Gap3_fcb{cr3}(:,curSP3) = temp2(:,mostNeg); % fcb = front crossed behind
                    
                    Gap2_fcb_unsorted{cr3}(:,curSP3) = temp2(:,56); % fcb = front crossed behind
                    Gap3_fcb_unsorted{cr3}(:,curSP3) = temp2(:,57); % fcb = front crossed behind
                end
            end
        end
    end
end

% through (and opening)
ninv = sum([DGinv{2} ] == 0);
inv = sum([DGinv{2} ] == 1);
tot = length([DGinv{2}]);
perc = inv / tot * 100;
disp(['Through: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
nOpening = inv;
nOpen = ninv;

% around (and closing)
ninv = sum([DGinv{1} DGinv{3}] == 0);
inv = sum([DGinv{1} DGinv{3}] == 1);
tot = length([DGinv{1} DGinv{3}]);
perc = inv / tot * 100;
disp(['Around: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
nClosing = inv;
nClosed = ninv;

time = temp2(:,58);
if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end
filename = ['Vid02_DGevolution_Fig07_' basedOn];
writerObj = VideoWriter(['Figs\' filename '.avi']); % Name it.
writerObj.FrameRate = 24; % How many frames per second.
open(writerObj);

tstart = 1;
tend = 1000;

h39 = figure(39);hold off
frameTemp = tstart;
while frameTemp < tend
    frameTemp = frameTemp + 100/writerObj.FrameRate;
    if (frameTemp + 100/writerObj.FrameRate) > tend
        frameTemp = tend;
    end
    curFrame = round(frameTemp );
    
    prevFrame = curFrame - 12;
    prevFrame(prevFrame <= 0) = 1;
    
    set(h39, 'Position', [0 0 2*560 2*420]);%[x y width height])
    hold off
    if strcmp(basedOn,'MPD')
        plotVar1 = MPD12;
        plotVar2 = MPD13;
    elseif strcmp(basedOn,'BA')
        plotVar1 = BA12;
        plotVar2 = BA13;
    end
    plot(plotVar1{1}(curFrame,:),plotVar2{1}(curFrame,:),'.r');hold on;
    plot(plotVar1{2}(curFrame,:),plotVar2{2}(curFrame,:),'.g')
    plot(plotVar1{3}(curFrame,:),plotVar2{3}(curFrame,:),'.r')
    
    if trail == 1 && curFrame ~= 1
        plot(plotVar1{1}(prevFrame:curFrame,DGinv{1} == 0),plotVar2{1}(prevFrame:curFrame,DGinv{1} == 0),'Color',lightRed,'LineWidth',.6);hold on;
        plot(plotVar1{2}(prevFrame:curFrame,DGinv{2} == 0),plotVar2{2}(prevFrame:curFrame,DGinv{2} == 0),'Color',lightGreen,'LineWidth',.6)
        plot(plotVar1{3}(prevFrame:curFrame,DGinv{3} == 0),plotVar2{3}(prevFrame:curFrame,DGinv{3} == 0),'Color',lightRed,'LineWidth',.6)
        tailCor = 0;
        plot(plotVar1{1}(prevFrame:curFrame-tailCor,DGinv{1} == 1),plotVar2{1}(prevFrame:curFrame-tailCor,DGinv{1} == 1),'Color',darkRed,'LineWidth',.6);hold on;
        plot(plotVar1{2}(prevFrame:curFrame-tailCor,DGinv{2} == 1),plotVar2{2}(prevFrame:curFrame-tailCor,DGinv{2} == 1),'Color',darkGreen,'LineWidth',.6)
        plot(plotVar1{3}(prevFrame:curFrame-tailCor,DGinv{3} == 1),plotVar2{3}(prevFrame:curFrame-tailCor,DGinv{3} == 1),'Color',darkRed,'LineWidth',.6)
        
    end
    % no inv.
    plot(plotVar1{1}(curFrame,DGinv{1} == 0),plotVar2{1}(curFrame,DGinv{1} == 0),'.','Color',lightRed,'MarkerSize',10);hold on;
    plot(plotVar1{2}(curFrame,DGinv{2} == 0),plotVar2{2}(curFrame,DGinv{2} == 0),'.','Color',lightGreen,'MarkerSize',10)
    plot(plotVar1{3}(curFrame,DGinv{3} == 0),plotVar2{3}(curFrame,DGinv{3} == 0),'.','Color',lightRed,'MarkerSize',10)
    % inv
    plot(plotVar1{1}(curFrame,DGinv{1} == 1),plotVar2{1}(curFrame,DGinv{1} == 1),'o','MarkerSize',5,'Color',darkRed,'LineWidth',1.2);hold on;
    plot(plotVar1{2}(curFrame,DGinv{2} == 1),plotVar2{2}(curFrame,DGinv{2} == 1),'o','MarkerSize',5,'Color',darkGreen,'LineWidth',1.2)
    plot(plotVar1{3}(curFrame,DGinv{3} == 1),plotVar2{3}(curFrame,DGinv{3} == 1),'o','MarkerSize',5,'Color',darkRed,'LineWidth',1.2)
    plot(plotVar1{1}(curFrame,DGinv{1} == 1),plotVar2{1}(curFrame,DGinv{1} == 1),'.','MarkerSize',6,'Color',[1 1 1]);hold on;
    plot(plotVar1{2}(curFrame,DGinv{2} == 1),plotVar2{2}(curFrame,DGinv{2} == 1),'.','MarkerSize',6,'Color',[1 1 1])
    plot(plotVar1{3}(curFrame,DGinv{3} == 1),plotVar2{3}(curFrame,DGinv{3} == 1),'.','MarkerSize',6,'Color',[1 1 1])
    
    xlabel('\itID_{12}\rm (m)')
    ylabel('\itID_{13}\rm (m)')
    
    curTime = round(time(curFrame));
    
    ht1 = title([num2str(curTime) '%']);
    axis([-6 6 -6 6])
    hline(0,'--k');
    vline(0,'--k');
    
    set(gca,'XTick',[-6 -4 -2 0 2 4 6])
    
    
    text(3,-4.7,'Open')
    text(3,-5.4,'(Through)')
    
    text(-5,5.4,'Open')
    text(-5,4.7,'(Through)')
    
    text(-5,-4.7,'Closed')
    text(-5,-5.4,'(Behind)')
    
    text(3,5.4,'Closed')
    text(3,4.7,'(In front)')
    
    
    yt = 5;
    text(6.4,yt,'Open','clipping','off')
    yt = yt - 1;
    plot(6.4,yt,'.','Color',lightGreen,'clipping','off','MarkerSize',40)
    text(6.7,yt,'No inversion','clipping','off')
    yt = yt - .8;
    text(7,yt,['(\itn\rm = ' num2str(nOpen) ')'],'clipping','off')
    
    yt = yt - 1;
    plot(6.4,yt,'o','Color',darkGreen ,'MarkerSize',9,'clipping','off','LineWidth',2)
    
    text(6.7,yt,'Inversion','clipping','off')
    yt = yt - .8;
    text(7,yt,['(\itn\rm = ' num2str(nOpening) ')'],'clipping','off')
    
    yt = yt - 2;
    text(6.4,yt,'Closed','clipping','off')
    
    yt = yt - 1;
    plot(6.4,yt,'o','Color',darkRed ,'MarkerSize',9,'clipping','off','LineWidth',2)
    
    text(6.7,yt,'Inversion','clipping','off')
    yt = yt - .8;
    text(7,yt,['(\itn\rm = ' num2str(nClosing) ')'],'clipping','off')
    
    yt = yt - 1;
    plot(6.4,yt,'.','Color',lightRed,'clipping','off','MarkerSize',40)
    text(6.7,yt,'No inversion','clipping','off')
    yt = yt - .8;
    text(7,yt,['(\itn\rm = ' num2str(nClosed) ')'],'clipping','off')
    pos(1) = .08;  % ondergrens horizontal
    pos(2) = .145; % ondergrens vertical
    pos(3) = .75; % bovengrens horizontal
    pos(4) = .815; % bovengrens vertical
    set(gca,'Position',pos)
    
    winsize = get(h39,'Position');
    set(h39, 'MenuBar', 'none');
    
    set(h39, 'ToolBar', 'none');
    
    movegui(h39)
    frame = getframe(h39); % 'gcf' can handle if you zoom in to take a movie.
    writeVideo(writerObj, frame);
    delete(ht1)
end
close(h39)
close(writerObj); % Saves the movie.

end
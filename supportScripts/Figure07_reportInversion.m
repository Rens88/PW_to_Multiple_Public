function Figure07_reportInversion(out,basedOn,ingThreshold)

YVals = [-4 4];


darkRed = [170 0 0]/255;
lightRed = [255 128 128]/255;

lightGreen = [153 255 153]/255;
darkGreen = [0 150 0] / 255;

colorSpecGrey = [darkRed; lightGreen; darkGreen; lightRed;];

fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 18;y_width = 7.86; % might change this for poster
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
                    
                    if out{j,i}.formation(10) ~= .3 % exclude smallest diameter
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
                    
                    %                         BA12{cr3}(:,curSP3) = temp2(:,63);
                    %             BA13{cr3}(:,curSP3) = temp2(:,64);
                    %             BAmin{cr3}(:,curSP3) = temp2(:,65);
                    
                    % tempMPDs = abs(temp2(:,[2 3]));
                    % [~,ind] = min(tempMPDs');
                    % for qut = 1:1000
                    % mult = 1;
                    % if temp2(qut,2) > 0 && temp2(qut,3) < 0
                    % % open
                    % elseif temp2(qut,2) < 0 && temp2(qut,3) > 0
                    % % open
                    % else
                    % % closed
                    % mult = -1;
                    % end
                    % MPDmin{cr3}(qut,curSP3) = tempMPDs(qut, ind(qut))*mult;
                    % end
                    
                    ing = 0; % closING or openING
                    % MPD based - DG inversion
                    %                     if j == 18
                    %                         disp('hi')
                    %                     end
                    if strcmp(basedOn,'MPD')
                        DGinv{cr3}(curSP3) = 0;
                        if ingThreshold == 0
                            if abs(temp2(1,61)) / temp2(1,61) ~= abs(temp2(1000,61)) / temp2(1000,61)
                                %                         '..ing'
                                ing = 1; % closING or openING
                                DGinv{cr3}(curSP3) = 1;
                                %                             disp([i j])
                            end
                        else
                            DGtemp = out{j,i}.universalTimeSeriesTend(:,61);
                            opp = abs(DGtemp) ./ DGtemp ~= abs(DGtemp(1000)) / DGtemp(1000);
                            dopp = [0; opp(2:end) - opp(1:end-1)];
                            
                            if find(dopp ~= 0,1,'last')/10 >= ingThreshold
                                
                                %                         '..ing'
                                ing = 1; % closING or openING
                                DGinv{cr3}(curSP3) = 1;
%                                 if out{j,i}.crossed(3) == 0
%                                     disp([i j])
%                                 end
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
h39 = figure(39);

if strcmp(basedOn,'MPD')
    
    plotTemp12 = MPD12;
    plotTemp13 = MPD13;
    
elseif strcmp(basedOn,'BA')
    
    plotTemp12 = BA12;
    plotTemp13 = BA13;
    
elseif strcmp(basedOn,'ID')
    
    plotTemp12 = Gap2_fcb_unsorted;
    plotTemp13 = Gap3_fcb_unsorted;
    
end

% total
ninv = sum([DGinv{1} DGinv{2} DGinv{3}] == 0);
inv = sum([DGinv{1} DGinv{2} DGinv{3}] == 1);
tot = length([DGinv{1} DGinv{2} DGinv{3}]);
perc = inv / tot * 100;
disp(['Total: Inversion in ' num2str(inv) ' out of ' num2str(tot) ' trials (' num2str(round(perc,1)) '%)' ])
ninvTotal = ninv;
invTotal = inv;

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


subplot(1,2,1)

% no inv.
plot(plotTemp12{1}(1,DGinv{1} == 0),plotTemp13{1}(1,DGinv{1} == 0),'.','Color',lightRed);hold on;
plot(plotTemp12{2}(1,DGinv{2} == 0),plotTemp13{2}(1,DGinv{2} == 0),'.','Color',lightGreen)
plot(plotTemp12{3}(1,DGinv{3} == 0),plotTemp13{3}(1,DGinv{3} == 0),'.','Color',lightRed)
% inv
plot(plotTemp12{1}(1,DGinv{1} == 1),plotTemp13{1}(1,DGinv{1} == 1),'o','Color',darkRed ,'MarkerSize',2);hold on;
plot(plotTemp12{2}(1,DGinv{2} == 1),plotTemp13{2}(1,DGinv{2} == 1),'o','Color',darkGreen ,'MarkerSize',2)
plot(plotTemp12{3}(1,DGinv{3} == 1),plotTemp13{3}(1,DGinv{3} == 1),'o','Color',darkRed ,'MarkerSize',2)

xlabel('\itID_{12}\rm (t_{start}) (m)')
ylabel('\itID_{13}\rm (t_{start}) (m)')
YCorrection = 2.8/((YVals(2)-YVals(1))) ; % for legend
YCorrection2 = 12/((YVals(2)-YVals(1))) ; % for in figure text
XVals = YVals;
% XCorrection = 100/((XVals(2)-XVals(1))) ; % for legend
XCorrection = 12/((XVals(2)-XVals(1))) ; % for in figure text
axis([XVals YVals])
hline(0,'--k');
vline(0,'--k');

set(gca,'XTick',[-6 -4 -2 0 2 4 6])
subplot(1,2,2)

% no inv.
plot(plotTemp12{1}(1000,DGinv{1} == 0),plotTemp13{1}(1000,DGinv{1} == 0),'.','Color',lightRed);hold on;
plot(plotTemp12{2}(1000,DGinv{2} == 0),plotTemp13{2}(1000,DGinv{2} == 0),'.','Color',lightGreen)
plot(plotTemp12{3}(1000,DGinv{3} == 0),plotTemp13{3}(1000,DGinv{3} == 0),'.','Color',lightRed)
% inv
plot(plotTemp12{1}(1000,DGinv{1} == 1),plotTemp13{1}(1000,DGinv{1} == 1),'o','Color',darkRed ,'MarkerSize',2);hold on;
plot(plotTemp12{2}(1000,DGinv{2} == 1),plotTemp13{2}(1000,DGinv{2} == 1),'o','Color',darkGreen ,'MarkerSize',2)
plot(plotTemp12{3}(1000,DGinv{3} == 1),plotTemp13{3}(1000,DGinv{3} == 1),'o','Color',darkRed ,'MarkerSize',2)


xlabel('\itID_{12}\rm (t_{end}) (m)')
ylabel('\itID_{13}\rm (t_{end}) (m)')
axis([XVals YVals])
set(gca,'XTick',[-6 -4 -2 0 2 4 6])
hline(0,'--k');
vline(0,'--k');

text(XVals(1)+(6+3)/XCorrection,YVals(1)+(6+-4.7)/YCorrection2,'Open')
text(XVals(1)+(6+3)/XCorrection,YVals(1)+(6+-5.4)/YCorrection2,'(Through)')

text(XVals(1)+(6+-5)/XCorrection,YVals(1)+(6+5.4)/YCorrection2,'Open')
text(XVals(1)+(6+-5)/XCorrection,YVals(1)+(6+4.7)/YCorrection2,'(Through)')

text(XVals(1)+(6+-5)/XCorrection,YVals(1)+(6+-4.7)/YCorrection2,'Closed')
text(XVals(1)+(6+-5)/XCorrection,YVals(1)+(6+-5.4)/YCorrection2,'(Behind)')

text(XVals(1)+(6+3)/XCorrection,YVals(1)+(6+5.4)/YCorrection2,'Closed')
text(XVals(1)+(6+3)/XCorrection,YVals(1)+(6+4.7)/YCorrection2,'(In front)')

manualLegend()

pos(1) = .50;  % ondergrens horizontal
pos(2) = .15; % ondergrens vertical
pos(3) = .35; % bovengrens horizontal
pos(4) = .718; % bovengrens vertical
set(gca,'Position',pos)
subplot(1,2,1)
pos(1) = .07;  % ondergrens horizontal
pos(2) = .15; % ondergrens vertical
pos(3) = .35; % bovengrens horizontal
pos(4) = .718; % bovengrens vertical
set(gca,'Position',pos)


fpath = 'Figs\';

print( h39, '-r300' ,'-dtiff' ,[fpath 'Fig07_DGsorted_' basedOn '.tiff']) % here you can specify filename extensions

    function manualLegend()
        %
        %                 x1 = [102.5 107.5];
        %         x2 = 110;
        %         x3 = 115;
        x1 = [XVals(1)+(6+6.4)/XCorrection .2/XCorrection];
        x2 = XVals(1)+(6+6.7)/XCorrection;
        x3 = XVals(1)+(6+8)/XCorrection;
        % cr = 0;
        
        %         yt = (YVals(1)+1.4+1.3)/YCorrection;
        yt = YVals(1)+(1.4+1.3)/YCorrection;
        yt = yt - 0.5;
        
        % y1(1:2) = yt-.1;y2(1:2) = yt+.1;
        % cr = cr +1 ;
        % jbfill(x1',y2',y1',colorSpecGrey(cr,:),colorSpecGrey(cr,:),1,.25);
        text(XVals(1)+(6+6.4)/XCorrection,yt+0.5,'Open','clipping','off')
        plot(XVals(1)+(6+6.4)/XCorrection,yt,'.','Color',lightGreen,'clipping','off','MarkerSize',13)
        % plot(x1,yt,'.','Color',lightGreen,'clipping','off','MarkerSize',13)
        text(x2,yt,'No inversion','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt+.3,['(\itn\rm = ' num2str(nOpen) ')'],'clipping','off')
        
        yt = yt - .3/YCorrection+.8;
        y1(1:2) = yt-.1/YCorrection;y2(1:2) = yt+.1/YCorrection;cr = cr +1 ;
        % jbfill(x1',y2',y1',colorSpecGrey(cr,:),colorSpecGrey(cr,:),1,.25);
        % plot(x1,yt,'o','Color',darkGreen ,'MarkerSize',4,'clipping','off')
        plot(XVals(1)+(6+6.4)/XCorrection,yt,'o','Color',darkGreen ,'MarkerSize',4,'clipping','off')
        text(x2,yt,'Inversion','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt+.3,['(\itn\rm = ' num2str(nOpening) ')'],'clipping','off')
        
        yt = (YVals(1)+1.4-.7)/YCorrection;
        yt = YVals(1)+(1.4-.7)/YCorrection;
        yt = yt +2;
        text(XVals(1)+(6+6.4)/XCorrection,yt+0.5,'Closed','clipping','off')
        plot(XVals(1)+(6+6.4)/XCorrection,yt,'o','MarkerSize',4,'Color',darkRed,'clipping','off')
        % y1(1:2) = yt-.1;y2(1:2) = yt+.1;cr = cr +1 ;
        % jbfill(x1',y2',y1',colorSpecGrey(cr,:),colorSpecGrey(cr,:),1,.25);
        % plot(x1,yt,'-','Color',darkRed ,'MarkerSize',4,'clipping','off')
        text(x2,yt,'Inversion','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt+.3,['(\itn\rm = ' num2str(nClosing) ')'],'clipping','off')
        
        yt = yt - .3/YCorrection +.8;
        plot(XVals(1)+(6+6.4)/XCorrection,yt,'.','Color',lightRed,'clipping','off','MarkerSize',13)
        % y1(1:2) = yt-.1;y2(1:2) = yt+.1;cr = cr +1 ;
        % jbfill(x1',y2',y1',colorSpecGrey(cr,:),colorSpecGrey(cr,:),1,.25);
        % plot(x1,yt,'.','Color',lightRed,'clipping','off','MarkerSize',13)
        text(x2,yt,'No inversion','clipping','off')
        yt = yt - .2/YCorrection;
        text(x3,yt+.3,['(\itn\rm = ' num2str(nClosed) ')'],'clipping','off')
        
    end
end
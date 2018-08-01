function Video_Figure03_presentation(out)
fontsize = 16;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92;y_width = 7.86*2; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);

close all

group = 1;
trial = 88;
time = out{trial,group}.universalTimeSeriesTend(:,62);
MPD12 = out{trial,group}.universalTimeSeriesTend(:,2)-.08;
MPD13 = out{trial,group}.universalTimeSeriesTend(:,3);
ID12 = -out{trial,group}.universalTimeSeriesTend(:,59)+.08; % artifically inverted ID to best explain all possible scenarios
ID13 = out{trial,group}.universalTimeSeriesTend(:,60);

correctionToGoBehind = -2.5;
p1 = out{trial,group}.universalTimeSeriesTend(:,13:14);
p2 = out{trial,group}.universalTimeSeriesTend(:,15:16);
p2(:,2) = p2(:,2) - -correctionToGoBehind;
p3 = out{trial,group}.universalTimeSeriesTend(:,17:18);

tmp = abs(p1 - p2);
ipd_tmp = sqrt(tmp(:,1).^2 + tmp(:,2).^2);
[~,tend_w2] = min(ipd_tmp);
MPD12(tend_w2:end) = MPD12(tend_w2);
ID12(tend_w2:end) = ID12(tend_w2);

filename = ['Fig03_ExplanationVideo'];
writerObj = VideoWriter(['Figs\' filename '.avi']); % Name it.
writerObj.FrameRate = 24; % How many frames per second.
open(writerObj);

tstart = 1;
tend = 100;

h39 = figure(39);hold off
% for frameTemp = tstart :    100/writerObj.FrameRate    :  tend
frameTemp = tstart;
while frameTemp < tend
    frameTemp = frameTemp + 10/writerObj.FrameRate;
    %     for frameTemp = tstart :    (tend-tstart+1)/writerObj.FrameRate    :  tend
    if (frameTemp + 15/writerObj.FrameRate) > tend
        frameTemp = tend;
    end
    curFrame = round(frameTemp );
    
    prevFrame = curFrame - 12;
    prevFrame(prevFrame <= 0) = 1;
    
    set(h39, 'Position', [0 0 2*560 2*420]);%[x y width height])
    
    hold off
    
    createThePlot()
    
    %     plot(time(1:curFrame),MPD12(1:curFrame))
    %     axis([0 100 -2 2])
    winsize = get(h39,'Position');
    set(h39, 'MenuBar', 'none');
    
    set(h39, 'ToolBar', 'none');
    
    %     winsize(1:2) = [0 0];
    %if mod(i,4)==0, % Uncomment to take 1 out of every 4 frames.
    frame = getframe(h39,winsize); % 'gcf' can handle if you zoom in to take a movie.
    writeVideo(writerObj, frame);
    %     delete(ht1)
    %     delete(ht2)
end

for qt = 1:36 % add one and a half more seconds without movement
    frame = getframe(h39,winsize); % 'gcf' can handle if you zoom in to take a movie.
    writeVideo(writerObj, frame);
end

close(h39)
close(writerObj); % Saves the movie.


    function createThePlot()
        
        % the plots
        %         sb1 = subplot(2,3,1);    hold off
        sb1 = subplot(2,3,4);    hold off
        
        plot(time(1:tend_w2),MPD12(1:tend_w2),'b','LineWidth',2);hold on
        plot(time,MPD13,'r','LineWidth',2)
        plot(time(tend_w2+1:end),MPD12(tend_w2+1:end),':b','LineWidth',2);hold on
        %         if         frameTemp == tend
        rectangle('Position',[frameTemp -1.99 100.001-frameTemp 3.99],'FaceColor',[1 1 1],'EdgeColor',[1 1 1])
        %         end
        
        hline(0,'k');
        axis([0 100 -2 2])
        set(gca,'YTick',[-2 -1 0 1 2])
        set(gca,'XTick',[0 25 50 75 100])
        xlabel('Time (%)')
        ylabel('\itMPD\rm (m)')
        box off
        l1 = legend('\itMPD\rm_{12}','\itMPD\rm_{13}','Location','NorthEast');
        legend('boxoff')
        
        
        %         sb2 = subplot(2,3,2);    hold off
        sb2 = subplot(2,3,5);    hold off
        
        plot(time(1:tend_w2),ID12(1:tend_w2),'b','LineWidth',2);hold on
        
        plot(time,ID13,'r','LineWidth',2)
        plot(time(tend_w2+1:end),ID12(tend_w2+1:end),':b','LineWidth',2);hold on
        
        stepSize = 25; % in percentage
        stepTime = 100/(stepSize+1): 100/(stepSize+1) : 100;
        steps = round(length(ID12) / (stepSize+1)) : round(length(ID12) / (stepSize+1)) : length(ID12);
        for q = 1:stepSize;
            curStep = steps(q)  ;
            curTime = stepTime(q);
            if curStep < length(ID12)
                [~,ind] = min(abs([ID12(curStep) ID13(curStep)]));
                if ind == 1
                    plot([curTime curTime],[0 ID12(curStep)],':k')
                else
                    plot([curTime curTime],[0 ID13(curStep)],':k')
                end
            end
        end
        %         if         frameTemp == tend
        rectangle('Position',[frameTemp -1.99 100.001-frameTemp 3.99],'FaceColor',[1 1 1],'EdgeColor',[1 1 1])%         end
        hline(0,'k');
        axis([0 100 -2 2])
        set(gca,'YTick',[-2 -1 0 1 2])
        set(gca,'XTick',[0 25 50 75 100])
        xlabel('Time (%)')
        ylabel('\itID\rm (m)')
        box off
        l2 = legend('\itID\rm_{12}','\itID\rm_{13}','Location','NorthEast');
        legend('boxoff')
        
        
        
        %         sb3 = subplot(2,3,3);    hold off
        sb3 = subplot(2,3,6);    hold off
        
        temp = [ID12 ID13];
        [~,ind] = min(abs(temp),[],2);
        for ii = 1:length(temp)
            DG(ii,1) = abs(temp(ii,ind(ii)));
            if ~(ID12(ii) < 0 && ID13(ii) > 0) || (ID12(ii) > 0 && ID13(ii) < 0)
                % closed
                DG(ii,1) = DG(ii,1)*-1;
            end
        end
        dind = ind(2:end) - ind(1:end-1);
        inds = find(dind~=0);
        tstart2 = 1;
        for ii = 1:length(inds)+1
            if length(inds) < ii
                % last one
                tend2 = length(ID12);
            else
                tend2 = inds(ii);
            end
            if ind(tstart2) == 1
                % ID12
                plot(time(tstart2:tend2),DG(tstart2:tend2),'b','LineWidth',2);hold on
            else
                % ID13
                plot(time(tstart2:tend2),DG(tstart2:tend2),'r','LineWidth',2);hold on
            end
            tstart2 = tend2+1;
            
        end
        %         if         frameTemp == tend
        rectangle('Position',[frameTemp -1.99 100.001-frameTemp 3.99],'FaceColor',[1 1 1],'EdgeColor',[1 1 1])%         end
        
        
        hline(0,'k');
        axis([0 100 -2 2])
        set(gca,'YTick',[-2 -1 0 1 2])
        set(gca,'XTick',[0 25 50 75 100])
        xlabel('Time (%)')
        ylabel('\itDG\rm (m)')
        box off
        
        
        %         sb4 = subplot(2,3,4.2:5.95);    hold off
        sb4 = subplot(2,3,1.2:2.95);    hold off
        
        plot(p1(1:curFrame*10,1),p1(1:curFrame*10,2),'k','LineWidth',2);hold on
        plot(p1(curFrame*10,1),p1(curFrame*10,2),'<k','MarkerSize',10);
        plot(p2(1:curFrame*10,1),p2(1:curFrame*10,2),'b','LineWidth',2);hold on
        plot(p2(curFrame*10,1),p2(curFrame*10,2),'vb','MarkerSize',10);
        plot(p3(1:curFrame*10,1),p3(1:curFrame*10,2),'r','LineWidth',2);hold on
        plot(p3(curFrame*10,1),p3(curFrame*10,2),'vr','MarkerSize',10);
        
        set(gca,'XTick',[-5 0 5],'YTick',[-5 0 5])
        xlabel('X - position (m)')
        ylabel('Y - position (m)')
        axis([-6 6 -6 6])
        %         get(sb4,'pos')
        %         set(sb4,'Position',[    0.3202862    0.0800    0.382    0.3812])
        set(sb4,'Position',[    0.3402862    0.5800    0.382    0.412])
        
        %         pos =     [0.2219+.02    0.87944    0.1536    0.1000];
        pos =     [0.2219+.01    0.37944    0.1536    0.1000];
        
        set(l1,'Position',pos)
        %         pos =     [    0.5237+.02    0.87944    0.1321    0.1000];
        pos =     [    0.5237+.01    0.37944    0.1321    0.1000];
        
        set(l2,'Position',pos)
        %
        %         pos =     [0.1347-.08    0.1100+.04    0.2039+.03    0.79150];
        %         set(sb1,'Position',pos)
        %         pos =     [0.4155-.02    0.1100+.04    0.2039+.03    0.79150];
        %         set(sb2,'Position',pos)
        %         pos =     [0.6963+.04    0.1100+.04   0.2039+.03    0.79150];
        %         set(sb3,'Position',pos)
        %
        
        
    end




end
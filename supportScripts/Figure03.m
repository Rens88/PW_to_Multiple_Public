function Figure03(out)
% FIGURE03:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% out - contains the data from PW_to_Multiple_Public.mat
%
% Plotting exemplar trials to explain going through and around in terms of
% signed MPD

%%
fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92;y_width =6.5; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);

close all

h = figure(10); hold on;

% Indices of all trials that could be interesting to look at organized
% based on crossing behavior.
% Grey and through --> maybe 12
indTHR =     [29     32    35    40    58    77    85    93   175   186   199   229   235   242   249   256   259   261   273   280   299   301   303   304   315   327   341   342   364   381   394   399   409   416   423   435   437   448   454   455  459   463   468   473   475   477];
% Grey and around and behind --> maybe 1, 2
indBEH = [1    18    28    39    41    44    45    47    53   102   108   115   117   121   132   144   149   153   155   156   181   182   183   206   214   218   219   282   297   300   313   321   345   348   355   369   374   375   379   383   388   393   396   415   418   422   424   432   442   456   461   467   479];
% Grey and around and in front --> 9 looks interesting.
indINF = [     8    19    21    25    62    63    67    72    75    76    79    86    88    96    97   129   136   138   162   173   177   193   198   233   263   278   292   325   333   356   362   402   462];

titleString = {'W1 behind','Through','W1 in front'};

% The trial that will be plotted
i = 13;
indCUR = indINF(i);
% The group that will be plotted
group = 1;
trial = indCUR;

% the variables
time = out{trial,group}.universalTimeSeriesTend(:,62);
MPD12 = out{trial,group}.universalTimeSeriesTend(:,2)-.08;
MPD13 = out{trial,group}.universalTimeSeriesTend(:,3);
ID12 = -out{trial,group}.universalTimeSeriesTend(:,59)+.08; % NB: we artifically inverted ID to best explain all possible scenarios of DG
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

% the plots
sb1 = subplot(1,3,1);    hold off

plot(time(1:tend_w2-1),MPD12(1:tend_w2-1),'b','LineWidth',2);hold on

plot(time,MPD13,'--r','LineWidth',2)
plot(time(tend_w2:end),MPD12(tend_w2:end),':b','LineWidth',2);hold on

hline(0,'k');
axis([0 100 -2 2])
set(gca,'YTick',[-2 -1 0 1 2])
set(gca,'XTick',[0 25 50 75 100])
xlabel('Time (%)')
ylabel('\itMPD\rm (m)')
box off
l1 = legend('\itMPD\rm_{12}','\itMPD\rm_{13}','Location','NorthEast');
legend('boxoff')

sb2 = subplot(1,3,2);    hold off

plot(time(1:tend_w2-1),ID12(1:tend_w2-1),'b','LineWidth',2);hold on

plot(time,ID13,'--r','LineWidth',2)
plot(time(tend_w2:end),ID12(tend_w2:end),':b','LineWidth',2);hold on


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

hline(0,'k');
axis([0 100 -2 2])
set(gca,'YTick',[-2 -1 0 1 2])
set(gca,'XTick',[0 25 50 75 100])
xlabel('Time (%)')
ylabel('\itID\rm (m)')
box off
l2 = legend('\itID\rm_{12}','\itID\rm_{13}','Location','NorthEast');
legend('boxoff')

sb3 = subplot(1,3,3);    hold off

temp = [ID12 ID13];
[~,ind] = min(abs(temp),[],2);
for i = 1:length(temp)
    DG(i,1) = abs(temp(i,ind(i)));
    if ~(ID12(i) < 0 && ID13(i) > 0) || (ID12(i) > 0 && ID13(i) < 0)
        % closed
        DG(i,1) = DG(i,1)*-1;
    end
end
dind = ind(2:end) - ind(1:end-1);
inds = find(dind~=0);
tstart = 1;
for i = 1:length(inds)+1
    if length(inds) < i
        % last one
        tend = length(ID12);
    else
        tend = inds(i);
    end
    if ind(tstart) == 1
        % ID12
        plot(time(tstart:tend),DG(tstart:tend),'b','LineWidth',2);hold on
    else
        % ID13
        plot(time(tstart:tend),DG(tstart:tend),'--r','LineWidth',2);hold on
    end
    tstart = tend+1;
    
end

hline(0,'k');
axis([0 100 -2 2])
set(gca,'YTick',[-2 -1 0 1 2])
set(gca,'XTick',[0 25 50 75 100])
xlabel('Time (%)')
ylabel('\itDG\rm (m)')
box off

pos =     [0.2219-.04    0.87944    0.1536    0.1000];
set(l1,'Position',pos)
pos =     [    0.5237+.02    0.87944    0.1321    0.1000];
set(l2,'Position',pos)

pos =     [0.1347-.08    0.1100+.04    0.2039+.03    0.79150];
set(sb1,'Position',pos)
pos =     [0.4155-.02    0.1100+.04    0.2039+.03    0.79150];
set(sb2,'Position',pos)
pos =     [0.6963+.04    0.1100+.04   0.2039+.03    0.79150];
set(sb3,'Position',pos)

if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end

fpath =  'Figs\';
filename = 'Fig03_examplarGap_MPD_ID_DG';
print( h, '-r300' ,'-dtiff' ,[fpath filename '.tiff']) % here you can specify filename extensions

end
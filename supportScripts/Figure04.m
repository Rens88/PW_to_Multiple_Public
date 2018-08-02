function Figure04(out)
% FIGURE04:
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
% explanation plot DG

%%
i = 1; % Group
j = 8; % Participant

xw1 = out{j,i}.timeSeries(:,13); % x position walker 1
yw1 = out{j,i}.timeSeries(:,14);
xw2 = out{j,i}.timeSeries(:,15);
yw2 = out{j,i}.timeSeries(:,16);
xw3 = out{j,i}.timeSeries(:,17);
yw3 = out{j,i}.timeSeries(:,18);
dg = out{j,i}.universalTimeSeriesTend(988,55) - out{j,i}.universalTimeSeriesTend(988,56);

tp = 300;

fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 16.5;y_width = 16.5/3; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);
h12 = figure(12);

ycor = +.03;
ycorX = +.4052;
ylength = -.09;

i1 = 2;j1 = 38;

[~,~,~,~,~,~,~, ~, ~, ~, ...
    ~,~,~,~,~,~,sb1] = computeGapForPlot(out,i1,j1,tp,1);
set(gca,'XTick',[-5 0 5],'YTick',[-5 0 5])
set(gca,'XTick',[-5 0 5],'YTick',[-5 0 5])
pos2 =     [0.1357-.07-.024    0.1100-.02+.087-ycor    0.2077+.04+.013    0.8150+.09+.15+ylength ];
set(sb1,'Pos',pos2)
yp = ylabel('y position (m)');
xp = xlabel('x position (m)');
px =[    0.0000  -10.7072630+ycorX   -1.0000];
set(xp,'Pos',px)
get(yp,'Pos')
py = [  -11.4691+1.1   0.0000   -1.0000];
set(yp,'Pos',py)

i2 = 1;j2 = 89;
[~,~,~,~,~,~,~, ~, ~, ~, ...
    ~,~,~,~,~,~,sb2] = computeGapForPlot(out,i2,j2,tp,2);
set(gca,'XTick',[-5 0 5],'YTick',[-5 0 5])
pos3 =     [0.4165-.015-.016    0.1100-.02+.087-ycor    0.2077+.04+0.013    0.8150+.09+.15+ylength ];
set(sb2,'Pos',pos3)
yp = ylabel('y position (m)');
xp = xlabel('x position (m)');
px =[    0.0000  -10.7072630+ycorX   -1.0000];
set(xp,'Pos',px)
py = [  -11.4691+1.1    0.0000   -1.0000];
set(yp,'Pos',py)

i3 = 3;j3 = 26;
[~,~,~,~,~,~,~, ~, ~, ~, ...
    ~,~,~,~,~,~,sb3] = computeGapForPlot(out,i3,j3,tp,3);
pos1 =     [0.6973+.04-.008    0.1100-.02+.087-ycor    0.2077+.04+.013    0.8150+.09+.15+ylength ];
set(sb3,'Pos',pos1)
yp = ylabel('y position (m)');
xp = xlabel('x position (m)');
px =[    0.0000  -10.7072630+ycorX   -1.0000];
set(xp,'Pos',px)
py = [  -11.4691+1.1    0.0000   -1.0000];
set(yp,'Pos',py)

if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end
fpath =  'Figs\';
print( h12, '-r300' ,'-dtiff' ,[fpath 'Fig04_gapexplanationSampleData.tiff']) % here you can specify filename extensions


fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 15.92/2;y_width = 7.86; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);

end

function [vxw1,vyw1,vxw2,vyw2,vxw3,vyw3,DG2, DG3, ip12, ip13, ...
    xw1,yw1,xw2,yw2,xw3,yw3,sb] = ...
    computeGapForPlot(out,i,j,tp,q)

if q == 1
    maxk = 710;
elseif q == 2
    maxk = 800;
else
    maxk = 700;
end
c1 = [0 0 0];
c2 = c1;
c3 = c2;
cvirt = [150 150 150]/255;
xw1 = out{j,i}.timeSeries(:,13); % x position walker 1
yw1 = out{j,i}.timeSeries(:,14);
xw2 = out{j,i}.timeSeries(:,15);
yw2 = out{j,i}.timeSeries(:,16);
xw3 = out{j,i}.timeSeries(:,17);
yw3 = out{j,i}.timeSeries(:,18);

time = 1/120 : 1/120 : length(xw1) / 120;

vw1 = velocity_vector([xw1 yw1], time);
vw2 = velocity_vector([xw2 yw2], time);
vw3 = velocity_vector([xw3 yw3], time);

k = 0;
if yw2(1) > 0
    mult23 = -1;
else
    mult23 = 1;
end
if xw1(1) > 0
    mult1 = -1;
else
    mult1 = 1;
end

stoploop = 0;
while stoploop == 0
    k = k +1;
    
    vxw1(k) = xw1(tp) + (k*vw1(tp,1) / 120);% VIRTUAL x position walker 1
    vxw2(k) = xw2(tp) + (k*vw2(tp,1) / 120);
    vxw3(k) = xw3(tp) + (k*vw3(tp,1) / 120);
    vyw1(k) = yw1(tp) + (k*vw1(tp,2) / 120);% VIRTUAL x position walker 1
    vyw2(k) = yw2(tp) + (k*vw2(tp,2) / 120);
    vyw3(k) = yw3(tp) + (k*vw3(tp,2) / 120);
    
    if k == maxk
        break
    elseif mult1*(vxw1(k)) > 3.5  && ...
            mult23*(vyw2(k)) > 3.5 && ...
            mult23*(vyw3(k)) > 3.5
        % all virtual displacements bigger than threshold.
        stoploop = 1;
    end
    
end

% calculate gap specifically for plot
vtemp1(1:length(vxw1),1) = vw1(tp,1);
vtemp1(1:length(vxw1),2) = vw1(tp,2);
vtemp2(1:length(vxw1),1) = vw2(tp,1);
vtemp2(1:length(vxw1),2) = vw2(tp,2);
vtemp3(1:length(vxw1),1) = vw3(tp,1);
vtemp3(1:length(vxw1),2) = vw3(tp,2);

[resultat, cumul_effet_mpd_1,cumul_effet_mpd_2, ...
    cumul_effet_mpd_tang_1,cumul_effet_mpd_orient_1,cumul_effet_mpd_tang_2, ...
    cumul_effet_mpd_orient_2,cumul_effet_mpd_total,tti_fenetre,mpd_fenetre, ...
    effect_inst,visible_first,index_dmin,instantPassagePointCommun12,cont1_12,cont2_12 ] = ...
    traitement_experience_MPI([vxw1; vyw1]',[vxw2; vyw2]',[1/120 : 1/120 : length(vyw2)/120],1);
ip12 = instantPassagePointCommun12(1);
[resultat, cumul_effet_mpd_1,cumul_effet_mpd_2, ...
    cumul_effet_mpd_tang_1,cumul_effet_mpd_orient_1,cumul_effet_mpd_tang_2, ...
    cumul_effet_mpd_orient_2,cumul_effet_mpd_total,tti_fenetre,mpd_fenetre, ...
    effect_inst,visible_first,index_dmin,instantPassagePointCommun13,cont1_12,cont2_12 ] = ...
    traitement_experience_MPI([vxw1; vyw1]',[vxw3; vyw3]',[1/120 : 1/120 : length(vyw2)/120],1);
ip13 = instantPassagePointCommun13(1);

DG2 = out{j,i}.timeSeries(tp,56); % gap size to W2
DG3 = out{j,i}.timeSeries(tp,57); % gap size to W3

if q == 1 % in front
    nPlot = 1;
    text_ID12 = '\it+ID\rm_{12}';
    text_ID13 = '\it+ID\rm_{13}';
    fakeMPD12 = 250;
    fakeMPD13 = 550;
    
elseif q == 2 % through
    nPlot = 2;
    text_ID12 = '\it+ID\rm_{12}';
    text_ID13 = '\it-ID\rm_{13}';
    fakeMPD12 = 300;
    fakeMPD13 = 450;
    
else % behind
    nPlot = 3;
    text_ID12 = '\it-ID\rm_{12}';
    text_ID13 = '\it-ID\rm_{13}';
    fakeMPD12 = 200;
    fakeMPD13 = 500;
    
end
sb = subplot(1,3,nPlot);hold off

% displacement until now
plot(xw1(1:tp),yw1(1:tp),'Color',c1);hold on;
plot(xw2(1:tp),yw2(1:tp),'Color',c2);
plot(xw3(1:tp),yw3(1:tp),'Color',c3);

% predicted displacement based on current velocity vector
plot(vxw1,vyw1,'--','Color',c1);
plot(vxw2,vyw2,'--','Color',c2);
plot(vxw3,vyw3,'--','Color',c3);

% Fake MPD position
plot(vxw1(fakeMPD12),vyw1(fakeMPD12),'*','Color',c2);
plot(vxw1(fakeMPD13),vyw1(fakeMPD13),'o','Color',c2);
% plot current position
plot(xw1(tp),yw1(tp),'.','MarkerSize',10,'Color',c1);
plot(xw2(tp),yw2(tp),'.','MarkerSize',10,'Color',c2);
plot(xw3(tp),yw3(tp),'.','MarkerSize',10,'Color',c3);

% position when w1 intersects respective trajectory
plot(vxw2(ip12),vyw2(ip12),'*','Color',c2);
plot(vxw3(ip13),vyw3(ip13),'o','Color',c3);

% plot the hypothetical 'door'
plot(vxw1(end),vyw1(end) - DG2,'*','Color',cvirt)
plot(vxw1(end),vyw1(end) - DG3,'o','Color',cvirt)
[~,dsmall] = min([abs(DG2) abs(DG3)]);
if dsmall == 1
    DGsmall = DG2;
else
    DGsmall = DG3;
end
plot([vxw1(end)+1.5 vxw1(end)+2],[vyw1(end) vyw1(end)],'Color',cvirt)
plot([vxw1(end)+1.5 vxw1(end)+2],[vyw1(end)-DGsmall vyw1(end)-DGsmall],'Color',cvirt)
plot([vxw1(end)+2 vxw1(end)+2],[vyw1(end) vyw1(end)-DGsmall],'Color',cvirt)
ycoord = (vyw1(end) - (DGsmall) /2);
if q == 2
    text(vxw1(end)+2.5,ycoord,'\itDG\rm','Color',cvirt);
else
    text(vxw1(end)+2.5,ycoord,'\it-DG\rm','Color',cvirt);
end


if vxw1(end) < xw1(1)
    plot(vxw1(end),vyw1(end),'<','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c1)
else
    plot(vxw1(end),vyw1(end),'>','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c1)
end
if vyw2(end) < yw2(1)
    plot(vxw2(end),vyw2(end),'v','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c2)
    plot(vxw3(end),vyw3(end),'v','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c3)
else
    plot(vxw2(end),vyw2(end),'^r','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c2)
    plot(vxw3(end),vyw3(end),'^g','MarkerSize',8,'MarkerFaceColor',[1 1 1],'Color',c3)
end
text(xw1(1),yw1(1)+1,'W1')

if xw2(1) > xw3(1)
    text(xw2(1)+.2,yw2(1),'W2')
    text(xw3(1)-1.2,yw3(1),'W3')
else
    text(xw2(1)-3,yw2(1),'W2')
    text(xw3(1)+.8,yw3(1),'W3')
end

% label ID
% 12
Xx = vxw1(ip12);
Xy = vyw1(ip12);
temp = [abs(vxw1' - Xx) abs(vyw1' - Xy)];
distFromID = sqrt(temp(:,1).^2 + temp(:,2).^2);
st = find(distFromID < .8,1,'first');
en = find(distFromID < 1.6,1,'first');

Ax = vxw1(st);
Ay = vyw1(st);
Bx = vxw1(en);
By = vyw1(en);
XAx = Xx - Ax;XAy = Xy - Ay;
XBx = Xx - Bx;XBy = Xy - By;
Cx = vxw2(ip12) - XBx;
Cy = vyw2(ip12) - XBy;
Dx = vxw2(ip12) - XAx;
Dy = vyw2(ip12) - XAy;

if q == 1
    tx = -4.35;%-3.4;
    ty = 4.5;%-2.5;
elseif q == 2
    tx = -2.95;%-3.4;
    ty = 5;%-2.5;
else
    tx = -3;%-4.1;
    ty = 5;%2.5;
end

th = text(tx,ty,text_ID12);
set(th,'HorizontalAlignment','center','VerticalAlignment','middle','Color',cvirt)

%13
Xx = vxw1(ip13);
Xy = vyw1(ip13);
temp = [abs(vxw1' - Xx) abs(vyw1' - Xy)];
distFromID = sqrt(temp(:,1).^2 + temp(:,2).^2);
st = find(distFromID < .8,1,'last');
en = find(distFromID < 1.6,1,'last');

Ax = vxw1(st);
Ay = vyw1(st);
Bx = vxw1(en);
By = vyw1(en);
XAx = Ax - Xx;XAy = Xy - Ay;
XBx = Bx - Xx;XBy = Xy - By;
Cx = vxw3(ip13) + XBx;
Cy = vyw3(ip13) - XBy;
Dx = vxw3(ip13) + XAx;
Dy = vyw3(ip13) - XAy;

if q == 1
    tx = 3;%3.6;
    ty = 3;%-2.5;
elseif q == 2
    tx = 4;%3;8
    ty = 5;%2.55;
else
    tx = 4.5;%5.3;
    ty = 5;%2.5;
end
th = text(tx,ty,text_ID13);
set(th,'HorizontalAlignment','center','VerticalAlignment','middle','Color',cvirt)

box off
axis([-9 9 -9 9])
ylabel('y position (m)')
xlabel('x position (m)')

end
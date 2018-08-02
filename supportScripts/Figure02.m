function Figure02(out)
% FIGURE02:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
%
% out - contains the data from PW_to_Multiple_Public.mat

%%
close all

fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
y_width = 16.5/3;x_width = 8.25; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);
fid = figure(10);

% The example was based on:
% Group
i = 4;
% Trial
j = 55;

%%%%%%%%%%%%%%%%%%%%%%
IPD12 = out{j,i}.timeSeries(:,31);
IPD13 = out{j,i}.timeSeries(:,32);

time = 1/120 : 1/120 : length(IPD13)/120;
p1 = out{j,i}.timeSeries(:,13:14);
p2 = out{j,i}.timeSeries(:,15:16);
p3 = out{j,i}.timeSeries(:,17:18);
vv1 = velocity_vector(p1,time);
vv2 = velocity_vector(p2,time);
vv3 = velocity_vector(p3,time);

v1 = sqrt(sum(vv1.^2,2));
v2 = sqrt(sum(vv2.^2,2));
v3 = sqrt(sum(vv3.^2,2));

tstart = out{j,i}.timing(4);
tMD12 = out{j,i}.timing(6);
tMD13 = out{j,i}.timing(1);
tID12 = out{j,i}.timing(15);
tID13 = out{j,i}.timing(14);
vl = [tstart tMD12 tMD13]/120;


% heading
dir1 = atan2(p1(:,2),p1(:,1)) + pi;
dir2 = atan2(p2(:,2),p2(:,1)) + pi;
dir3 = atan2(p3(:,2),p3(:,1)) + pi;

dir1(dir1 > 2*pi) = dir1(dir1 >= 2*pi) - 2*pi;
dir2(dir2 > 2*pi) = dir2(dir2 >= 2*pi) - 2*pi;
dir3(dir3 > 2*pi) = dir3(dir3 >= 2*pi) - 2*pi;

% the heading (corrected for walking in a different direction)
dir1 = atan2(vv1(:,1),vv1(:,2))+pi;
dir2 = atan2(vv2(:,2),vv2(:,1));
dir3 = atan2(vv3(:,2),vv3(:,1));

% the rate of change of the heading in rad per second
vdir1 = gradient(atan2(vv1(:,1),vv1(:,2)),1/120) .* 180/pi;
vdir2 = gradient(atan2(vv2(:,2),vv2(:,1)),1/120) .* 180/pi;
vdir3 = gradient(atan2(vv3(:,2),vv3(:,1)),1/120) .* 180/pi;

sb1 = subplot(1,3,2);hold off


plot(time,vdir1,'--k');hold on;
plot(time,vdir2,':k');
plot(time,vdir3,'Color',[200 200 200]/255);


l2 = legend('W1','W2','W3');
legend boxoff

xcor = .2;
yt = 80;
axis([0 10 -90 74])
vline(vl,'k');
axis([0 10 -90 90])

t1 = text(vl(1)-xcor,yt,'t_{start}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(2)-xcor,yt,'t_{MD12}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(3)-xcor,yt,'t_{MD13}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');

xlabel('Time (s)');
ylabel('Change in Heading (deg.s^{-1})');
box off

% % sneaky legend
sb2 = subplot(1,3,1);hold off

plot(time,v1,'--k');hold on;
plot(time,v2,':k');
plot(time,v3,'Color',[200 200 200]/255);

l1 = legend('W1','W2','W3');
legend boxoff

xcor = .2;
yt = 1.55;
vline(vl,'k');
t1 = text(vl(1)-xcor,yt,'t_{start}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(2)-xcor,yt,'t_{MD12}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(3)-xcor,yt,'t_{MD13}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');

axis([0 10 0 1.65])
xlabel('Time (s)');
ylabel('Speed (m.s^{-1})');
box off

% % sneaky legend
sb3 = subplot(1,3,3);hold off

plot(time,IPD12,'--k'); hold on;
plot(time,IPD13,'Color',[200 200 200]/255);
l3 = legend('W12','W13');
legend boxoff

xcor = .2;
yt = 11.4;%10.1;
axis([0 10 0 10.8])
vline(vl,'k');
t1 = text(vl(1)-xcor,yt,'t_{start}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(2)-xcor,yt,'t_{MD12}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');
t1 = text(vl(3)-xcor,yt,'t_{MD13}');
set(t1,'rotation',90);%,'HorizontalAlignment','center');

axis([0 10 0 12])
xlabel('Time (s)');
ylabel('Interpersonal distance (m)')
box off

pos = get(l1,'Position');
disp(pos)
correction = [0 0.06 0.13 0];
set(l1, 'Position', pos+correction)

pos = get(l2,'Position');
disp(pos)
correction = [0 0.06 0.13 0];
set(l2, 'Position', pos+correction)

pos = get(l3,'Position');
disp(pos)
correction = [0 0.06 0.13 0];

set(l3, 'Position', pos+correction)

%%%%%%%%%%%%
% Change this if you want to turn the legends back on
set(l1,'visible','off')
set(l2,'visible','off')
set(l3,'visible','off')

set(gcf, 'Units', 'Centimeters', 'OuterPosition', [5,5, 20, 10]);
if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end
fpath =  'Figs\';

print( fid, '-r300' ,'-dtiff' ,[fpath 'Fig02_timingExplanation.tiff']) % here you can specify filename extensions

end
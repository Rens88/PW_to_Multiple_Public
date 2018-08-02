function Figure06(out)
% FIGURE06:
% 02-08-2018 Rens Meerhoff
% For questions, contact rensmeerhoff@gmail.com.
%
% Code was used for:
% 'Collision avoidance with multiple walkers: Sequential or simultaneous interactions?'
% Authored by: Laurentius A. Meerhoff, Julien Pettre, Sean D. Lynch, Armel Cretual, Anne-Helene Olivier
% Submitted to: Frontiers in Psychology
% out - contains the data from PW_to_Multiple_Public.mat
%
% This plots the frequency of PpA crossing through the middle of PpB&C. It
% is ordered per RELATIVE starting formation (that is, depending on the
% direction of crossing, formations have been mirrored). The percentage is
% computed as the percentage of the total trials in that condition.

%%
res = NaN(500,8);
res2 = NaN(500,8);
count = 0;            countpw = 0;
cgrey = [210 210 210]/255;
for i = 1:4
    for j = 1:120
        if max(j == [10 11 30 31 50 51 70 71 90 91 110 111]) ~= 1
            
            count = count +1;
            temp(count,1) = out{j,i}.formation(8);
            temp(count,2) = out{j,i}.crossed(3);
            
            res(count,temp(count,1)+1) = temp(count,2);
            
            if out{j,i}.crossed(1) == 1 && out{j,i}.crossed(2) == 0
                % crossed
                order = 1;
            elseif out{j,i}.crossed(1) == 0 && out{j,i}.crossed(2) == 1
                % crossed
                order = 1;
                
            elseif out{j,i}.crossed(1) == 1 && out{j,i}.crossed(2) == 1
                % w1 in front
                order = 2;
            elseif out{j,i}.crossed(1) == 0 && out{j,i}.crossed(2) == 0
                % w1 in front
                order = 3;
            elseif any(isnan(out{j,i}.crossed));
                order = NaN;
            else
                
                error('passing order unclear')
            end
            
            res2(count,temp(count,1)+1) = order;
        else
            countpw = countpw +1;
            pw(countpw) = out{j,i}.crossed(1);
        end
        
    end
end

pwPerc = sum(pw) / length(pw); % problematic since there is no allocation of W1 or W2 in the pairwise trials

top = nansum(res,1);
top2(1,:) = sum(res2 == 1);
top2(2,:) = sum(res2 == 2);
top2(3,:) = sum(res2 == 3);
for k = 0:8
    total(k+1) = length(temp(temp(:,1) == k));
end
perc(:,1) = top./total*100;

perc2(:,1) = top2(1,:) ./ sum(top2,1) *100;
perc2(:,2) = top2(2,:) ./ sum(top2,1) *100;
perc2(:,3) = top2(3,:) ./ sum(top2,1) *100;

fontsize = 9;
set(0,'defaultaxesfontsize',fontsize);set(0,'defaulttextfontsize',fontsize);
set(0,'defaultaxesfontname','Gill Sans MT');set(0,'defaulttextfontname','Gill Sans MT');
x_width = 12;y_width = 7; % might change this for poster
set(0,'defaultFigurePaperunits','centimeters','defaultFigurePapersize',[x_width, y_width],'defaultFigurePaperposition',[0 0 x_width y_width]);
fid = figure();

axes1 = axes('Parent',fid);
hold(axes1,'on');
ylabel('Gap crossing behavior (%)')
xlabel('Starting formation')

toplot = [perc2([4 2 8 6 1],2) perc2([4 2 8 6 1],1) perc2([4 2 8 6 1],3)];
toplot2 = [perc2([5 3 9 7],2) perc2([5 3 9 7],1) perc2([5 3 9 7],3)];

xpos = [1 3.5 6 8.5];
b1 = bar(xpos,toplot(1:4,:),'stacked','barwidth',.2,'EdgeColor',[0 0 0]);
xpos = xpos + 1;
set(b1,{'FaceColor'},{'w';'k';cgrey});

b2 = bar(xpos,toplot2(1:4,:),'stacked','barwidth',.2,'EdgeColor',[0 0 0]);
set(b2,{'FaceColor'},{'w';'k';cgrey});

h6 = text(3.5,toplot(2,1)+toplot(2,2)/2,'through');
set(h6, 'rotation', 90,'HorizontalAlignment','center','Color','w')

h6a = text(3.5,toplot(2,1)/2,'in front');
set(h6a, 'rotation', 90,'HorizontalAlignment','center','Color','k')
h6b = text(3.5,toplot(2,1) + toplot(2,2) + toplot(2,3)/2,'behind');
set(h6b, 'rotation', 90,'HorizontalAlignment','center','Color','k')

set(axes1,'GridLineStyle','none','XTick',[1.5 4 6.5 9],'XTickLabel',{'-45^{o}   ','0^{o}   ','45^{o}   ','90^{o}   '});
set(axes1,'GridLineStyle','none','YTick',[0 25 50 75 100],'YTickLabel',{'0','','50','','100'});

textXcor = .43;

tPos2 = [1 -4.5 0;...
    3.5 -4.5 0; ...
    6 -4.5 0; ...
    8.5 -4.5 0];
tPos4 = [2 -4.5 0; ...
    4.5 -4.5 0; ...
    7 -4.5 0; ...
    9.5 -4.5 0];

for q = 1:4
    h4 = text('Position',tPos2(q,:),'String','2m');
    set(h4, 'rotation', 90,'HorizontalAlignment','center')
    h5 = text('Position',tPos4(q,:),'String','4m');
    set(h5, 'rotation', 90,'HorizontalAlignment','center')
end

set(get(gca,'YLabel'),'Rotation',90);
set(get(gca,'XLabel'),'Rotation',180,'VerticalAlignment','bottom');
axes1.XTickLabelRotation=90;
axes1.YTickLabelRotation=90;

axis([0.25 10 0 100])

scale = 1.1;
pos = get(gca, 'Position');
pos(1) = .1;
pos(2) = .2;
pos(3) = .87;
pos(4) = .76;
set(gca, 'Position', pos)
if exist('Figs') ~= 7
    disp('WARNING: Could not find folder <Figs>')
end
print(  '-r300' ,'-dtiff' ,'Figs\Fig06_freq_cross_updated_onlyonce_bf_rotated.tiff') % here you can specify filename extensions

end
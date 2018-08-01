% 07/04/2017, Rens Meerhoff
% Where 'conditionsID' is specified by an integer input:
% 1 = 'Midmid'
% 2 = '2m, 0deg'
% 3 = '4m, 0deg'
% 4 = '2m, -45deg'
% 5 = '4m, -45deg'
% 6 = '2m, 90deg'
% 7 = '4m, 90deg'
% 8 = '2m45deg'
% 9 = '4m45deg'
% 10= 'Pairwise'

% Where 'Center' contains the 'x' and 'y' center in the current axis.
% Where 'Radius' the 'x' and 'y' multiplication factor.

function visualizeFormation_PosOnly_noRadius(conditionString,Center,Radius)
% conditionString = {'4m, -450deg'};
% conditions = {'Midmid','2m, 0deg','4m, 0deg','2m, -45deg','4m, -45deg' ...
%     '2m, 90deg','4m, 90deg','2m45deg','4m45deg','Pairwise'};
% conditions = {'Midmid','2m_0deg','4m_0deg','2m_-45deg','4m_-45deg' ...
%     '2m_90deg','4m_90deg','2m_45deg','4m_45deg','Pairwise'};
conditions = {'0m_000deg','2m_000deg','4m_000deg','2m_-45deg','4m_-45deg' ...
    '2m_090deg','4m_090deg','2m_045deg','4m_045deg','Pairwise'};
conditionsID = conditionString;
% for q = 1:length(conditions)
%     if strcmp(conditionString,conditions{q})
%         conditionsID = q;
%         break
%     end
% end


if ~isempty(conditionsID)
    % To convert from Radius to Diameter
    Diameter = Radius / 2;
    XCorr = -.15;
    YCorr = .25;
    Center(1) = Center(1) - XCorr * Radius(1);
    Center(2) = Center(2) - YCorr * Radius(2);
    
    % Create white background to plot on top of
    % %     vertices = [-.57 -.27; .29 -.27; .29 .77; -.57 .77]*2;
    % %     patch(Center(1)+Diameter(1).*(vertices(:,1)), ...
    % %         Center(2)+Diameter(2).*(vertices(:,2)), 'w');hold on;
    % %
    c2 = [112 112 112]/255;
    c1 = [0 0 0];
    
    c1Highlighted = [1 0 0];
    c2Highlighted = [0 0 1];
    
    
    
    %     temp = [2 NaN NaN 8 NaN NaN 6 NaN NaN 4];
    %     temp = [4 NaN NaN 2 NaN NaN 8 NaN NaN 6];
    
    %         [9 3 4 5 6 7 8 1 2 0];
    
    nform = conditionsID;%temp(conditionsID);
    if nform == 4 % 0 deg
        ycorrectionW2 = -0.3869;
        ycorrectionW3 = -0.3869;
        xcorrectionW2 = -.14;
        xcorrectionW3 = .14;
        degText = '0^o';
    elseif nform == 2 % 45 deg
        ycorrectionW2 = -0.3269;
        ycorrectionW3 = -0.4469;
        xcorrectionW2 = -.26;
        xcorrectionW3 = .26;
        degText = '-45^o';
    elseif nform == 8 % 90 deg
        ycorrectionW3 = -0.3069;
        ycorrectionW2 = -0.4669;
        xcorrectionW2 = -.14;
        xcorrectionW3 = .14;
        degText = '90^o';
    elseif nform == 6 % -45 deg
        ycorrectionW3 = -0.3269;
        ycorrectionW2 = -0.4469;
        xcorrectionW2 = -.26;
        xcorrectionW3 = .26;
        degText = '45^o';
    end
    
    
    
    plot(Center(1)+Diameter(1)*([-.38 .38]),Center(2)+Diameter(2)*([1 1]),'Color',c1,'LineWidth',1.5);hold on;
    plot(Center(1)+Diameter(1)*([0 0]),Center(2)+Diameter(2)*([.62 1.38]),'Color',c1,'LineWidth',1.5);
    plot(Center(1)+Diameter(1)*(.38*[-sind(45) sind(45)]),Center(2)+Diameter(2)*(1+.38*[cosd(45) -cosd(45)]),'Color',c1,'LineWidth',1.5);
    plot(Center(1)+Diameter(1)*(.38*[-sind(45) sind(45)]),Center(2)+Diameter(2)*(1+.38*[-cosd(45) cosd(45)]),'Color',c1,'LineWidth',1.5);
    
    x45 = (-sind(-45)/.8)-0.2;
    y45 = cosd(45)/.8+.05;
    x0 = 1.1;
    y0 = 0.05;
    x90 = -.075;
    y90 = 1.22;
    
    degX = Center(1)+Diameter(1)*(-.6);
    degY = Center(2)+Diameter(2)*(1+.38*y0);
    text(degX,degY,degText,'HorizontalAlignment','Right','VerticalAlignment','middle','FontWeight','bold','FontSize',10)
    
%     text(Center(1)+Diameter(1)*(x90),Center(2)+Diameter(2)*(1+.38*y90),'90^{o}')
%     text(Center(1)+Diameter(1)*(.38*x45),Center(2)+Diameter(2)*(1+.38*-y45),'45^{o}')
%     text(Center(1)+Diameter(1)*(.38*x0-.025),Center(2)+Diameter(2)*(1+.38*y0),'0^{o}')
%     text(Center(1)+Diameter(1)*(.38*x45-.05),Center(2)+Diameter(2)*(1+.38*y45+0.025),'-45^{o}')
    
    plot(Center(1)+Diameter(1)*([-1 0]),Center(2)+Diameter(2)*([0 0]),'Color',c2);
    plot(Center(1)+Diameter(1)*(-1),Center(2)+Diameter(2)*(0),'.','Color',c2,'MarkerSize',14,'MarkerFaceColor',c2)
    plot(Center(1)+Diameter(1)*(0),Center(2)+Diameter(2)*(0),'>','Color',c2,'MarkerSize',10,'MarkerFaceColor',c2)
    h10 = text(Center(1)+Diameter(1)*(-.8),Center(2)+Diameter(2)*(.12),'W1','Color',c1);
    h11 = text(Center(1)+Diameter(1)*(xcorrectionW2),Center(2)+Diameter(2)*(.2),'W2','Color',[1 0 0]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(h11,'rotation',90)
    
    countn = 0;
    for i = 3:6
        for j = 2%1:2
            countn = countn +2;
            [th, r] = cart2pol(0,1);
            dr = ((j-.5)/6.25);
            dth1 = ((2*pi)/8) * i ;
            dth2 = ((2*pi)/8) * (i+4) ;
            [x,y] = pol2cart(dth1,dr);
            [x2,y2] = pol2cart(dth2,dr);
            
            plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*(y+1),'o','Color',c1,'MarkerSize',4)
            plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*(y+1),'.w','MarkerSize',12)
            plot(Center(1)+Diameter(1)*(x2),Center(2)+Diameter(2)*(y2+1),'.','Color',c1,'MarkerSize',14)
        end
    end
    
    %     if conditionsID == 10
    %         plot(Center(1)+Diameter(1)*(-.0),Center(2)+Diameter(2)*(1),'o','Color',c1)
    %         plot(Center(1)+Diameter(1)*(-.0),Center(2)+Diameter(2)*(1),'.w','MarkerSize',20)
    %         plot(Center(1)+Diameter(1)*(-.0),Center(2)+Diameter(2)*(1),'o','Color',c1Highlighted)
    %         plot(Center(1)+Diameter(1)*(-.0),Center(2)+Diameter(2)*(1),'.w','MarkerSize',20)
    %         x = Center(1)+Diameter(1)*(-0.0);
    %         y = 0;
    %         plot([x x],Center(2)+Diameter(2)*[y+1  -0.3869],'--k')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         plot(x,Center(2)+Diameter(2)*( -0.3869),'vk','MarkerSize',8,'MarkerFaceColor',c1Highlighted)
    %
    %     else
    
    h12 = text(Center(1)+Diameter(1)*(xcorrectionW3),Center(2)+Diameter(2)*(.2),'W3','Color',[0 0 1]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(h12,'rotation',90)
    
    countn = 0;
    for i = 3:6
        for j = 2%1:2
            countn = countn +2;
            [th, r] = cart2pol(0,1);
            dr = ((j-.5)/6.25);
            dth1 = ((2*pi)/8) * i ;
            dth2 = ((2*pi)/8) * (i+4) ;
            [x,y] = pol2cart(dth1,dr);
            [x2,y2] = pol2cart(dth2,dr);
            if countn == nform
                if nform == 8
                    x  = x  - Diameter(1) * .05;
                    x2 = x2 + Diameter(1) * .05;
                end
                hold on;
                plot(Center(1)+Diameter(1)*([x x]),Center(2)+Diameter(2)*([y+1  -0.3869]),'--r', 'LineWidth', 1.6)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                plot(Center(1)+Diameter(1)*([x2 x2]),Center(2)+Diameter(2)*([y2+1  -0.3869]),':b', 'LineWidth', 1.6)
                
                plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*( ycorrectionW2),'vk','MarkerSize',8,'MarkerFaceColor',c1Highlighted)
                plot(Center(1)+Diameter(1)*(x2),Center(2)+Diameter(2)*( ycorrectionW3),'vk','MarkerSize',8,'MarkerFaceColor',c2Highlighted)
                
                
                plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*(y+1),'o','linewidth',1.5,'Color',c1Highlighted)
                plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*(y+1),'.','MarkerSize',18,'Color',[1 1 1])
                
                %                 plot(Center(1)+Diameter(1)*(x),Center(2)+Diameter(2)*(y+1),'.','MarkerSize',20,'Color',c1Highlighted)
                %                 plot(Center(1)+Diameter(1)*(x2),Center(2)+Diameter(2)*(y2+1),'.g','linewidth',1.2,'MarkerSize',22,'Color',c2Highlighted)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                plot(Center(1)+Diameter(1)*(x2),Center(2)+Diameter(2)*(y2+1),'o','linewidth',1.5,'Color',c2Highlighted)
                plot(Center(1)+Diameter(1)*(x2),Center(2)+Diameter(2)*(y2+1),'.','MarkerSize',18,'Color',[1 1 1])
                %                 ,'.g','linewidth',1.2,'MarkerSize',22,'Color',c2Highlighted)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
            end
        end
    end
    %     plot(Center(1)+Diameter(1)*(0.04),Center(2)+Diameter(2)*(1),'.','Color',c1,'MarkerSize',22)
    %     plot(Center(1)+Diameter(1)*(-.04),Center(2)+Diameter(2)*(1),'o','Color',c1)
    %     plot(Center(1)+Diameter(1)*(-.04),Center(2)+Diameter(2)*(1),'.w','MarkerSize',20)
    if nform == 9
        plot(Center(1)+Diameter(1)*(0.04),Center(2)+Diameter(2)*(1),'.','Color',c2Highlighted,'MarkerSize',22)
        plot(Center(1)+Diameter(1)*(-.04),Center(2)+Diameter(2)*(1),'o','Color',c1Highlighted)
        plot(Center(1)+Diameter(1)*(-.04),Center(2)+Diameter(2)*(1),'.w','MarkerSize',20)
        x = Center(1)+Diameter(1)*(-0.04);
        y = 0;
        x2 = Center(1)+Diameter(1)*(0.04);
        y2 = 0;
        plot([x x],Center(2)+Diameter(2)*[y+1  -0.3869],'--k')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot([x2 x2],Center(2)+Diameter(2)*[y2+1  -0.3869],':k')
        plot(x,Center(2)+Diameter(2)*( -0.3869),'vk','MarkerSize',8,'MarkerFaceColor',c1Highlighted)
        plot(x2,Center(2)+Diameter(2)*( -0.3869),'vk','MarkerSize',8,'MarkerFaceColor',c2Highlighted)
    end
    %     end
else
    disp('Formation not recognized for visualization')
end
end
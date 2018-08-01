function [h] = spm1d_plot_errorcloud(y, ye, x,transparancy)

Q         = numel(y);
if nargin==2 || isnan(x)
    x         = 0:Q-1;
end
if nargin < 4
    transparancy = 0.5;
end
[y0,y1]   = deal(y+ye, y-ye);
[x,y0,y1] = deal( [x(1) x x(end)], [y0(1) y0 y0(end)], [y1(1) y1 y1(end)]);
[x1,y1]   = deal(fliplr(x), fliplr(y1));
[X,Y]     = deal([x x1], [y0 y1]);
h         = patch(X, Y, 0.7*[1,1,1]);
set(h, 'FaceAlpha',transparancy, 'EdgeColor','None')

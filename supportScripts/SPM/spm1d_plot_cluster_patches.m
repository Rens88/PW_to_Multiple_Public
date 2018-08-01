function [h] = spm1d_plot_cluster_patches(y, thresh, two_tailed)

Q       = numel(y);
[x0,y0] = deal( 1:Q, y );



%find suprathreshold clusters
if two_tailed
    [L0,n0]  = spm1d_bwlabel(y >  thresh);
    [L1,n1]  = spm1d_bwlabel(y < -thresh);
    L1(L1>0) = L1(L1>0) + n0;
    L        = L0 + L1;
    n        = n0 + n1;
    csigns   = [ones(1,n0) -ones(1,n1)];
else
    [L,n]    = spm1d_bwlabel(y > thresh);
    csigns   = ones(1,n);
end


%plot suprathreshold cluster patches
if n==0
    h   = -1;
    return
end
h       = zeros(1,n);
for i = 1:n
    csign      = csigns(i);
    [x,y]      = deal(x0(L==i), y0(L==i));
    [x,y]      = deal([x(1) x], [csign*thresh y]);
    %interpolate if necessary:
    if x(1)   ~= 1
        dx     = 1;
        dy     = (csign*thresh - y0(x(1))) / (y0(x(1)) - y0(x(1)-1)  );
        x(1)   = x(1) + dy/dx;
    end
    if x(end) ~= Q
        dx     = 1;
        dy     = (csign*thresh - y0(x(end))) / (y0(x(end)+1) - y0(x(end))  );
        x      = [x   x(end)+dy/dx]; %#ok<AGROW>
        y      = [y  csign*thresh];  %#ok<AGROW>
    end
    [x,y]      = deal( [x x(end)], [y y(1)]);
    h(i)       = patch(x-1, y, 0.7*[1,1,1]);
end
set(h, 'FaceAlpha',0.5, 'EdgeColor','None')
function [h] = spm1d_plot_SPMi_label_threshold(SPMi, x, y)

if nargin==1
    [x,y]  = deal(50, 1.1*SPMi.zstar);
end

% s   = texlabel( sprintf('alpha=%.02f, t=%.3f', SPMi.alpha, SPMi.zstar)); 
s0  = texlabel( sprintf('alpha %s=%.02f', ' ', SPMi.alpha)); 
s1  = sprintf('t* = %.3f', SPMi.zstar);
h   = text(x, y, [s0 ',     ' s1], 'color','r');




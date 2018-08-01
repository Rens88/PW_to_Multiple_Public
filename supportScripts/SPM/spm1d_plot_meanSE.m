function [h0,h1] = spm1d_plot_meanSE(Y)

[y,ys]    = deal(mean(Y,1), std(Y,1)/sqrt(size(Y,1)));       
x         = 0:numel(y)-1;
h0        = plot(x, y, 'k-', 'linewidth', 2);
h1        = spm1d_plot_errorcloud(y, ys,NaN,0.1);

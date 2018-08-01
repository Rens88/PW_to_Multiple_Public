function [rCounts] = spm1d_reselCounts(R, W)

a             = any(abs(R)>0, 1);
nNodes        = sum(a);
[~,nClusters] = spm1d_bwlabel(a);
rCounts       = [nClusters (nNodes-nClusters)/W];




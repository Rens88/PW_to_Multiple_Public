function [SPM] = spm1d_stats_glm(Y, X, c)


% solve the GLM:
b            = pinv(X)*Y;                    %parameters
eij          = Y - X*b;                      %residuals
R            = eij'*eij;                     %residuals sum of squares
df           = size(Y,1) - rank(X);          %degrees of freedom
sigma2       = diag(R)/df;                   %variance
% compute t statistic
t            = (c'*b)'  ./  (sqrt(sigma2*(c'*(inv(X'*X))*c))  + eps);
% estimate smoothness and resel counts:
fwhm         = mean( spm1d_smoothness(eij) );
if isnan(fwhm)
    disp('consider changing <mean> to <nanmean>, because this might be the cause of your error')
end
resel_counts = spm1d_reselCounts(eij, fwhm);
% assemble SPM details:
SPM.STAT     = 'T';
SPM.df       = [1,df];
SPM.nNodes   = numel(t);
SPM.z        = t';
SPM.beta     = b;
SPM.R        = eij;
SPM.sigma2   = sigma2';
SPM.fwhm     = fwhm;
SPM.resels   = resel_counts;



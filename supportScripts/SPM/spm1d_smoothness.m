function [FWHM] = spm1d_smoothness(R)

nCurves = size(R,1);
ssR     = sqrt(  sum(R.^2, 1) );
R       = R ./ repmat(ssR, nCurves, 1);  %normalized
DY      = gradient(R);   %estimated gradient at each node
du      = sum(DY.^2, 1); %sum of squared gradient estimates
FWHM    = sqrt( 4*log(2) ./ du );   %FWHM at each node

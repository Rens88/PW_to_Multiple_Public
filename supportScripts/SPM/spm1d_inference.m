function [SPMi] = spm1d_inference(SPM, alpha, options)


if nargin==3
    two_tailed = options.two_tailed;
else
    two_tailed = 0;
end


%find critical threshold:
if two_tailed
    pstar = alpha/2;
else
    pstar = alpha;
end
zstar     = spm_uc(pstar, SPM.df, SPM.STAT, SPM.resels, 1, SPM.nNodes);


%compute cluster-level p values
p         = [];
if SPM.STAT == 'T'
    [L,n]        = spm1d_bwlabel(SPM.z>zstar);
    p            = zeros(1,n);
    for i=1:n
        extent   = sum(L==i) / SPM.fwhm;
        height   = min(SPM.z(L==i));
        p(i)     = spm_P_RF(1, extent, height, SPM.df, SPM.STAT, SPM.resels, 1);
    end
    if two_tailed
        [L,n]    = spm1d_bwlabel(SPM.z<-zstar);
        pn       = zeros(1,n);
        for i=1:n
            extent   = sum(L==i) / SPM.fwhm;
            height   = -max(SPM.z(L==i));
            pn(i)    = spm_P_RF(1, extent, height, SPM.df, SPM.STAT, SPM.resels, 1);
        end
        p       = [p pn];
    end
end


%assemble inference SPM
SPMi            = SPM;
SPMi.alpha      = alpha;
SPMi.two_tailed = two_tailed;
SPMi.zstar      = zstar;
SPMi.p          = p;

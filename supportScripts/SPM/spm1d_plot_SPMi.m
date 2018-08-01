function [varargout] = spm1d_plot_SPMi(SPMi)


Q       = SPMi.nNodes;
h0      = plot(0:Q-1, SPMi.z, 'k-', 'linewidth',2);  %SPM
hold on
h1      = plot([0 Q-1], [0 0], 'k--');               %datum
h2      = plot([0 Q-1], SPMi.zstar*[1 1], 'r:');     %threshold
if SPMi.two_tailed
    h2a =  plot([0 Q-1], -SPMi.zstar*[1 1], 'r:');   %lower threshold 
end

%fill suprathreshold clusters:
h3      = spm1d_plot_cluster_patches(SPMi.z, SPMi.zstar, SPMi.two_tailed);


if nargout==1
    if SPMi.two_tailed
        varargout = {[h0,h1,h2,h2a,h3]};
    else
        varargout = {[h0,h1,h2,h3]};
    end
end

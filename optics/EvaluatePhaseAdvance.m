function [phis]=EvaluatePhaseAdvance(TMs,beta0,alpha0,betas,alphas)
% EvaluatePhaseAdvance(TMs,beta0,alpha0,betas,alphas)
%      to reconstruct the phase advance expressed by transfer matrices TMs
%         when having a given set of input and output optics functions
% for ref, see eq. 5.76 pag 170, H. Wiedemann, Particle Accelerator Physics
%   3rd Ed.

    % one plane at a time!
    phis=NaN(size(TMs,3),1);
    smu=permute(TMs(1,2,:),[3 1 2])./sqrt(betas*beta0);
    cmu=permute(TMs(1,1,:),[3 1 2]).*sqrt(beta0./betas)-alpha0*smu;
    phis=mod(atan2(smu,cmu),2*pi); % [rads]
end

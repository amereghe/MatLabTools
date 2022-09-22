function [phis]=EvaluatePhaseAdvance(TMs,beta0,alpha0,betas,alphas)
    % one plane at a time
    phis=NaN(size(TMs,3),1);
    smu=permute(TMs(1,2,:),[3 1 2])./sqrt(betas*beta0);
    cmu=permute(TMs(1,1,:),[3 1 2]).*sqrt(beta0./betas)-alpha0*smu;
    phis=mod(atan2(smu,cmu),2*pi); % [rads]
end

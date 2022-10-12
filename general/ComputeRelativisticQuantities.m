function [beta,gamma,betagamma]=ComputeRelativisticQuantities(Ek,M)
    gamma=Ek./M+1;
    betagamma=sqrt(gamma.^2-1);
    beta=betagamma./gamma;
end

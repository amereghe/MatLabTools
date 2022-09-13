function [betaO,alphaO,gammaO]=TransportOptics(TMs,beta0,alpha0,gamma0)
    % single plane
    if ( ~exist("gamma0","var") ), gamma0=(1+alpha0.^2)./beta0; end
    nTMs=size(TMs,3);
    nSCs=length(beta0);
    betaO=NaN(nTMs,nSCs); alphaO=NaN(nTMs,nSCs); gammaO=NaN(nTMs,nSCs);
    C=BuildTransportMatrixForOptics(TMs);
    for ii=1:nTMs
        clear aa; aa=C(:,:,ii)*[ beta0 alpha0 gamma0 ]';
        betaO(ii,:)=aa(1,:);
        alphaO(ii,:)=aa(2,:);
        gammaO(ii,:)=aa(3,:);
    end
end

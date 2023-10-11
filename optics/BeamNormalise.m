function [NormCoords]=BeamNormalise(PhysCoords,alfa,beta,emiGeo)
% PhysCoords=float(nParticles,2,nPlanes);
    fprintf("Normalising beam...\n");
    
    %% set up
    nPlanes=size(PhysCoords,3);
    % defaults: alfa=0; beta=10 m; emiGeo=1E-6 m rad;
    if (~exist("alfa","var")), alfa=zeros(nPlanes,1); end
    if (~exist("beta","var")), beta=ones(nPlanes,1)*10; end
    if (~exist("emiGeo","var")), emiGeo=ones(nPlanes,1)*1E-6; end
    if (nPlanes~=length(alfa))
        error("Incosistent number of planes (%d) and alfa-optics functions (%d) (including NaNs)!",nPlanes,length(alfa));
    end
    if (nPlanes~=length(beta))
        error("Incosistent number of planes (%d) and beta-optics functions (%d) (including NaNs)!",nPlanes,length(beta));
    end
    if (nPlanes~=length(emiGeo))
        error("Incosistent number of planes (%d) and geometric emittances (%d) (including NaNs)!",nPlanes,length(emiGeo));
    end
    
    %% actually normalise coordinates
    NormCoords=missing();
    for iPlane=1:nPlanes
        NormCoords=ExpandMat(NormCoords,Phys2Norm(PhysCoords(:,:,iPlane),beta(iPlane),alfa(iPlane),emiGeo(iPlane)));
    end
    
    %% done
    fprintf("...done;\n");
end

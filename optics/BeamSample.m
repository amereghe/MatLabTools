function [beamParts]=BeamSample(dType,nParticles,alfa,beta,emiGeo,iNorm,bb,hh)
%
% beamParts=float(nParticles,2,nPlanes);
% particle coordinates expressed in physical units, i.e. [m] and [rad]!
% NB: iNorm,bb,hh only for bar-of-charge (optional arguments)
%
    fprintf("Generating beam of %d particles...\n",nParticles);
    
    %% set up
    % - general beam sampling
    nPlanes=length(dType);
    if (nPlanes~=length(alfa))
        error("Incosistent number of types (%d) and alfa-optics functions (%d) (including NaNs)!",nPlanes,length(alfa));
    end
    if (nPlanes~=length(beta))
        error("Incosistent number of types (%d) and beta-optics functions (%d) (including NaNs)!",nPlanes,length(beta));
    end
    if (nPlanes~=length(emiGeo))
        error("Incosistent number of types (%d) and geometric emittances (%d) (including NaNs)!",nPlanes,length(emiGeo));
    end
    % - specific to BAR-of-charge
    nBars=sum(strcmpi(dType,"BAR"));
    if (~exist("iNorm","var")), iNorm=false(nBars,1); end
    if (~exist("bb","var")), bb=NaN(nBars,1); end
    if (~exist("hh","var")), hh=NaN(nBars,1); end
    if (nBars~=length(iNorm))
        error("Incosistent number of BARs (%d) and specs for norm/phys units (%d)!",nBars,length(iNorm));
    end
    if (nBars~=length(bb))
        error("Incosistent number of BARs (%d) and bar-of-charge base values (%d)!",nBars,length(bb));
    end
    if (nBars~=length(hh))
        error("Incosistent number of BARs (%d) and bar-of-charge height values (%d)!",nBars,length(hh));
    end
    
    %% actually sample
    beamParts=missing(); iBar=0;
    for iPlane=1:nPlanes
        switch upper(dType(iPlane))
            case {"B","BAR","BAR-OF-CHARGE"}
                iBar=iBar+1;
                beamParts=ExpandMat(beamParts,BeamSampleRect(nParticles,bb(iBar),hh(iBar)));
                if (iNorm(iBar))
                    beamParts(:,:,iPlane)=Norm2Phys(beamParts(:,:,iPlane),beta(iPlane),alfa(iPlane),emiGeo(iPlane));
                end
            case {"D","DELTA","P","POINT"}
                beamParts=ExpandMat(beamParts,zeros(nParticles,2));
            case {"G","GAUSS","GAUSSIAN"}
                beamParts=ExpandMat(beamParts,BeamSampleGauss(nParticles,alfa(iPlane),beta(iPlane),emiGeo(iPlane)));
            otherwise
                error("Unknown distribution type %s!",dType(iPlane));
        end
    end
    
    %% done
    fprintf("...done;\n");
end

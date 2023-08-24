function [beamParts]=BeamSample(dType,nParticles,alfa,beta,emiGeo,CO,iNorm,bb,hh)
%
% beamParts=float(nParticles,2*nPlanes);
% particle coordinates expressed in physical units, i.e. [m] and [rad]!
% CO added only if provided
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
    if (~exist("CO","var") | all(ismissing(CO)))
        CO=zeros(2*nPlanes,1);
    else
        if (length(CO)~=2*nPlanes)
            error("Incosistent number of dimensions (%d) and CO specifications (%d)!",2*nPlanes,length(CO));
        end
        % avoid NaNs
        CO(ismissing(CO))=0.0;
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
    beamParts=NaN(nParticles,2*nPlanes); iBar=0;
    for iPlane=1:nPlanes
        switch upper(dType(iPlane))
            case {"B","BAR","BAR-OF-CHARGE"}
                iBar=iBar+1;
                beamParts(:,(1:2)+2*(iPlane-1))=BeamSampleRect(nParticles,bb(iBar),hh(iBar));
                if (iNorm(iBar))
                    beamParts(:,(1:2)+2*(iPlane-1))=Norm2Phys(beamParts(:,(1:2)+2*(iPlane-1)),beta(iPlane),alfa(iPlane),emiGeo(iPlane));
                end
            case {"D","DELTA","P","POINT"}
                beamParts(:,(1:2)+2*(iPlane-1))=zeros(nParticles,2);
            case {"G","GAUSS","GAUSSIAN"}
                beamParts(:,(1:2)+2*(iPlane-1))=BeamSampleGauss(nParticles,alfa(iPlane),beta(iPlane),emiGeo(iPlane));
            otherwise
                error("Unknown distribution type %s!",dType(iPlane));
        end
    end
    
    %% add closed orbit
    if (any(CO~=0.0))
        fprintf("...adding closed orbit...;\n");
        beamParts=beamParts+CO;
    end
    
    %% done
    fprintf("...done;\n");
end

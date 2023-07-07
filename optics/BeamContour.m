function [Contours]=BeamContour(dType,alfa,beta,emiGeo,iNorm,bb,hh)
%
% Contours=float(nPoints,2,nPlanes);
% NB: iNorm,bb,hh only for bar-of-charge (optional arguments)
%
    fprintf("Contouring beam...\n");

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
    
    %% actually contour
    Contours=missing();
    for iPlane=1:nPlanes
        switch upper(dType(iPlane))
            case {"B","BAR","BAR-OF-CHARGE"}
                Contours=ExpandMat(Contours,GenPointsAlongRectangle(bb(iBar),hh(iBar)));
                if (iNorm(iBar))
                    Contours(:,:,iPlane)=Norm2Phys(Contours(:,:,iPlane),beta(iPlane),alfa(iPlane),emiGeo(iPlane));
                end
            case {"D","DELTA","P","POINT"}
                Contours=ExpandMat(Contours,zeros(1,2));
            case {"G","GAUSS","GAUSSIAN"}
                Contours=ExpandMat(Contours,GenPointsAlongEllypse(alfa(iPlane),beta(iPlane),emiGeo(iPlane)));
            otherwise
                error("Unknown distribution type %s!",dType(iPlane));
        end
    end
    
    %% done
    fprintf("...done;\n");
end

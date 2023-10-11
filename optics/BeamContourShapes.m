function [Contours]=BeamContourShapes(dType,alfa,beta,emiGeo,CO,iNorm,bb,hh)
% BeamContourShapes     defines points along defined shapes, for contouring
%                           beam samples;
%
% Contours=float(nPoints,2,nPlanes);
% CO added only if provided
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
    
    %% actually contour
    Contours=missing(); iBar=0;
    for iPlane=1:nPlanes
        switch upper(dType(iPlane))
            case {"B","BAR","BAR-OF-CHARGE"}
                iBar=iBar+1;
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
    
    %% add closed orbit
    if (any(CO~=0.0))
        fprintf("...adding closed orbit...;\n");
        for iPlane=1:nPlanes
            Contours(:,:,iPlane)=Contours(:,:,iPlane)+CO((1:2)+2*(iPlane-1));
        end
    end
    
    %% done
    fprintf("...done;\n");
end

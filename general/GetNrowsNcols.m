function [nRows,nCols,lDispHor]=GetNrowsNcols(nPlots,nCoupled)
% getNrowsNcols           get a suitable arrangement of plots
    if (~exist("nCoupled","var")), nCoupled=1; end
    lDispHor=true; 
    nSquared=ceil(sqrt(nPlots));
    nCols=nSquared;
    if (nPlots<=nSquared*(nSquared-1))
        nRows=nSquared-1;
    else
        nRows=nSquared;
    end
    % re-arrange columns and rows to have one of the two a multiple of the
    %    number of coupled plots
    if (nCoupled>1)
        modNrows=mod(nRows,nCoupled);
        modNcols=mod(nCols,nCoupled);
        if (modNrows==0)
            % coupled plots are displayed vertically
            lDispHor=false;
        elseif (modNcols==0)
            % coupled plots are displayed horizontally
            lDispHor=true;
        else
            if (modNrows<modNcols)
                % coupled plots are displayed vertically
                nRows=round(nRows/nCoupled);
                nCols=ceil(nPlots/nRows);
                lDispHor=false;
            else
                % coupled plots are displayed horizontally
                nCols=round(nCols/nCoupled);
                nRows=ceil(nPlots/nCols);
                lDispHor=true;
            end
        end
    end
end

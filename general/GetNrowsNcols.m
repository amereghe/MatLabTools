function [nRows,nCols]=GetNrowsNcols(nPlots)
% getNrowsNcols           get a suitable arrangement of plots
    nSquared=ceil(sqrt(nPlots));
    nCols=nSquared;
    if (nPlots<=nSquared*(nSquared-1))
        nRows=nSquared-1;
    else
        nRows=nSquared;
    end
end
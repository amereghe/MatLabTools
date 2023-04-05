function [nCounts,nCountsX,nCountsY,xb,yb]=Get2dHistograms(currDataX,currDataY,xb,yb,hist1DUsr)
    if ( ~exist("xb","var") | ismissing(xb) ), xb=linspace(min(currDataX),max(currDataX),101); end
    if ( ~exist("yb","var") | ismissing(yb) ), yb=linspace(min(currDataY),max(currDataY),101); end
    if ( ~exist("hist1DUsr","var") ), hist1DUsr=true; end
    nCounts=histcounts2(currDataX,currDataY,xb,yb);
    if ( hist1DUsr )
        nCountsX=histcounts(currDataX,xb);
        nCountsY=histcounts(currDataY,yb);
    else
        nCountsX=missing(); nCountsY=missing(); 
    end
end

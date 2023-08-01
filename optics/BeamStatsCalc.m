function [Counts2D,CountsX,CountsY,xb,yb]=BeamStatsCalc(particles,what2Analise,declared,xbQuery,ybQuery)
% particles=float(nParticles,2*nPlanes);

    fprintf("Beam statistics...\n");
    
    %% set up
    if (~exist("declared","var") | all(ismissing(declared)) ), declared=["X" "PX" "Y" "PY" "T" "PT"]; end
    nAnal=size(what2Analise,1);
    % by default, bins of histograms are set based on data
    if (~exist("xbQuery","var") | all(ismissing(xbQuery)) ), xbQuery=NaN; end
    if (~exist("ybQuery","var") | all(ismissing(ybQuery)) ), ybQuery=NaN; end
    
    %% actually analyse
    Counts2D=missing();
    CountsX=missing(); CountsY=missing();
    xb=missing(); yb=missing();
    for iAnal=1:nAnal
        iColX=strcmpi(declared,what2Analise(iAnal,1));
        if (all(~iColX)), error("...unable to identify coordinate %s!",what2Analise(iAnal,1)); end
        iColY=strcmpi(declared,what2Analise(iAnal,2));
        if (all(~iColY)), error("...unable to identify coordinate %s!",what2Analise(iAnal,2)); end
        if (size(xbQuery,2)==1), xbb=xbQuery; else xbb=xbQuery(:,iAnal); end
        if (size(ybQuery,2)==1), ybb=ybQuery; else ybb=ybQuery(:,iAnal); end
        [tmpCounts2D,tmpCountsX,tmpCountsY,tmpXb,tmpYb]=Get2dHistograms(particles(:,iColX),particles(:,iColY),xbb,ybb);
        % store counts
        Counts2D=ExpandMat(Counts2D,tmpCounts2D);
        CountsX=ExpandMat(CountsX,tmpCountsX');
        CountsY=ExpandMat(CountsY,tmpCountsY');
        xb=ExpandMat(xb,tmpXb);
        yb=ExpandMat(yb,tmpYb);
    end
    
    %% done
    fprintf("...done;\n");
end

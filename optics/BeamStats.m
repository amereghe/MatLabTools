function [Counts2D,CountsX,CountsY,xb,yb]=BeamStats(particles,what2Analise,declared)
% particles=float(nParticles,2,nPlanes);
    fprintf("Beam statistics...\n");
    
    %% set up
    if (~exist("declared","var")), declared=["X" "PX" "Y" "PY" "T" "PT"]; end
    if (ndims(particles)==3)
        myParts=reshape(particles,[size(particles,1) size(particles,2)*size(particles,3)]);
    else
        myParts=particles;
    end
    nAnal=size(what2Analise,1);
    
    %% actually analyse
    Counts2D=missing();
    CountsX=missing(); CountsY=missing();
    xb=missing(); yb=missing();
    for iAnal=1:nAnal
        iColX=strcmpi(declared,what2Analise(iAnal,1));
        if (all(~iColX)), error("...unable to identify coordinate %s!",what2Analise(iAnal,1)); end
        iColY=strcmpi(declared,what2Analise(iAnal,2));
        if (all(~iColY)), error("...unable to identify coordinate %s!",what2Analise(iAnal,2)); end
        [tmpCounts2D,tmpCountsX,tmpCountsY,tmpXb,tmpYb]=Get2dHistograms(myParts(:,iColX),myParts(:,iColY));
        % store counts
        Counts2D=ExpandMat(Counts2D,tmpCounts2D);
        CountsX=ExpandMat(CountsX,tmpCountsX');
        CountsY=ExpandMat(CountsY,tmpCountsY');
        xb=ExpandMat(xb,tmpXb');
        yb=ExpandMat(yb,tmpYb');
    end
    
    %% done
    fprintf("...done;\n");
end

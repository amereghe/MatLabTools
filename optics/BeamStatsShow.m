function BeamStatsShow(Counts2D,CountsX,CountsY,xb,yb,what2Analise,lHist,myTitle,contours,contourLabels,units,declared)
% 
% Counts2D is either a 2D histogram or a float(nParticles,2*nPlanes) array
% 
    fprintf("Showing beam statistics...\n");
    
    %% set up
    if (~exist("lHist","var")), lHist=true; end
    if (~exist("myTitle","var")), myTitle=missing(); end
    if (~exist("contours","var")), contours=missing(); end
    if (~exist("contourLabels","var")), contourLabels=missing(); end
    if (~exist("units","var")), units=missing(); end
    if (~exist("declared","var")), declared=missing(); end
    
    if (ismissing(units)), units=["m" "" "m" "" "m" ""]; end
    if (ismissing(declared)), declared=["X" "PX" "Y" "PY" "T" "PT"]; end
    
    nAnal=size(what2Analise,1);

    %% actually plot
    lSquared=false;
    lBinEdges=true;
    myConts=missing();
    for iAnal=1:nAnal
        iColX=strcmpi(declared,what2Analise(iAnal,1));
        if (all(~iColX)), error("...unable to identify coordinate %s!",what2Analise(iAnal,1)); end
        iColY=strcmpi(declared,what2Analise(iAnal,2));
        if (all(~iColY)), error("...unable to identify coordinate %s!",what2Analise(iAnal,2)); end
        fullTitle=sprintf("%s vs %s",what2Analise(iAnal,2),what2Analise(iAnal,1));
        if (~ismissing(myTitle)), fullTitle=strcat(myTitle," - ",fullTitle); end
        if (~all(ismissing(contours),"all")), myConts=contours(:,:,:,iAnal); end 
        figure("Name",fullTitle);
        xLab=sprintf("%s [%s]",what2Analise(iAnal,1),units(iColX));
        yLab=sprintf("%s [%s]",what2Analise(iAnal,2),units(iColY));
        if (lHist)
            % 2D histogram and 1D histograms
            [axM,axX,axY]=Plot2DHistograms(Counts2D(:,:,iAnal),CountsX(:,iAnal),CountsY(:,iAnal),xb(:,iAnal),yb(:,iAnal),xLab,yLab,myConts,lHist,lSquared,lBinEdges);
        else
            % scatter plot and 1D histograms
            [axM,axX,axY]=Plot2DHistograms(Counts2D(:,[find(iColX) find(iColY)]),CountsX(:,iAnal),CountsY(:,iAnal),xb(:,iAnal),yb(:,iAnal),xLab,yLab,myConts,lHist,lSquared,lBinEdges);
        end
        if (~ismissing(contourLabels))
            legend(axM,["Beam" contourLabels],"Location","best");
        end
        sgtitle(fullTitle);
    end

    %% done
    fprintf("...done;\n");
end

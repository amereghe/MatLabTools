function [Counts2D,CountsX,CountsY,xb,yb]=BeamStats(particles,what2Analise,declared,xbQuery,ybQuery,contours,contourLabels,myTitle)
% 
% particles=float(nParticles,2*nPlanes);
% particle coordinates expressed in physical units, i.e. [m] and [rad]!
% 
    %% interface vars
    if (~exist("what2Analise","var") | all(ismissing(what2Analise)) ), what2Analise=["X" "PX" ; "Y" "PY" ]; end
    if (~exist("declared","var") | all(ismissing(declared)) ), declared=["X" "PX" "Y" "PY" "T" "PT"]; end
    if (~exist("xbQuery","var") | all(ismissing(xbQuery)) ), xbQuery=NaN(1,round(size(particles,2))/2); end % histogram bins set based on data
    if (~exist("ybQuery","var") | all(ismissing(ybQuery)) ), ybQuery=NaN(1,round(size(particles,2))/2); end % histogram bins set based on data
    if (~exist("contours","var") | ismissing(contours)), contours=missing(); end
    if (~exist("contourLabels","var") | ismissing(contourLabels)), contourLabels=missing(); end
    if (~exist("myTitle","var") | ismissing(myTitle)), myTitle=missing(); end
    
    %% contours
    contours=ExpandMat(contours,BeamContourStats(particles,false,declared)); % stat ellypses, RMS
    contours=ExpandMat(contours,BeamContourStats(particles,true,declared));  % stat ellypses, max single-particle emittance
    contours=permute(contours,[1 2 4 3]);
    contourLabels=ExpandMat(contourLabels,["RMS" "Max(\epsilon)"],true); % expand array of labels without increasing number of dimensions

    %% actual statistics
    [Counts2D,CountsX,CountsY,xb,yb]=BeamStatsCalc(particles,what2Analise,declared,xbQuery,ybQuery);
    
    %% plot
    if (~ismissing(myTitle))
        %      2D histogram
        lHist=true;  BeamStatsShow(Counts2D,CountsX,CountsY,xb,yb,what2Analise,lHist,myTitle,contours,contourLabels,missing(),declared);
        %      scatter plot
        lHist=false; BeamStatsShow(particles,CountsX,CountsY,xb,yb,what2Analise,lHist,myTitle,contours,contourLabels,missing(),declared);
    end
    
end

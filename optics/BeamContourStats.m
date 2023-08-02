function [Contours]=BeamContourStats(particles,emiMax,declared,what2Analise)
% BeamContourStats     defines points along ellypse fitting the beam sample in input
%                      if emiMax is true, the max single-particle emittance
%                           is calculated and used instead of  the RMS one;
%
% particles=float(nParticles,2*nPlanes);
%
    if (~exist("what2Analise","var") | all(ismissing(what2Analise)) ), what2Analise=["X" "PX" ; "Y" "PY" ]; end
    if (~exist("declared","var") | all(ismissing(declared)) ), declared=["X" "PX" "Y" "PY" "T" "PT"]; end
    fprintf("Finding fit ellypse on beam...\n");

    %% set up
    nPlanes=size(what2Analise,2);
    if (~exist("emiMax","var")), emiMax=false; end
    if (emiMax)
        fprintf("...based on largest single-particle geometric emittance!\n");
    else
        fprintf("...based on RMS single-particle geometric emittance!\n");
    end
    
    %% actually contour
    Contours=missing();
    for iPlane=1:nPlanes
        iColX=find(strcmpi(declared,what2Analise(iPlane,1)));
        if (isempty(iColX)), error("...unable to identify coordinate %s!",what2Analise(iPlane,1)); end
        iColY=find(strcmpi(declared,what2Analise(iPlane,2)));
        if (isempty(iColY)), error("...unable to identify coordinate %s!",what2Analise(iPlane,2)); end
        if ( any(contains(["X" "Y"],what2Analise(iPlane,1),"IgnoreCase",true)) && any(contains(what2Analise(iPlane,2),"P","IgnoreCase",true)) && ...
             (all(contains(what2Analise(iPlane,:),"X","IgnoreCase",true)) || all(contains(what2Analise(iPlane,:),"Y","IgnoreCase",true))) )
            % be sure that we are dealing with hor/ver phase space
            [alpha,beta,emiG]=GetOpticsFromSigmaMatrix(particles(:,[iColX iColY])); % ellypse orientation and RMS emittance
            if (emiMax), emiG=max(GetSinglePartEmittance(particles(:,[iColX iColY]),alpha,beta));  end % max single-part emittance
            Contours=ExpandMat(Contours,GenPointsAlongEllypse(alpha,beta,emiG));
        else
            warning("Cannot find an optics ellypse on plane (%s,%s);",what2Analise(iPlane,1),what2Analise(iPlane,2));
        end
    end
    
    %% done
    fprintf("...done;\n");
end

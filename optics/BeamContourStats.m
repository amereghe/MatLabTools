function [Contours]=BeamContourStats(particles,emiMax)
% particles=float(nParticles,2,nPlanes);
    fprintf("Finding fit ellypse on beam...\n");

    %% set up
    nPlanes=size(particles,3);
    if (~exist("emiMax","var")), emiMax=false; end
    if (emiMax)
        fprintf("...based on largest single-particle geometric emittance!\n");
    else
        fprintf("...based on RMS single-particle geometric emittance!\n");
    end
    
    %% actually contour
    Contours=missing();
    for iPlane=1:nPlanes
        [alpha,beta,emiG]=GetOpticsFromSigmaMatrix(particles(:,:,iPlane));   % ellypse orientation
        if (emiMax)
            emiG=max(GetSinglePartEmittance(particles(:,:,iPlane),alpha,beta));  % max 
        end
        Contours=ExpandMat(Contours,GenPointsAlongEllypse(alpha,beta,emiG));
    end
    
    %% done
    fprintf("...done;\n");
end

function X=SolveOrbSystem(B,BARs)
% SolveOrbSystemDisp       perform a linear fit (e.g. of quad scans) to get
%                            initial values of closed orbit and beam
%                            statistics data.
%
% - input:
%   . B: 2D transport matrix (2x2xNconfigs or 3x3xNconfigs) on a single
%        plane. The third dimension is used to separate different powering
%        configurations of the same piece of beam line;
%        Depending on the length of B, dispersion terms are taken into
%        account or not:
%        - size(B,1)==2: usual betatron scan, with:
%          X(1)=x (s=0)
%          X(2)=xp(s=0)
%        - size(B,1)==3: combined betatron and dispersion scan, with:
%          X(1)=x (s=0)+D (s=0)*ave_dpp
%          X(2)=xp(0s=)+Dp(s=0)*ave_dpp
%          X(3)=ave_dpp
%   . BARs: row vector of measured beam baricentres (nData,1) [mm];
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, DecodeOrbitFit,
%       FitOpticsThroughOrbitData, FitOpticsThroughSigmaData and SolveSigSystem
% 
    opts.RECT=true;
    BARsM=BARs*1E-3; % from [mm] to [m]
    if ( size(B,3)~=length(BARsM) )
        error("Size of transport matrix (%d) and measurements (%d) do not agree!", ...
            size(B,3), length(BARsM) );
    end
    indices=(~ismissing(BARsM) & ~isnan(BARsM));
    nValidPoints=sum(indices);
    if ( nValidPoints==0 )
        warning("no valid baricentre data to fit!");
        if ( size(B,1)==2 && size(B,2)==2 )
            X=NaN(3,1);
        elseif ( size(B,1)==3 && size(B,2)==3 )    
            X=NaN(6,1);
        else
            error("B can only be 2x2xNconfigs or 3x3xNconfigs");
        end
        return
    end
    if ( size(B,1)==2 && size(B,2)==2 )
        A=zeros(nValidPoints,2);
        A(:,1)=B(1,1,indices);
        A(:,2)=B(1,2,indices);
        X=linsolve(A,BARsM(indices),opts);
    elseif ( size(B,1)==3 && size(B,2)==3 )
        A=zeros(nValidPoints,3);
        A(:,1)=B(1,1,indices);
        A(:,2)=B(1,2,indices);
        A(:,3)=B(1,3,indices);
        X=linsolve(A,BARsM(indices),opts);
    else
        error("B can only be 2x2xNconfigs or 3x3xNconfigs");
    end
end

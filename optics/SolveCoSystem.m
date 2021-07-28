function X=SolveCoSystem(B,BARs)
% SolveCoSystemDisp       perform a linear fit (e.g. of quad scans) to get
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
%       FitOpticsThroughSigmaData and SolveSigSystem
% 
    opts.RECT=true;
    BARsM=BARs*1E-3; % from [mm] to [m]
    if ( size(B,3)~=length(BARsM) )
        error("Size of transport matrix (%d) and measurements (%d) do not agree!", ...
            size(B,3), length(BARsM) );
    end
    if ( size(B,1)==2 && size(B,2)==2 )
        A=zeros(length(BARsM),2);
        A(:,1)=B(1,1,:);
        A(:,2)=B(1,2,:);
        X=linsolve(A,BARsM,opts);
    elseif ( size(B,1)==3 && size(B,2)==3 )
        A=zeros(length(BARsM),3);
        A(:,1)=B(1,1,:);
        A(:,2)=B(1,2,:);
        A(:,3)=B(1,3,:);
        X=linsolve(A,BARsM,opts);
    else
        error("B can only be 2x2xNconfigs or 3x3xNconfigs");
    end
end

function [z0,zp0,ave_dpp]=DecodeOrbitFit(X,D0,Dp0)
% DecodeOrbitFit      converts the value of fitting parameters (e.g. from quad scans)
%                       into starting values of beam position and statistics data.
%
% - input:
%   X(1)=x (0)+D (0)*ave_dpp
%   X(2)=xp(0)+Dp(0)*ave_dpp
%   X(3)=ave_dpp
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, FitOpticsThroughOrbitData,
%       FitOpticsThroughSigmaData, SolveOrbSystem and SolveSigSystem
% 
    ave_dpp =X(3);
    z0 =X(1)-D0 *ave_dpp;
    zp0=X(2)-Dp0*ave_dpp;
    % clean away NaNs
    z0 (isnan(z0 ))=X(1);
    zp0(isnan(zp0))=X(2);
end

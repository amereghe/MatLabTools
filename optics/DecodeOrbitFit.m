function [z0,zp0]=DecodeOrbitFit(X,D0,Dp0)
% DecodeOrbitFit      converts the value of fitting parameters (e.g. from quad scans)
%                       into starting values of beam position and statistics data.
%
% - input:
%   X(1)=x (0)+D (0)*ave_dpp
%   X(2)=xp(0)+Dp(0)*ave_dpp
%   X(3)=ave_dpp
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, SolveCoSystem and SolveSigSystem
% 
    z0 =X(1)-D0 *X(3);
    zp0=X(2)-Dp0*X(3);
end

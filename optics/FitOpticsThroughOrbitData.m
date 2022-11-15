function [z,zp,avedpp]=FitOpticsThroughOrbitData(CC,bars,d,dp)
% FitOpticsThroughOrbitData      find optics functions and beam stat data
%                                that fit some orbit values (baricentre of
%                                beam distribution)
%
% - input:
%   . CC: 2D transport matrix (2x2xNconfigs or 3x3xNconfigs) on a single
%         plane. The third dimension is used to separate different powering
%         configurations of the same piece of beam line;
%         Depending on the length of CC, dispersion terms are taken into
%         account or not:
%   . bars: row vector of measured baricentres (nData,1) [mm];
%   . d,dp (optional): value of dispersion and dispersion prime used to
%         separate the dispersion and the betatron contribution. These 
%         variables are NOT optional in case of CC is 3x3xNconfig. They can
%         be scalars or arrays.
% - output:
%   . z,zp,avedpp: position [m] and angle [], together with average beam
%         off-momentum [] that best fit the measurements;
%   If d/dp are not passed or they are a scalar, a single value for the fitted
%         functions is returned; otherwise, the returned values are arrays.
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, DecodeOrbitFit,
%    FitOpticsThroughSigmaData, SolveOrbSystem and SolveSigSystem
% 

    if ( size(CC,1)==2 && size(CC,2)==2 )
        ZZ=SolveOrbSystem(CC,bars);
        z=ZZ(1);
        zp=ZZ(2);
        avedpp=0;
    elseif ( size(CC,1)==3 && size(CC,2)==3 )
        if ( exist('d','var') && exist('dp','var') )
            if ( length(d)~=length(dp) )
                % this condition is not really necessary, but it is good to
                %   have it.
                error("specified D (%d) and DP (%d) have different dimensions!",length(d),length(dp));
            end
            % pre-allocate, to optimise CPU time
            ZZ=SolveOrbSystem(CC,bars);
            [z,zp,avedpp]=DecodeOrbitFit(ZZ,d,dp);
            z=z'; zp=zp';
        else
            error("cannot separate betatron orbit from dispersion contribution without D or DP.");
        end
    else
        error("Wrong dimension of transport matrix: %dx%d - must be 2x2 or 3x3",size(CC,1),size(CC,2));
    end
end

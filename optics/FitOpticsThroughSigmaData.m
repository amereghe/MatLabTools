function [bet,alf,emiG,d,dp,sigdppO]=FitOpticsThroughSigmaData(CC,sigs,sigdppI)
% FitOpticsThroughSigmaData      find optics functions and beam stat data
%                                that fit some sigma values
%
% - input:
%   . CC: 2D transport matrix (2x2xNconfigs or 3x3xNconfigs) on a single
%         plane. The third dimension is used to separate different powering
%         configurations of the same piece of beam line;
%         Depending on the length of CC, dispersion terms are taken into
%         account or not:
%   . sigs: row vector of measured sigma values (nData,1) [mm];
%   . sigdppI (optional): value of sigma_delta_p_over_p to be used in the
%         fit through data. It can be a scalar or an array of values.
% - output:
%   . bet,alf,emiG: beta [m] and alpha [] functions, together with
%         geometric emittance [pi m rad] that best fit the measurements;
%   . d,dp,sigdppO: dispersion [m] and dispersion prime [] functions, together
%         with sigma_delta_p_over_p [] that best fit the measurements;
%   If sigdppI is not passed or is a scalar, a single value for the fitted
%         functions is returned; otherwise, the returned values are arrays.
%
% more info at:
%      https://accelconf.web.cern.ch/d99/papers/PT10.pdf
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, DecodeOrbitFit,
%    FitOpticsThroughOrbitData, SolveOrbSystem and SolveSigSystem
% 

    if ( size(CC,1)==2 && size(CC,2)==2 )
        Sx=SolveSigSystem(CC,sigs);
        [bet,alf,emiG,d,dp,sigdppO]=DecodeOpticsFit(Sx);
    elseif ( size(CC,1)==3 && size(CC,2)==3 )
        if ( exist('sigdppI','var') )
            if ( length(sigdppI)==1 ) % only one value of sigdpp: no need to loop
                Sx=SolveSigSystem(CC,sigs,sigdppI);
                [bet,alf,emiG,d,dp,sigdppO]=DecodeOpticsFit(Sx);
            else
                % pre-allocate, to optimise CPU time
                nFits=length(sigdppI);
                bet=zeros(1,nFits); alf=zeros(1,nFits); emiG=zeros(1,nFits);
                d=zeros(1,nFits); dp=zeros(1,nFits); sigdppO=zeros(1,nFits);
                % do the actual scan
                for ii=1:nFits
                    Sx=SolveSigSystem(CC,sigs,sigdppI(ii));
                    [bet(ii),alf(ii),emiG(ii),d(ii),dp(ii),sigdppO(ii)]=DecodeOpticsFit(Sx);
                end
            end
        else
            Sx=SolveSigSystem(CC,sigs);
            [bet,alf,emiG,d,dp,sigdppO]=DecodeOpticsFit(Sx);
        end
    else
        error("Wrong dimension of transport matrix: %dx%d - must be 2x2 or 3x3",size(CC,1),size(CC,2));
    end
end

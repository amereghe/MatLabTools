function X=SolveSigSystem(B,sigs,sig_dpp)
% SolveSigSystem      perform a linear fit (e.g. of quad scans) to get
%                       initial values of optics functions and beam
%                       statistics data.
%
% - input:
%   . B: 2D transport matrix (2x2xNconfigs or 3x3xNconfigs) on a single
%        plane. The third dimension is used to separate different powering
%        configurations of the same piece of beam line;
%        Depending on the length of B, dispersion terms are taken into
%        account or not:
%        - size(B,1)==2: usual betatron scan, with:
%          X(1) = sigma(1,1)(s=0)
%          X(2) = sigma(1,2)(s=0)
%          X(3) = sigma(2,2)(s=0)
%        - size(B,1)==3: combined betatron and dispersion scan, with:
%          X(1) = sigma(1,1)(s=0) +D(s=0)^2 *sig_dpp^2
%          X(2) = sigma(1,2)(s=0) +D(0)Dp(s=0) *sig_dpp^2
%          X(3) = sigma(2,2)(s=0) +Dp(s=0)^2 *sig_dpp^2
%          X(4) = D(s=0) *sig_dpp^2
%          X(5) = Dp(s=0)*sig_dpp^2
%          X(6) = sig_dpp^2
%   . sigs: row vector of measured sigma values (nData,1) [mm];
%   . sig_dpp (optional): value of sigma_delta_p_over_p to be used in the
%     fit through data.
%
% more info at:
%      https://accelconf.web.cern.ch/d99/papers/PT10.pdf
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, DecodeOrbitFit,
%      FitOpticsThroughSigmaData and SolveCoSystem
% 
    opts.RECT=true;
    sigs2=(sigs*1E-3).^2; % from [mm] to [m], and then sigma matrix!
    if ( size(B,1)==2 && size(B,2)==2 )
        A=zeros(length(sigs2),3);
        C=BuildTransportMatrixForOptics(B);
        A(:,1)=C(1,1,:);
        A(:,2)=-C(1,2,:);
        A(:,3)=C(1,3,:);
        X=linsolve(A,sigs2,opts);
    elseif ( size(B,1)==3 && size(B,2)==3 )
        if ( exist('sig_dpp','var') )
            if ( sig_dpp == 0.0 )
                % sig_dpp is set to null by user: perform a 3-params fit
                A=zeros(length(sigs2),3);
            else
                % sig_dpp is given by user: perform a 5-params fit
                A=zeros(length(sigs2),5);
            end
        else
            A=zeros(length(sigs2),6);
        end
        A(:,1)=B(1,1,:).^2;
        A(:,2)=2*B(1,1,:).*B(1,2,:);
        A(:,3)=B(1,2,:).^2;
        if ( exist('sig_dpp','var') )
            if ( sig_dpp ~= 0.0 )
                A(:,4)=2*B(1,1,:).*B(1,3,:);
                A(:,5)=2*B(1,2,:).*B(1,3,:);
            end
            X=linsolve(A,sigs2-reshape(B(1,3,:).^2*sig_dpp^2,length(sigs2),1),opts);
            X(6)=sig_dpp^2;
        else
            A(:,4)=2*B(1,1,:).*B(1,3,:);
            A(:,5)=2*B(1,2,:).*B(1,3,:);
            A(:,6)=B(1,3,:).^2;
            X=linsolve(A,sigs2,opts);
        end
    else
        error("B can only be 2x2xNconfigs or 3x3xNconfigs");
    end
end

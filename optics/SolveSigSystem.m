function X=SolveSigSystem(B,sigs,sig_dpp,initConds,lDebug)
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
%   . initConds (optional): initial guess values for X;
%
% more info at:
%      https://accelconf.web.cern.ch/d99/papers/PT10.pdf
%
% see also BuildTransportMatrixForOptics, DecodeOpticsFit, DecodeOrbitFit,
%      FitOpticsThroughOrbitData, FitOpticsThroughSigmaData and SolveOrbSystem
% 
    if ( ~exist("lDebug","var") ), lDebug=true; end
    if ( ~exist("initConds","var") ), initConds=missing(); end
    sigs2=(sigs*1E-3).^2; % from [mm] to [m], and then sigma matrix!
    if ( size(B,3)~=length(sigs2) )
        error("Size of transport matrix (%d) and measurements (%d) do not agree!", ...
            size(B,3), length(sigs2) );
    end
    indices=(~ismissing(sigs2) & sigs2>0.0);
    nValidPoints=sum(indices);
    if ( nValidPoints==0 )
        warning("no valid sigma data to fit!");
        if ( size(B,1)==2 && size(B,2)==2 )
            X=NaN(3,1);
        elseif ( size(B,1)==3 && size(B,2)==3 )    
            X=NaN(6,1);
        else
            error("B can only be 2x2xNconfigs or 3x3xNconfigs");
        end
        return
    end
    % min fit info
    A=NaN(nValidPoints,3);
    C=BuildTransportMatrixForOptics(B);
    A(:,1)=C(1,1,indices);
    A(:,2)=-C(1,2,indices); % ref: eqs. 5.47/5.48, Wiedemann, pag. 165, ed 2007
    A(:,3)=C(1,3,indices);
    if ( size(B,1)==2 && size(B,2)==2 )
        X=SolveSigSystemActual(A,sigs2(indices),initConds,lDebug);
    elseif ( size(B,1)==3 && size(B,2)==3 )
        if ( exist('sig_dpp','var') )
            if ( ismissing(sig_dpp) || sig_dpp==0.0 )
                % the system is solved as a pure betatronic one
                X=SolveSigSystemActual(A,sigs2(indices),initConds,lDebug);
            else
                % sig_dpp is given by user: perform a 5-params fit;
                A(:,4)=2*B(1,1,indices).*B(1,3,indices);
                A(:,5)=2*B(1,2,indices).*B(1,3,indices);
                X=SolveSigSystemActual(A,sigs2(indices)-reshape(B(1,3,indices).^2*sig_dpp^2,nValidPoints,1),initConds,lDebug);
                X(6)=sig_dpp^2;
            end
        else
            % sig_dpp is derived from fitting
            A(:,4)=2*B(1,1,indices).*B(1,3,indices);
            A(:,5)=2*B(1,2,indices).*B(1,3,indices);
            A(:,6)=B(1,3,indices).^2;
            X=SolveSigSystemActual(A,sigs2(indices),initConds,lDebug);
        end
    else
        error("B can only be 2x2xNconfigs or 3x3xNconfigs");
    end
end

function X=SolveSigSystemActual(A,sigs2,initConds,lDebug)
    if ( ismissing(initConds) )
        if ( lDebug )
            fprintf("==> new SIG fit %gD, %g points\n",size(A,2),size(A,1));
        end
        % solves the linear equation AX = B and minimizes the value of norm(A*X-B).
        % If several solutions exist to this problem, then lsqminnorm returns the 
        %   solution that minimizes norm(X)
        X=lsqminnorm(A,sigs2); % let MatLab raise the warning
        if ( lDebug )
            fprintf("==> done.\n");
        end
    else
        % lb=[0 -inf 0]; ub=[inf inf inf]; XC = lsqlin(A,sigs2,[],[],[],[],lb,ub);
        X = lsqlin(A,sigs2,[],[],[],[],[],[],initConds);
    end
end


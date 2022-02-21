function [BARs,FWxMs,INTs,FWxMls,FWxMrs]=StatDistributions(profiles,FWxMval,noiseLevelFWxM,INTlevel,myMask,lDebug)
% StatDistributions                  to compute basic statistical infos of
%                                       distributions (acquired by both DDS and CAMeretta);
% The algorithm is based on the one for CAMeretta, but it is centred around
%   the FWxM, i.e. BAR and INT refer to the (possibly) symmetric profile
%   used to identify the FWxM;
% 
% input:
% - profiles (2D float array): signals to process:
%   . rows: index of independent coordinate (e.g. time/position);
%   . columns: index of the signal to process;
%   NB: column 1 is the list of values of the independent variable;
% - FWxMval (array): values (ratios to max) at which the FW should be computed
%     (either as percentage or as ratio to 1); default (scalar): 50% (FWHM);
% - noiseLevelFWxM (scalar): cut threshold for computing FWxM
%     (either as percentage or as ratio to 1); default: 20%;
% - INTlevel (scalar): min value of integral above which a profile should be
%     considered for analisis; default: 20k;
% - lDebug (boolean): activate debug mode (for the time being, plots);
%
% output:
% - BARs (2D float array): max of smoothed distribution;
% - FWxMs (3D float array): FWxMs of smoothed distribution;
% - INTs (2D float array): integrals of measured distributions (symmetric bell);
% NB: dimensions of the output arrays have the following meaning:
%   . row: index of data set;
%   . columns: plane (1:HOR; 2:VER);
%   . 3rd: level at which the FW is evaluated;
%

    % default values (as for CAMeretta procedure
    asymThresh=0.10; % thresholds for identifying asymmetric profiles (in y, the
                     %    tail on one side is longer than that on the other
                     %    side by this amount of the max)
    ordPolyn=6;      % max polynomial order for FWxM determination
    excessPoints=1;  % use more points than ordPolyn, to avoid MatLab warnings
    nPointsMin=ordPolyn+excessPoints;
    if ( ~exist('FWxMval','var') ), FWxMval=missing(); end
    if ( ~exist('noiseLevelFWxM','var') ), noiseLevelFWxM=missing(); end
    if ( ~exist('INTlevel','var') ), INTlevel=missing(); end
    if ( ~exist('lDebug','var') ), lDebug=missing(); end
    if ( ~exist('myMask','var') ), myMask=missing(); end
    %
    if ( ismissing(FWxMval) ), FWxMval=0.50; end
    if ( ismissing(noiseLevelFWxM) ), noiseLevelFWxM=0.18; end
    if ( ismissing(INTlevel) ), INTlevel=20000; end
    if ( ismissing(lDebug) ), lDebug=true; end
    
    fprintf("computing INTs, BARs and FWxMs...\n");
    % if >1, levels are assumed in percentage
    if ( noiseLevelFWxM>1 ), noiseLevelFWxM=noiseLevelFWxM*1.0E-2; end
    if ( FWxMval>1 ), FWxMval=FWxMval*1.0E-2; end
    if ( FWxMval<noiseLevelFWxM ), FWxMval=noiseLevelFWxM; end
    
    % initialise vars
    nLevels=length(FWxMval);         % how many levels
    nDataSets=size(profiles,2)-1;    % let's crunch only sum profiles;
    BARs=NaN(nDataSets,2);           % hor,ver BARs
    FWxMs=NaN(nDataSets,2,nLevels);  % hor,ver FWxMs
    FWxMls=NaN(nDataSets,2,nLevels); % hor,ver FWxMs
    FWxMrs=NaN(nDataSets,2,nLevels); % hor,ver FWxMs
    INTs=NaN(nDataSets,2);           % hor,ver INTs
    
    % loop over profiles
    planes=[ "hor" "ver" ];
    if ( lDebug ), ff=figure(); end
    for iSet=1:nDataSets
        tmpXs(:,1:2)=profiles(:,1,:);      % (nFibers,2)
        tmpYs(:,1:2)=profiles(:,1+iSet,:); % (nFibers,2)
        tmpINTs=sum(tmpYs);
        if ( sum(tmpINTs)==0 ), continue; end
        if ( lDebug ), sgtitle(sprintf("profiles id #%d",iSet)); end
        % FWxMs
        for iPlane=1:2
            if ( lDebug ), subplot(1,2,iPlane); end
            % default values, in case fitting does not proceed
            tmpIndices=tmpYs(:,iPlane)>0;
            FWxMls(iSet,iPlane,:)=min(tmpXs(tmpIndices,iPlane))*ones(1,length(FWxMval));  % array
            FWxMrs(iSet,iPlane,:)=max(tmpXs(tmpIndices,iPlane))*ones(1,length(FWxMval)); % array
            FWxMs(iSet,iPlane,:)=NaN(1,length(FWxMval));
            myXs=tmpXs(tmpIndices,iPlane); myYs=0.0*myXs; repXs=0.0*myXs; repYs=0.0*myXs;
            [tmpMax,idMax]=max(tmpYs(tmpIndices,iPlane));
            FWxMvalAbs=FWxMval*tmpMax;                                       % array
            % do the actual job
            if ( ismissing(myMask) )
                XsPreFilter=tmpXs(:,iPlane);
                YsPreFilter=tmpYs(:,iPlane);
            else
                XsPreFilter=tmpXs(myMask(:,iPlane),iPlane);
                YsPreFilter=tmpYs(myMask(:,iPlane),iPlane);
            end
            indices=CleanProfiles(YsPreFilter,noiseLevelFWxM);
            nPoints=sum(indices);
            if ( tmpINTs(iPlane)<INTlevel)
                warning("...cannot actually identify a bell-shaped profile on plane %s for data set %d! skipping...",planes(iPlane),iSet);
            elseif ( nPoints<2+excessPoints ) % at least a second order polynomial fitting
                warning("...not enough points for fitting data for computing FWxM on %s plane for data set %d! skipping...",planes(iPlane),iSet);
            else
                nOrder=ordPolyn; % max order of polynom
                if ( nPoints<nPointsMin ), nOrder=nPoints-excessPoints; end % reduce polynom order if there are not enough points...
                % [myXs,myYs]=GetSymmetricBell(XsPreFilter(indices),YsPreFilter(indices),asymThresh,nPointsMin,lDebug);
                myXs=XsPreFilter(indices); myYs=YsPreFilter(indices);
                pp=polyfit(myXs,myYs,nOrder);
                newIndices=CleanProfiles(tmpYs(:,iPlane),noiseLevelFWxM);
                % [repXs,repYs]=GetSymmetricBell(tmpXs(newIndices,iPlane),tmpYs(newIndices,iPlane),asymThresh,nPointsMin,lDebug);
                repXs=tmpXs(newIndices,iPlane); repYs=tmpYs(newIndices,iPlane);
                repYs=polyval(pp,repXs);
                [tmpMax,idMax]=max(repYs);
                FWxMvalAbs=FWxMval*tmpMax;                                   % array
                if ( idMax==1 | idMax==length(repYs) )
                    warning("...not enough points for finding width on one of the two sides of profile on %s plane for data set %d! skipping...",planes(iPlane),iSet);
                else
                    tmpFWxMleftPos=interp1(repYs(1:idMax),repXs(1:idMax),FWxMvalAbs);      % array
                    tmpFWxMrightPos=interp1(repYs(idMax:end),repXs(idMax:end),FWxMvalAbs); % array
                    FWxMs(iSet,iPlane,:)=tmpFWxMrightPos-tmpFWxMleftPos;                   % array
                    % return total useful counts as INT
                    INTs(iSet,iPlane)=sum(myYs);
                    % return (refined) position of peak as BAR
                    refXs=repXs(idMax-1):((repXs(idMax+1)-repXs(idMax-1))/200):repXs(idMax+1);
                    refYs=polyval(pp,refXs);
                    [refMax,idRefMax]=max(refYs);
                    BARs(iSet,iPlane)=refXs(idRefMax);
                    FWxMls(iSet,iPlane,:)=BARs(iSet,iPlane)-tmpFWxMleftPos;   % array
                    FWxMrs(iSet,iPlane,:)=tmpFWxMrightPos-BARs(iSet,iPlane);  % array
                end
            end
            if ( lDebug )
                plot(tmpXs(:,iPlane),tmpYs(:,iPlane),"o", ...                       % original signal
                     myXs,myYs,"*",repXs,repYs,".-", ...                            % filtered signal and interpolated signal
                     [tmpFWxMleftPos ; tmpFWxMrightPos],[FWxMvalAbs ; FWxMvalAbs],"k-",...      % FWxM
                     [BARs(iSet,iPlane) BARs(iSet,iPlane)], [0.0 1.1*tmpMax],"k-"); % BAR
                title(sprintf("%s plane",planes(iPlane))); grid on; xlabel("fiber position [mm]"); ylabel("counts []");
            end
        end
        if ( lDebug ), pause(); end
    end
    fprintf("...done.\n");
end

function [myXs,myYs]=GetSymmetricBell(tmpXs,tmpYs,asymThresh,nPointsMin,lDebug)
    if ( ~exist('asymThresh','var') ), asymThresh=0.10; end
    if ( ~exist('nPointsMin','var') ), nPointsMin=9; end
    if ( ~exist('lDebug','var') ), lDebug=false; end
    [tmpMax,idMax]=max(tmpYs);
    [tmpLMin,idLMin]=min(tmpYs(1:idMax));
    [tmpRMin,idRMin]=min(tmpYs(idMax:end));
    
    if ( abs(tmpLMin-tmpRMin)>abs(tmpMax)*asymThresh & length(tmpXs)>nPointsMin )
        % potentially asymmetric profile
        warning("...getSymmetricBell: symmetrysing!");
        if ( abs(tmpLMin)>abs(tmpRMin) )
            myCut=abs(tmpLMin)/tmpMax;
        else
            myCut=abs(tmpRMin)/tmpMax;
        end
        indices=CleanProfiles(tmpYs,myCut);
        myXs=tmpXs(indices);
        myYs=tmpYs(indices);
    else
        myXs=tmpXs;
        myYs=tmpYs;
    end
end

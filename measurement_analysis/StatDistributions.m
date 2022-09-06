function [BARs,FWxMs,INTs,FWxMls,FWxMrs]=StatDistributions(profiles,FWxMval,noiseLevelFWxM,INTlevel,myMask,lDebug,dTitle)
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
% - FWxMval (1D array,optional): values (ratios to max) at which the FW should be computed
%     (either as percentage or as ratio to 1); default (scalar): 50% (FWHM);
% - noiseLevelFWxM (scalar,optional): cut threshold for computing FWxM
%     (either as percentage or as ratio to 1); default: 20%;
% - INTlevel (scalar,optional): min value of integral above which a profile should be
%     considered for analisis; default: 20k;
% - lDebug (boolean,optional): activate debug mode (for the time being, plots);
% - dTitle (string,optional): title to be displayed in debug plots;
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
    maxOrdPolyn=8;   % polynomial order for FWxM determination
    BareMinOrdPolyn=4;   % polynomial order for FWxM determination
    excessPoints=1;  % use more points than ordPolyn, to avoid MatLab warnings
    nPointsMin=maxOrdPolyn+excessPoints;
    nPointsBareMin=BareMinOrdPolyn+excessPoints;
    if ( ~exist('FWxMval','var') ), FWxMval=missing(); end
    if ( ~exist('noiseLevelFWxM','var') ), noiseLevelFWxM=missing(); end
    if ( ~exist('INTlevel','var') ), INTlevel=missing(); end
    if ( ~exist('lDebug','var') ), lDebug=missing(); end
    if ( ~exist('myMask','var') ), myMask=missing(); end
    if ( ~exist('dTitle','var') ), dTitle=missing(); end
    %
    if ( ismissing(FWxMval) ), FWxMval=0.50; end
    if ( ismissing(noiseLevelFWxM) ), noiseLevelFWxM=0.20; end
    if ( ismissing(INTlevel) ), INTlevel=20000; end
    if ( ismissing(lDebug) ), lDebug=true; end
    if ( ismissing(dTitle) ), dTitle=""; end
    
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
        tmpINTs=sum(tmpYs,"omitnan");
        if ( sum(tmpINTs,"omitnan")==0 ), continue; end
        % FWxMs
        for iPlane=1:2
            if ( lDebug ), subplot(1,2,iPlane); end
            % default values, in case fitting does not proceed
            tmpIndices=tmpYs(:,iPlane)>0;
            FWxMls(iSet,iPlane,:)=min(tmpXs(tmpIndices,iPlane))*ones(1,length(FWxMval)); % array
            FWxMrs(iSet,iPlane,:)=max(tmpXs(tmpIndices,iPlane))*ones(1,length(FWxMval)); % array
            FWxMs(iSet,iPlane,:)=NaN(1,length(FWxMval));
            myXs=tmpXs(tmpIndices,iPlane); myYs=0.0*myXs; repXs=0.0*myXs; repYs=0.0*myXs;
            [tmpMax,idMax]=max(tmpYs(tmpIndices,iPlane));
            FWxMvalAbs=FWxMval*tmpMax;                                       % array
            tmpFWxMleftPos=NaN(size(FWxMvalAbs)); tmpFWxMrightPos=NaN(size(FWxMvalAbs));
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
            nOrder=NaN();
            if ( tmpINTs(iPlane)<INTlevel)
                warning("...too low intensity in profile on plane %s for data set %d! skipping...",planes(iPlane),iSet);
            else
                nOrder=floor(nPoints/2);
                if ( nOrder>=maxOrdPolyn )
                    nOrder=maxOrdPolyn; % max order of polynom
                else
                    if ( nPoints>nPointsBareMin )
                        % extend range of data to be fitted, in order to
                        %   use a polynom at maxOrdPolyn order
                        nOrder=maxOrdPolyn;
                        if ( mod(nPoints,2)==0 )
                            [myMax,myID]=max(YsPreFilter(indices));
                            if ( myID>=nPoints/2 || myID==nPoints )
                                lL=false;
                            else
                                lL=true;
                            end
                            indices=ExtendRange(indices,YsPreFilter,lL);
                            nPoints=sum(indices);
                        end
                        % try to extend range of points, adding the neighbours
                        nPointsOld=nPoints-1;
                        while ( nPoints<nPointsMin && nPoints>nPointsOld )
                            nPointsOld=nPoints;
                            indices=ExtendRange(indices,YsPreFilter);
                            % - re-check polynomial order
                            nPoints=sum(indices);
                        end % reduce polynom order if there are not enough points...
                    else
                        % extend range of data to be fitted, in order to
                        %   use a polynom at BareMinOrdPolyn order
                        nOrder=BareMinOrdPolyn;
                        if ( mod(nPoints,2)==0 )
                            [myMin,myID]=min(YsPreFilter(indices));
                            if ( myID==1 )
                                lL=false;
                            else
                                lL=true;
                            end
                            indices=ExtendRange(indices,YsPreFilter,lL);
                            nPoints=sum(indices);
                        end
                        % try to extend range of points, adding the neighbours
                        nPointsOld=nPoints-1;
                        while ( nPoints<nPointsBareMin && nPoints>nPointsOld )
                            nPointsOld=nPoints;
                            indices=ExtendRange(indices,YsPreFilter);
                            % - re-check polynomial order
                            nPoints=sum(indices);
                        end % reduce polynom order if there are not enough points...
                    end
                end
                if ( nPoints<nPointsBareMin )
                    warning("...not enough points for fitting data for computing FWxM on %s plane for data set %d! skipping...",planes(iPlane),iSet);
                end
                % [myXs,myYs]=GetSymmetricBell(XsPreFilter(indices),YsPreFilter(indices),asymThresh,nPointsMin,lDebug);
                myXs=XsPreFilter(indices); myYs=YsPreFilter(indices);
                pp=polyfit(myXs,myYs,nOrder);
                newIndices=CleanProfiles(tmpYs(:,iPlane),noiseLevelFWxM);
                % [repXs,repYs]=GetSymmetricBell(tmpXs(newIndices,iPlane),tmpYs(newIndices,iPlane),asymThresh,nPointsMin,lDebug);
                % - evaluate smooth curve on a much finer x-grid
                newIndices=ExtendRange(newIndices,tmpYs(:,iPlane));
                tmpMax=max(tmpXs(newIndices,iPlane));
                tmpMin=min(tmpXs(newIndices,iPlane));
                tmpDelta=min(diff(tmpXs(newIndices,iPlane)));
                nSteps=ceil((tmpMax-tmpMin)/tmpDelta);
                repXs=linspace(tmpMin,tmpMax,nSteps*10);
                repYs=polyval(pp,repXs);
                [tmpMax,idMax]=max(repYs);
                while ( ( idMax==1 && repXs(idMax)>min(tmpXs(~isnan(tmpXs(:,iPlane)),iPlane)) ) || ...
                        ( idMax==length(repYs) && repXs(idMax)<max(tmpXs(~isnan(tmpXs(:,iPlane)),iPlane)) ) )
                    if ( idMax==1 )
                        repXs=repXs(2:end);
                        repYs=repYs(2:end);
                        [tmpMax,idMax]=max(repYs);
                    else
                        repXs=repXs(1:end-1);
                        repYs=repYs(1:end-1);
                        [tmpMax,idMax]=max(repYs);
                    end
                end
                FWxMvalAbs=FWxMval*tmpMax;                                   % array
                if ( idMax==1 | idMax==length(repYs) )
                    warning("...not enough points for finding width on one of the two sides of profile on %s plane for data set %d! skipping...",planes(iPlane),iSet);
                else 
                    myLowerCut=idMax-find(diff(repYs(idMax:-1:1))>0,1)+1; % consider interpolated data down to first min on the left
                    if ( isempty(myLowerCut) ), myLowerCut=1; end
                    tmpFWxMleftPos=interp1(repYs(myLowerCut:idMax),repXs(myLowerCut:idMax),FWxMvalAbs);      % array
                    myUpperCut=idMax+find(diff(repYs(idMax:end))>0,1)-1; % consider interpolated data down to first min on the right
                    if ( isempty(myUpperCut) ), myUpperCut=length(repYs); end
                    tmpFWxMrightPos=interp1(repYs(idMax:myUpperCut),repXs(idMax:myUpperCut),FWxMvalAbs); % array
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
                     [BARs(iSet,iPlane) BARs(iSet,iPlane)], [0.0 1.1*tmpMax],"k-",... % BAR
                     myXs,ones(size(myXs))*noiseLevelFWxM*max(tmpYs(:,iPlane)),"r-"); % noise level
                grid on; xlabel("fiber position [mm]"); ylabel("counts []");
                if ( nPoints<15 && ~isnan(BARs(iSet,iPlane)) ), xlim([min(repXs)-5 max(repXs)+5]); end
                yl=ylim; ylim([0 yl(2)]);
                if ( strlength(dTitle)>0 )
                    title(sprintf("%s plane - fit order: %d - # points: %d - %s",planes(iPlane)),nOrder,nPoints,dTitle);
                else
                    title(sprintf("%s plane - fit order: %d - # points: %d",planes(iPlane),nOrder,nPoints));
                end
            end
        end
        if ( lDebug )
            sgtitle(sprintf("profiles id #%d",iSet));
            pause(0.25);
        end
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

function newIndices=ExtendRange(indices,Ys,lL)
    if ( ~exist("lL","var") )
        lL=true;
        lR=true;
    else
        lR=~lL;
    end
    newIndices=indices;
    % - left side:
    if ( lL )
        iMin=find(newIndices,1);
        if ( iMin>1 && ~isnan(Ys(iMin-1)) )
            newIndices(iMin-1)=true;
        end
    end
    % - right side:
    if ( lR )
        iMax=find(newIndices,1,"last");
        if ( iMax<length(newIndices) && ~isnan(Ys(iMax+1)) )
            newIndices(iMax+1)=true;
        end
    end
end

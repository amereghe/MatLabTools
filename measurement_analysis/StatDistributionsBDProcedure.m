function [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles,noiseLevel,INTlevel,lDebug)
% StatDistributionsCAMProcedure      to compute basic statistical infos of
%                                       distributions recorded by monitors
%                                       other than CAMeretta;
% 
% input:
% - profiles (2D float array): signals to process:
%   . rows: index of independent coordinate (e.g. time/position);
%   . columns: index of the signal to process;
%   NB: column 1 is the list of values of the independent variable;
% - noiseLevel (scalar): cut threshold for computing statistics;
%     default: 200 counts;
% - INTlevel (scalar): min value of integral above which a profile should be
%     considered for analisis; default: 20k;
% - lDebug (boolean): activate debug mode (for the time being, plots);
%
% output:
% - BARs (2D float array): BARicenters of distributions;
% - FWHMs (2D float array): FWxMs of distributions;
% - INTs (2D float array): integrals of distributions (no filters!);
% NB: rows/columns of the the output arrays have the following meaning:
%   . row: index of data set;
%   . columns: plane (1:HOR; 2:VER);
%
    % default values
    if ( ~exist('noiseLevel','var') ), noiseLevel=200; end
    if ( ~exist('INTlevel','var') ), INTlevel=20000; end
    if ( ~exist('lDebug','var') ), lDebug=false; end
    
    fprintf("computing BARs and FWHMs as in procedure...\n");
    nDataSets=size(profiles,2)-1; % let's crunch only sum profiles;
    BARs=NaN(nDataSets,2);  % hor,ver BARs
    FWHMs=NaN(nDataSets,2); % hor,ver FWHMs
    INTs=NaN(nDataSets,2); % hor,ver INTs
    
    % loop over profiles
    planes=[ "hor" "ver" ];
    if ( lDebug ), ff=figure(); end
    for iSet=1:nDataSets
        tmpXs(:,1:2)=profiles(:,1,:);      % (nFibers,2)
        tmpYs(:,1:2)=profiles(:,1+iSet,:); % (nFibers,2)
        INTs(iSet,1:2)=sum(tmpYs,"omitnan");
        if ( sum(INTs(iSet,:),"omitnan")== 0 ), continue; end
        if ( lDebug )
            sgtitle(sprintf("DDS profiles id #%d",iSet));
            oriYs=tmpYs(:,1:2);
        end
        tmpYs(tmpYs<noiseLevel)=0.0;
        for iPlane=1:2
            if ( lDebug ), subplot(1,2,iPlane); end
            norm=sum(tmpYs(:,iPlane),"omitnan");
            if ( norm>INTlevel )
                BARs(iSet,iPlane)=sum(tmpXs(:,iPlane).*tmpYs(:,iPlane),"omitnan")/norm;
                FWHMs(iSet,iPlane)=sqrt(sum(((tmpXs(:,iPlane)-BARs(iSet,iPlane)).^2).*tmpYs(:,iPlane),"omitnan")/norm)*2*sqrt(2*log(2)); % from st dev to FWHM
            end
            if ( lDebug )
                tmpIndices=tmpYs(:,iPlane)>0;
                if ( sum(tmpIndices)==0 )
                    tmpMax=0.0; FWHMvalAbs=0.5*tmpMax;
                    FWHMleft=min(tmpXs(:,iPlane));
                    FWHMright=max(tmpXs(:,iPlane));
                else
                    posYs=tmpYs(tmpIndices,iPlane);
                    posXs=tmpXs(tmpIndices,iPlane);
                    [tmpMax,idMax]=max(posYs);
                    FWHMvalAbs=0.5*tmpMax;
                    FWHMleft=interp1(posYs(1:idMax),posXs(1:idMax),FWHMvalAbs);
                    FWHMright=interp1(posYs(idMax:end),posXs(idMax:end),FWHMvalAbs);
                    FWHMave=0.5*(FWHMleft+FWHMright);
                    FWHMleft=FWHMave-0.5*FWHMs(iSet,iPlane);
                    FWHMright=FWHMave+0.5*FWHMs(iSet,iPlane);
                end
                plot(tmpXs(:,iPlane),oriYs(:,iPlane),"o", ...                       % original signal
                     tmpXs(:,iPlane),tmpYs(:,iPlane),".-", ...                      % filtered signal
                     [FWHMleft FWHMright],[FWHMvalAbs FWHMvalAbs],"k-",...          % FWxM
                     [BARs(iSet,iPlane) BARs(iSet,iPlane)], [0.0 1.1*tmpMax],"k-"); % BAR
                title(sprintf("%s plane",planes(iPlane))); grid on; xlabel("fiber position [mm]"); ylabel("counts []");
            end
        end
        if ( lDebug ), pause(0.1); end
    end
    fprintf("...done.\n");
end

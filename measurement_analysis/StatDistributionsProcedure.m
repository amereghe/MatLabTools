function [BARs,FWHMs,INTs]=StatDistributionsProcedure(data)
    fprintf("computing BARs and FWHMs as in procedure...\n");
    nDataSets=size(data,2)-1; % let's crunch only sum profiles;
    BARs=zeros(nDataSets,2);  % hor,ver BARs
    FWHMs=zeros(nDataSets,2); % hor,ver FWHMs
    INTs=zeros(nDataSets,2); % hor,ver INTs
    for iSet=1:nDataSets
        tmpXs(:,1:2)=data(:,1,:);      % (nFibers,2)
        tmpYs(:,1:2)=data(:,1+iSet,:); % (nFibers,2)
        INTs(iSet,1:2)=sum(tmpYs);
        tmpYs(tmpYs<200)=0.0;
        for ii=1:2
            norm=sum(tmpYs(:,ii));
            if ( norm>0 )
                BARs(iSet,ii)=sum(tmpXs(:,ii).*tmpYs(:,ii))/norm;
                FWHMs(iSet,ii)=sqrt(sum(((tmpXs(:,ii)-BARs(iSet,ii)).^2).*tmpYs(:,ii))/norm);
            end
        end
    end
    FWHMs=FWHMs*2*sqrt(2*log(2)); % from st dev to FWHM
    fprintf("...done.\n");
end
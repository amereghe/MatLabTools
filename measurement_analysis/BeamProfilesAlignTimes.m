function timesOUT=BeamProfilesAlignTimes(timesIN)
% BeamProfilesAlignTimes      to align time arrays of beam frames acquired
%                               with BD devices and CAMeretta dump
% all time arrays will have the same length, i.e. no NaNs left;
%
% timesIN & timesOUT: float(nMaxTime,nDataSets)
%
    fprintf("Aligning times...\n");
    timesOUT=timesIN;
    nDataSets=size(timesIN,2)-1;
    iLongest=find(~isnan(timesIN(end,:)),1,"first");
    for ii=1:nDataSets
        if (ii==iLongest), continue; end
        timesOUT(:,ii)=timesIN(:,iLongest);
    end
    fprintf("...done.\n");
end

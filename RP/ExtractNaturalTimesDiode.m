function [tStarts,tEnds,nAves]=ExtractNaturalTimesDiode(tStamps,counts)
    % natural times of DIODE logging, i.e. between counts==1;
    fprintf("getting natural times...\n");
    % find start of acquisitions
    iStart=find(counts==1);
    if ( iStart(1)>1 ), iStart=[1 iStart']; end
    nAves=length(iStart);
    tStarts(1:nAves)=tStamps(iStart);
    % find end of acquisitions
    iEnd=[iStart(2:end)'-1 length(tStamps)];
    ll=length(iEnd);
    if ( ll~=nAves ), error("cannot properly identify times of start/end counting."); end
    tEnds(1:nAves)=tStamps(iEnd);
    fprintf("...done;\n");
end

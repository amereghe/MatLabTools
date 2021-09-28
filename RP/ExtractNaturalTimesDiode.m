function [tStarts,tEnds,nAves]=ExtractNaturalTimesDiode(tStamps,counts)
% ExtractNaturalTimesDiode    search for "natural acquisition times", i.e.
%                             times where most probably the acquisition was
%                             stopped and re-started. The function crunches
%                             log files by REM counters (diodes).
% A single data-set is parsed.
%
% natural times of DIODE logging, i.e. between counts==1;
%
% input:
% - tStamps (array of datetime): time stamps of events;
% - counts (array of floats): counts;
% output:
% - tStarts (array of datetime): time stamps of guessed start of acquisitions;
% - tEnds (array of datetime): time stamps of guessed end of acquisitions;
% - nAves (scalar, float): time stamps of events;
%
% See also ExtractNaturalTimesPolyMaster and ExtractNaturalTimesStationary

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

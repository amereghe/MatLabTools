function [tStarts,tEnds,nAves]=ExtractNaturalTimesPolyMaster(tStamps,counts)
% ExtractNaturalTimesPolyMaster    search for "natural acquisition times", i.e.
%                                  times where most probably the acquisition was
%                                  stopped and re-started. The function crunches
%                                  log files by PolyMaster monitors (gamma dose).
% A single data-set is parsed.
%
% natural times of PolyMaster Monitor logging, i.e. between first and last consecutive count>0;
%
% input:
% - tStamps (array of datetime): time stamps of events;
% - counts (array of floats): counts;
% output:
% - tStarts (array of datetime): time stamps of guessed start of acquisitions;
% - tEnds (array of datetime): time stamps of guessed end of acquisitions;
% - nAves (scalar, float): time stamps of events;
%
% See also ExtractNaturalTimesDiode and ExtractNaturalTimesStationary

    fprintf("getting natural times...\n");
    
    % find proper counts
    tCounts=[ 0 ; counts ; 0];
    indices=find(tCounts<=0 | 1000<=tCounts);
    
    % get consecutive counts
    diffs=diff(indices);
    iIntervals=find(diffs>1);
    
    % get all intervals with consecutive non-zero counts
    nAves=length(iIntervals);
    tStarts=tStamps(indices(iIntervals));
    tEnds=tStamps(indices(iIntervals+1)-2);

    fprintf("...done;\n");
end

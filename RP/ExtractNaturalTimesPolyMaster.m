function [tStarts,tEnds,nAves]=ExtractNaturalTimesPolyMaster(tStamps,counts)
    % natural times of PolyMaster Monitor logging, i.e. between first and last consecutive count>0;
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

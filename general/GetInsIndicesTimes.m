function [indCopy,iStart,iStop]=GetInsIndicesTimes(tStampsNew,tStampsExisting)
% GetInsIndicesTimes         get insertion indices for a new time series
%                                for insertion into an existing one
%
% input:
% - tStampsNew (array of datetime): new series of timestamps;
% - tStampsExisting (array of datetime): existing series of timestamps;
% output:
% - indCopy (array of indices): indices in the new array where the existing
%   data should be copied;
% - iStart,iStop (integers): starting and final indices in the new array
%   where the new series should be inserted;
%
    indBef=find(tStampsExisting<=tStampsNew(1));
    indAft=find(tStampsNew(end)<=tStampsExisting);
    nExisting=length(tStampsExisting);
    nInsert=length(tStampsNew);
    if ( length(indBef)==nExisting && length(indAft)==0 )
        % current data set should be appended
        indCopy=indBef;
        iStart=nExisting+1;
        iStop=nExisting+nInsert;
    elseif ( length(indBef)==0 && length(indAft)==nExisting )
        % current data set should be headed
        indCopy=indAft+nInsert;
        iStart=1;
        iStop=nInsert;
    else
        % current data set should be inserted
        if ( indAft(1)-indBef(end)>1 )
            error("...cannot insert acquired data set in time range already taken by other data");
        end
        indCopy=[ indBef ; indAft+nInsert ];
        iStart=indBef(end)+1;
        iStop=indBef(end)+nInsert;
    end
end

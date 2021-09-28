function [tStampsOUT,countsOUT,ids]=SortByTime(tStampsIN,countsIN,nData)
% sortByTime         sort data by time stamps.
%
% input:
% - tStampsIN (matrix of datetime): timestamps of events. A row for each event;
% - countsIN (matrix of floats): counts. A row for each event;
% - nData (array of floats, optional): number of data in each monitor series.
% output:
% - tStampsOUT (matrix of datetime): sorted timestamps of events. A row for each event;
% - countsOUT (matrix of floats): sorted counts. A row for each event;
% - ids (matrix of floats): mapping of reshuffling.
%
% In case more than a monitor/data set is given, all matrices have data in
% columns, where a column is a specific array.
% nData is an optional value, allowing to use sub-ranges of input matrices.

    fprintf("sorting data by time stamp...\n");
    tStampsOUT=tStampsIN;
    countsOUT=countsIN;
    nMonitors=size(tStampsIN,2);
    ids=-ones(size(tStampsIN));
    if ( ~exist('nData','var') )
        nData=size(tStampsIN,1)*ones(size(tStampsIN,2),1);
    end
    for iMonitor=1:nMonitors
        [~,ids(:,iMonitor)]=sort(tStampsIN(1:nData(iMonitor),iMonitor));
        tStampsOUT(1:nData(iMonitor),iMonitor)=tStampsIN(ids(:,iMonitor),iMonitor);
        countsOUT(1:nData(iMonitor),iMonitor)=countsIN(ids(:,iMonitor),iMonitor);
    end
    fprintf("...done;\n");
end

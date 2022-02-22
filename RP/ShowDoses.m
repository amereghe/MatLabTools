function ShowDoses(tStamps,doses,means,maxs,mins)
% ShowDoses         creating a figure showing doses vs time
% 
% input:
% - tStamps (matrix of datetime): timestamps of events. A row for each event.
% - doses (matrix of floats): dose values. A row for each data point.
% - means (matrix of floats, optional): mean dose values. A row for each data point.
% - maxs (matrix of floats, optional): max dose values. A row for each data point.
% - mins (matrix of floats, optional): min dose values. A row for each data point.
%
% In case of more than a monitor, all input arrays are actually matrices;
%   a column is a specific monitor.
%
% Mean, min and max are shown only if given.
% 
    fprintf("plotting doses...\n");
    nMonitors=size(tStamps,2);
    [nRows,nCols]=GetNrowsNcols(nMonitors);
    
    figure();
    iCol=1; iRow=1;
    for iMonitor=1:nMonitors
        % raw data
        subplot(nRows,nCols,iMonitor);
        Xs=datenum(tStamps(:,iMonitor));
        tmpLeg="data";
        plot(Xs,doses(:,iMonitor),".");
        if ( exist('means','var') )
            hold on; plot(Xs,means(:,iMonitor),"b-");
            tmpLeg=[tmpLeg "mean"];
        end
        if ( exist('mins','var') )
            hold on; plot(Xs,mins(:,iMonitor),"r-");
            tmpLeg=[tmpLeg "min"];
        end
        if ( exist('maxs','var') )
            hold on; plot(Xs,maxs(:,iMonitor),"r-");
            tmpLeg=[tmpLeg "max"];
        end
        xlabel("time"); grid(); ylabel("dose [\muSv]"); title("raw data");
        legend(tmpLeg);
        datetick('x','dd-mm HH:MM:ss');
        
        % get ready for new data set
        iCol=iCol+1;
        if ( iCol>nCols ), iCol=1; iRow=iRow+1; end
    end
    fprintf("...done;\n");
end

function ShowStationaryDoses(tStamps,doses,means,maxs,mins)
    fprintf("plotting doses...\n");
    nMonitors=size(tStamps,2);
    [nRows,nCols]=GetNrowsNcols(nMonitors);
    
    figure();
    iCol=1; iRow=1;
    for iMonitor=1:nMonitors
        % raw data
        subplot(nRows,nCols,iMonitor);
        Xs=datenum(tStamps(:,iMonitor));
        plot(Xs,doses(:,iMonitor),".",...
             Xs,means(:,iMonitor),"b-",...
             Xs,mins(:,iMonitor),"r-",...
             Xs,maxs(:,iMonitor),"r-" );
        xlabel("time"); grid(); ylabel("dose [\muSv]"); title("raw data");
        legend("data","mean","min","max");
        datetick('x','dd-mm HH:MM:ss');
        
        % get ready for new data set
        iCol=iCol+1;
        if ( iCol>nCols ), iCol=1; iRow=iRow+1; end
    end
    fprintf("...done;\n");
end

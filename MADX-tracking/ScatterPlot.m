function ScatterPlot(data,indices,xIDs,yIDs,whichData,currTitle)
% ScatterPlot  Prepare scatter plots
%
% The user decides what to show
%
% ScatterPlot(data,indices,xIDs,yIDs,whichData,currTitle)
%
% input arguments:
%   data: table with particle coordinates;
%   indices: index of particles to be plotted (eg to apply some filtering);
%   xIDs, yIDs: ID of the quantity to be plotted:
%   whichData: format of the table;
%   currTitle: title of the plot;
%
% See also GetVariablesAndMapping.

    if ( length(xIDs)~=length(yIDs) )
        error('...number of x-axes different from number of y-axes!');
        return
    end
    [nRows,nCols]=GetNrowsNcols(length(xIDs));
    
    [ colNames, colUnits, colFacts, mapping ] = GetColumnsAndMappingTFS(whichData);

    actualTitle=sprintf('%s - Scatter plot - %s',whichData,currTitle);
    ff=figure('Name',actualTitle,'NumberTitle','off');
    for ii=1:length(xIDs)
        iColX=mapping(strcmpi(colNames,xIDs(ii)));
        iColY=mapping(strcmpi(colNames,yIDs(ii)));
        axt=subplot(nRows,nCols,ii);
        if (ismissing(indices))
            if (iscell(data))
                plot(data{iColX}*colFacts(iColX),data{iColY}*colFacts(iColY),'r.');
            else
                plot(data(:,iColX)*colFacts(iColX),data(:,iColY)*colFacts(iColY),'r.');
            end
        else
            if (iscell(data))
                plot(data{iColX}(indices)*colFacts(iColX),data{iColY}(indices)*colFacts(iColY),'r.');
            else
                plot(data(indices,iColX)*colFacts(iColX),data(indices,iColY)*colFacts(iColY),'r.');
            end
        end
        xlabel(sprintf('%s [%s]',colNames(iColX),colUnits(iColX)));
        ylabel(sprintf('%s [%s]',colNames(iColY),colUnits(iColY)));
        grid on;
    end
    sgtitle(actualTitle);
end
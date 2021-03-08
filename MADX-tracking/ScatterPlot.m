function ScatterPlot(data,indeces,xIDs,yIDs,whichData,currTitle)
% ScatterPlot  Prepare scatter plots
%
% The user decides what to show
%
% ScatterPlot(data,indeces,xIDs,yIDs,whichData,currTitle)
%
% input arguments:
%   data: table with particle coordinates;
%   indeces: index of particles to be plotted (eg to apply some filtering);
%   xIDs, yIDs: ID of the quantity to be plotted:
%   whichData: format of the table;
%   currTitle: title of the plot;
%
% See also GetVariablesAndMapping.

    if ( length(xIDs)~=length(yIDs) )
        error('...number of x-axes different from number of y-axes!');
        return
    end
    nn=ceil(sqrt(length(xIDs)));
    
    [ colNames, colUnits, colFacts, mapping ] = GetVariablesAndMapping(whichData);

    actualTitle=sprintf('%s - Scatter plot - %s',whichData,currTitle);
    ff=figure('Name',actualTitle,'NumberTitle','off');
    for ii=1:size(xIDs,2)
        axt=subplot(nn,nn,ii);
        plot(data{mapping(xIDs(ii))}(indeces)*colFacts(xIDs(ii)),data{mapping(yIDs(ii))}(indeces)*colFacts(yIDs(ii)),'r*');
        xlabel(sprintf('%s [%s]',colNames(xIDs(ii)),colUnits(xIDs(ii))));
        ylabel(sprintf('%s [%s]',colNames(yIDs(ii)),colUnits(yIDs(ii))));
        grid on;
    end
    sgtitle(actualTitle);
end
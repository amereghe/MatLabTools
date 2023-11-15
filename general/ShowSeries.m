function ShowSeries(xVals,yVals,showXlabel,showYlabel,myLeg,myTitles,refY,refX,refLeg,nCoupled)
% ShowStuff      to display data series (xVals,yVals) as several plots in a single figure
%
% NOTA BENE:
% - size(xVals)=size(yVals) (NOT CHECKED YET!)
% - number of points in each plotted series: size(xVals,1)=size(yVals,1);
% - number of series per plot: size(xVals,2)=size(yVals,2);
% - number of plots per figure: size(xVals,3)=size(yVals,3);
% - ref data can be:
%   . unique for all plots or a dedicated one for each plot -- size(refY,3);
%   . for each plot, a unique series (black) or a few (the first one black, the others grey) -- size(refY,2);

    if (~exist("myTitles","var")), myTitles=missing(); end
    if (~exist("refY","var")), refY=missing(); end
    if (~exist("refX","var")), refX=missing(); end
    if (~exist("refLeg","var")), refLeg=missing(); end
    if (~exist("nCoupled","var")), nCoupled=1; end
    nSets=size(yVals,2);
    nShows=size(yVals,3);
    nPlotsLegendThresh=10; % max number of subplots before having a dedicated one for the legend
    nSeriesLegendThresh=10; % max number of series before having a dedicated one for the legend

    figure();
    % - set grid of plots
    nPlots=nShows;
    if (all(~ismissing(myLeg)) && ( nPlots>nPlotsLegendThresh || nSets>nSeriesLegendThresh ) ), nPlots=nPlots+1; end
    [nRows,nCols]=GetNrowsNcols(nPlots,nCoupled);
    % - set markers
    if ( nSets==2 )
        markers=[ "o" "*" ];
        cm=[1 0 0 ; 0 0 1]; % red and blue
    else
        markers=strings(nSets,1);  markers(:)=".";
        cm=colormap(parula(nSets));
    end
    if (~ismissing(refY))
        refMarkers=strings(size(refY,2),1); refMarkers(:)="-";
        refColors=NaN(size(refY,2),3); refColors(1,:)=[0 0 0];
        if (size(refY,2)>1), refColors(2:end,:)=repmat([0.7 0.7 0.7],[size(refColors,1)-1 1]); end
    end
    % - legend
    tmpLeg=[];
    if (all(~ismissing(myLeg)))
        tmpLeg=myLeg;
    end
    if (all(~ismissing(refLeg)))
        tmpLeg=[tmpLeg refLeg];
    end
    % - actually plot
    for iPlot=1:nShows
        axs(iPlot)=subplot(nRows,nCols,iPlot);
        lFirst=true;
        if (~ismissing(refX))
            for jRef=1:size(refY,2)
                if (lFirst), lFirst=false; else, hold on; end
                if (size(refX,2)==1), jX=1; else, jX=jRef; end
                if (size(refX,3)==1), kX=1; else, kX=iPlot; end
                if (size(refY,2)==1), jY=1; else, jY=jRef; end
                if (size(refY,3)==1), kY=1; else, kY=iPlot; end
                plot(refX(:,jX,kX),refY(:,jY,kY),refMarkers(jRef),"Color",refColors(jRef,:));
            end
            lFirst=false;
        end
        for iSet=1:nSets
            if (lFirst), lFirst=false; else, hold on; end
            if (size(xVals,2)==1), jX=1; else, jX=iSet; end
            if (size(xVals,3)==1), kX=1; else, kX=iPlot; end
            plot(xVals(:,jX,kX),yVals(:,iSet,iPlot),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        if (length(showXlabel)==nShows), iX=iPlot; else, iX=1; end; xlabel(showXlabel(iX));
        if (length(showYlabel)==nShows), iY=iPlot; else, iY=1; end; ylabel(showYlabel(iY));
        grid on;
        if (all(~ismissing(myTitles))), title(myTitles(iPlot)); end
        if (~isempty(tmpLeg) && ( nPlots<=nPlotsLegendThresh && nSets<=nSeriesLegendThresh ) ), legend(tmpLeg); end
    end
    % - legend plot
    if (~isempty(tmpLeg) && ( nPlots>nPlotsLegendThresh || nSets>nSeriesLegendThresh ) )
        subplot(nRows,nCols,nPlots);
        lFirst=true;
        if (all(~ismissing(refLeg)))
            plot(NaN(),NaN(),"k-");
            if (size(refY,2)>1)
                hold on; plot(NaN(),NaN(),"-","Color",[.7 .7 .7]);
                hold on; plot(NaN(),NaN(),"-","Color",[.7 .7 .7]);
            end
            lFirst=false;
        end
        for iSet=1:nSets
            if (lFirst), lFirst=false; else, hold on; end
            plot(NaN(),NaN(),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        legend(tmpLeg,"Location","best"); title("legend");
    end
    % - general stuff
    if (all(~ismissing(myTitles)))
        if (length(myTitles)>nShows), sgtitle(myTitles(end)); end
    end
    % linkaxes(axs,"xy");
end

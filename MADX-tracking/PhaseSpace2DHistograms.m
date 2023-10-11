function PhaseSpace2DHistograms(data,indeces,xIDs,yIDs,nBins,nTot,whichData,currTitle,whichPlot,offSets,sigmas,hist1D)
% PhaseSpace2DHistograms  Prepare scatter plots
%
% The user decides what to show.
% Nota Bene: if a second set of particle coordinates is given, then the
% plot will show the ratio of the histograms computed on the same mesh
%
% PhaseSpace2DHistograms(data,indeces,xIDs,yIDs,nBins,nTot,whichData,currTitle)
%
% input arguments:
%   data: table with particle coordinates;
%   indeces: index of particles to be plotted (eg to apply some filtering);
%   xIDs, yIDs: ID of the quantity to be plotted (x=1, px=2, etc...);
%   nBins: number of bins on each quantity;
%   nTot: a normalisation number, used when plotting losses;
%   whichData: format of the table (losses or starting conditions);
%   currTitle: title of the plot;
%
% See also GetVariablesAndMapping.

    % check number of x-axis and y-axis variables
    if ( length(xIDs)~=length(yIDs) )
        error('...number of x-axes different from number of y-axes!');
        return
    end

    % identify what to show in the 2D plots
    if ( strcmp(lower(whichData),'start') || strcmp(lower(whichData),'starting') )
        whichPlotUsr='survivors';
        if ( exist('whichPlot','var') )
            whichPlotUsr=whichPlot;
        end
    else
        whichPlotUsr='pdf';
        if ( exist('whichPlot','var') )
            whichPlotUsr=whichPlot;
        end
    end
    
    % identify variables on x-axis and y-axis
    [ colNames, colUnits, colFacts, mapping ] = GetVariablesAndMapping(whichData);
    
    % additional manipulations to x-axis and y-axis
    offSetsUsr=zeros(1,6);
    if ( exist('offSets','var') )
        offSetsUsr=offSets;
    end
    sigmasUsr=ones(1,6)/1000;
    if ( exist('sigmas','var') )
        sigmasUsr=sigmas;
    end
    hist1DUsr=0;
    if ( exist('hist1D','var') )
        hist1DUsr=hist1D;
    end

    if ( ~hist1DUsr )
        switch length(xIDs)
            case {1}
                nRows=1;
                nCols=1;
            case {2}
                nRows=1;
                nCols=2;
            case {3}
                nRows=1;
                nCols=3;
            case {4}
                nRows=2;
                nCols=2;
            case {5,6}
                nRows=2;
                nCols=3;
            otherwise
                error('too many 2D plots!');
                return
        end
        actualTitle=sprintf('%s - Ph. Space Hist. - %s',whichData,currTitle);
        ff=figure('Name',actualTitle,'NumberTitle','off');
    end
    for ii=1:size(xIDs,2)
        % grid
        if ( strcmp(lower(whichData),'start') || strcmp(lower(whichData),'starting') )
            % grid covers the entire range of starting conditions
            gridDataX=data{mapping(xIDs(ii))};
            gridDataY=data{mapping(yIDs(ii))};
            nBinsX=nBins(xIDs(ii))+1;
            nBinsY=nBins(yIDs(ii))+1;
        else
            % grid covers only the range of coordinates of selected
            % particles
            gridDataX=data{mapping(xIDs(ii))}(indeces);
            gridDataY=data{mapping(yIDs(ii))}(indeces);
            nBinsX=nBins(xIDs(ii));
            nBinsY=nBins(yIDs(ii));
        end
        minX=min(gridDataX);
        maxX=max(gridDataX);
        minY=min(gridDataY);
        maxY=max(gridDataY);
        % check 
        if ( minX == maxX )
            fprintf(' ...single value in %s! adjusting...\n',colNames(xIDs(ii)));
            [minX,maxX]=adjustRange(minX,maxX);
        end
        if ( minY == maxY )
            fprintf(' ...single value in %s! adjusting...\n',colNames(yIDs(ii)));
            [minY,maxY]=adjustRange(minY,maxY);
        end
        xb = linspace(minX,maxX,nBinsX);
        yb = linspace(minY,maxY,nBinsY);
        
        % histogram on selected particles
        [nCounts,nCountsX,nCountsY]=Get2dHistograms(...
            data{mapping(xIDs(ii))}(indeces),data{mapping(yIDs(ii))}(indeces),...
            xb,yb,hist1DUsr);
        % histogram on starting conditions
        if ( strcmp(lower(whichData),'start') || strcmp(lower(whichData),'starting') )
            [nCountsAll,nCountsXAll,nCountsYAll]=Get2dHistograms(...
                data{mapping(xIDs(ii))},data{mapping(yIDs(ii))},...
                xb,yb,hist1DUsr);
        end
        
        % what to plot, exactly?
        if ( strcmp(lower(whichData),'start') || strcmp(lower(whichData),'starting') )
            switch lower(whichPlotUsr)
                case {'counts'}
                    showMe=nCounts;
                    if ( hist1DUsr )
                        showMe1DX=nCountsX;
                        showMe1DY=nCountsY;
                    end
                case {'pdf'}
                    showMe=nCounts./nCountsAll*100;
                    if ( hist1DUsr )
                        showMe1DX=nCountsX./nCountsXAll*100;
                        showMe1DY=nCountsY./nCountsYAll*100;
                    end
                case {'survivors'}
                    showMe=(1-nCounts./nCountsAll)*100;
                    if ( hist1DUsr )
                        showMe1DX=(1-nCountsX./nCountsXAll)*100;
                        showMe1DY=(1-nCountsY./nCountsYAll)*100;
                    end
                otherwise
                    error('what to show (starting conditions)?');
                    return
            end
        else        
            switch lower(whichPlotUsr)
                case {'counts'}
                    showMe=nCounts;
                    if ( hist1DUsr )
                        showMe1DX=nCountsX;
                        showMe1DY=nCountsY;
                    end
                case {'pdf'}
                    showMe=nCounts/nTot;
                    if ( hist1DUsr )
                        showMe1DX=nCountsX/nTot;
                        showMe1DY=nCountsY/nTot;
                    end
                otherwise
                    error('what to show (losses)?');
                    return
            end
        end
        xShow=(xb+offSetsUsr(xIDs(ii)))*colFacts(xIDs(ii));
        xShowLabel=sprintf('%s [%s]',colNames(xIDs(ii)),colUnits(xIDs(ii)));
        if ( sigmasUsr(xIDs(ii))*colFacts(xIDs(ii)) ~= 1 )
            xShow=xShow/(sigmasUsr(xIDs(ii))*colFacts(xIDs(ii)));
            xShowLabel=sprintf('%s [\\sigma] - \\sigma=%g %s',colNames(xIDs(ii)),...
                sigmasUsr(xIDs(ii))*colFacts(xIDs(ii)), colUnits(xIDs(ii)));
        end
        yShow=(yb+offSetsUsr(yIDs(ii)))*colFacts(yIDs(ii));
        yShowLabel=sprintf('%s [%s]',colNames(yIDs(ii)),colUnits(yIDs(ii)));
        if ( sigmasUsr(yIDs(ii))*colFacts(yIDs(ii)) ~= 1 )
            yShow=yShow/(sigmasUsr(yIDs(ii))*colFacts(yIDs(ii)));
            yShowLabel=sprintf('%s [\\sigma] - \\sigma=%g %s',colNames(yIDs(ii)),...
                sigmasUsr(yIDs(ii))*colFacts(yIDs(ii)), colUnits(yIDs(ii)));
        end
        % actual plot
        if ( hist1DUsr )
            actualTitle=sprintf('%s - Ph. Space Hist. - %s',whichData,currTitle);
            Show2DHistograms(showMe,showMe1DX,showMe1DY,xShow,yShow,actualTitle);
        else
            axt=subplot(nRows,nCols,ii);
            hh=histogram2('XBinEdges',xShow,'YBinEdges',yShow,...
                          'BinCounts',showMe,'DisplayStyle','tile','ShowEmptyBins','on');
            % additionals
            xlabel(xShowLabel);
            ylabel(yShowLabel);
            colorbar();
            % caxis manual;
            % caxis([cmin cmax]);
            grid on;
            % set(axt,'ColorScale','log')
        end
    end
    if ( ~hist1DUsr )
        sgtitle(actualTitle);
    end
end

function [zMin,zMax]=adjustRange(zMin,zMax)
    if ( zMin == 0 )
        zMin=-1;
        zMax= 1;
    else
        zMin=zMin*0.99;
        zMax=zMax*1.01;
        if (zMin>zMax)
            temp=zMin;
            zMin=zMax;
            zMax=temp;
        end
    end
end
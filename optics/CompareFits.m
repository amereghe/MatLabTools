function CompareFits(calcY,xVals,measY,measCurr,what,myXlabel,myYlabel,colNames,rowNames,seriesNames,myTit,myMon,nSeriesPerPlane,outName)
    if ( ~strcmpi(what,"SIG") && ~strcmpi(what,"BAR") )
        error("you can compare either SIGmas or BARicentres!");
    end
    
    nXs=size(calcY,1);
    nRows=size(calcY,2); % eg: planes
    nCols=size(calcY,4); % eg: fracEst
    
    %% checks
    if ( size(measY,1)~=nXs )
        error("Measured data must have as many values as the calculated ones!");
    end
    if ( size(measY,2)~=nRows )
        error("Measured data must be parametrised as the calculated ones (2nd dim)");
    end   
    if ( size(measY,3)~=nCols )
        error("Measured data must be parametrised as the calculated ones (3rd dim)!");
    end
    
    %% actual plotting
    ff=figure();
    cm=colormap(parula(max(nSeriesPerPlane)));
    ff.Position(1:2)=[0 0]; % figure at lower-left corner of screen
    ff.Position(3)=ff.Position(3)*nCols*(2./3.); % larger figure:
    ff.Position(4)=ff.Position(4)*nRows*(2./3.); % larger figure:
    t = tiledlayout(nRows,nCols+1,'TileSpacing','Compact','Padding','Compact'); % minimise whitespace around plots
    ii=0;
    for iRow=1:nRows % eg: plane
        for iCol=1:nCols % eg: fractEst
            ii=ii+1; axs(iRow,iCol)=nexttile; % subplot(nRows,nCols+1,ii);
            % - measurements
            plot(measCurr(:,iRow),measY(:,iRow,iCol),"k*"); hold on;
            % - fits
            for iSeries=1:nSeriesPerPlane(iRow)
                hold on; plot(xVals(:,iRow,iSeries),calcY(:,iRow,iSeries,iCol)*1E3,".-","color",cm(iSeries,:));
            end
            % - bin width
            if ( strcmpi(what,"SIG") )
                PlotMonsBinWidth(measCurr(:,iRow),myMon);
            end
            % - general
            grid(); xlabel(myXlabel); ylabel(myYlabel);
            title(sprintf("%s plane - %s",rowNames(iRow),colNames(iCol)));
        end
        % dedicated plot for the legend
        if ( iRow==1 )
            ii=ii+1; nexttile; % subplot(nRows,nCols+1,ii);
            plot(NaN(),NaN(),"k*");
            for iSeries=1:nSeriesPerPlane(iRow)
                hold on; plot(NaN(),NaN(),".-","Color",cm(iSeries,:));
            end
            if ( strcmpi(what,"SIG") )
                hold on; plot(NaN(),NaN(),"r-");
                legends=strings(nSeriesPerPlane(iRow)+2,1);
                legends(1)="measurements";
                legends(2:end-1)=seriesNames(1:nSeriesPerPlane(iRow));
                legends(end)="MON bin width";
            else
                legends=strings(nSeriesPerPlane(iRow)+1,1);
                legends(1)="measurements";
                legends(2:end)=seriesNames(1:nSeriesPerPlane(iRow));
            end
            legend(legends,"Location","best");
        end
    end
    if ( nCols>1 )
        linkaxes(axs(1,:),"xy"); % all HOR quantities
        linkaxes(axs(2,:),"xy"); % all VER quantities
    end
    sgtitle(myTit);
    % save figure
    if ( exist('outName','var') )
        if ( strlength(outName)>0 )
            savefig(outName);
            fprintf("...saving to file %s ...\n",outName);
        end
    end
end

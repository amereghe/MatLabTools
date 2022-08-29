function ShowScanRawPlots(Is,FWHMs,BARs,INTs,nData,scanDescription,titleSeries,actPlotName)
% ShowScanRawPlots               to show FWxMs, BARs and BARicentres of scans 
%                                  as simple sequence of values; current values
%                                  used in the scan are shown as well.
%
% input:
% - Is (float(:,1)): list of current values [A];
% - FWHMs/BARs/INTs (float(nData,2,nSeries)): list of values of FWHM and
%    BARicentre [mm], and integral of counts;
%    the column indicates the plane:
%    . 1: hor plane;
%    . 2: ver plane;
% - nData (float(nSeries,1)): number of rows in FWHMs/BARs/INTs for each
%    series;
% - scanDescription (string(1,1)): label used for the figure title;
% - titleSeries (string(nSeries,1), optional): a single label for each
%    series, e.g. indicating the name; if not given, the function
%    associates specific names
% - actPlotName (string(1,1), optional): label used to generate a .png file.
%    Please check the variable MapFileOut in this function for the
%    nomenclature. If not given, a window appears with the plot, and no
%    .png file is saved;
%    
    fprintf("plotting raw data of scans: FWHMs, BARs and Integrals vs ID...\n");
    figure();
    if ( ~exist('titleSeries','var') || sum(ismissing(titleSeries)) )
        titleSeries=compose("Series %02i",(1:size(FWHMs,3))');
    end
    nSeries=size(FWHMs,3);
    nRows=nSeries;
    nCols=3;
    if ( ~ismissing(Is) ), nRows=nRows+1; end
    for jj=1:nSeries
        for kk=1:3 % FWHM,BAR,INT
            switch kk
                case 1
                    whatToShow=FWHMs; whatName="FWHM"; labelY="[mm]";
                case 2
                    whatToShow=BARs; whatName="Baricentre"; labelY="[mm]";
                case 3
                    whatToShow=INTs; whatName="integral"; labelY="[]";
            end
            iPlot=kk+(jj-1)*nCols;
            ax(iPlot)=subplot(nRows,nCols,iPlot);
            plot(whatToShow(1:nData(jj),1,jj),"*-"); hold on; plot(whatToShow(1:nData(jj),2,jj),"*-");
            if ( strcmpi(whatName,"FWHM") )
                PlotMonsBinWidth([1 nData(jj)],titleSeries(jj));
                legend("HOR","VER","MON bin width","Location","best");
            else
                legend("HOR","VER","Location","best");
            end
            grid on; ylabel(labelY); xlabel("ID []");
            title(sprintf("%s - %s",whatName,titleSeries(jj)));
        end
    end
    % corrente
    if ( ~ismissing(Is) )
        iPlot=iPlot+1;
        ax(iPlot)=subplot(nRows,nCols,iPlot);
        plot(Is,"*-");
        grid on; ylabel("[A]"); xlabel("ID []");
        title("Scan current");
    end
    % general
    sgtitle(scanDescription);
    linkaxes(ax,"x");
    if ( exist('actPlotName','var') )
        MapFileOut=sprintf("%s_RawData.fig",actPlotName);
        savefig(MapFileOut);
        fprintf("...saving to file %s ...\n",MapFileOut);
    end
    fprintf("...done.\n");
end


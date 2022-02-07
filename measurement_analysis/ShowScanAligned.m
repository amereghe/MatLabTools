function ShowScanAligned(Is,FWHMs,BARs,indices,scanDescription,titleSeries,actPlotName)
% ShowScanAligned               to show FWxMs and BARs as a function of current
%                                 in single magnet scans
%
% input:
% - Is (float(:,1)): list of current values [A];
% - FWHMs/BARs (float(nData,2,nSeries)): list of values of FWHM and BARicentre [mm];
%    the column indicates the plane:
%    . 1: hor plane;
%    . 2: ver plane;
% - indices (float(1+nSeries,2)): min and max indices of the points
%    of the actual scan in the series and in the currentsXLS array;
%    NB: first index refers to currents in .xlsx file;
% - scanDescription (string(1,1)): label used for the figure title;
% - titleSeries (string(nSeries,1), optional): a single label for each
%    series, e.g. indicating the name; if not given, the function
%    associates specific names
% - actPlotName (string(1,1), optional): label used to generate a .png file.
%    Please check the variable MapFileOut in this function for the
%    nomenclature. If not given, a window appears with the plot, and no
%    .png file is saved;
%    
    fprintf("plotting scan data: FWxMs and BARs vs Iscan...\n");
    if ( exist('actPlotName','var') )
        ff = figure('visible','off');
    else
        figure();
    end
    if ( ~exist('titleSeries','var') || sum(ismissing(titleSeries)) )
        titleSeries=compose("Series %02i",(1:size(FWHMs,3))');
    end
    nSeries=size(FWHMs,3);
    for jj=1:nSeries
        for kk=1:2 % FWHM,BAR
            switch kk
                case 1
                    whatToShow=FWHMs; whatName="FWHM"; labelY="[mm]";
                case 2
                    whatToShow=BARs; whatName="Baricentre"; labelY="[mm]";
            end
            iPlot=kk+(jj-1)*2;
            ax(iPlot)=subplot(nSeries,2,iPlot);
            yyaxis left;
            plot(Is(indices(1,1):indices(1,2)),whatToShow(indices(jj+1,1):indices(jj+1,2),1,jj),"*-"); ylabel(sprintf("HOR %s",labelY));
            yyaxis right;
            plot(Is(indices(1,1):indices(1,2)),whatToShow(indices(jj+1,1):indices(jj+1,2),2,jj),"*-"); ylabel(sprintf("VER %s",labelY));
            yyaxis left;
            grid on; xlabel("I [A]");
            title(sprintf("%s - %s",whatName,titleSeries(jj))); % legend("HOR","VER","Location","best");
        end
    end
    % general
    sgtitle(scanDescription);
    linkaxes(ax,"x");
    if ( exist('actPlotName','var') )
        MapFileOut=sprintf("%s_scans.png",actPlotName);
        fprintf("...saving to file %s ...\n",MapFileOut);
        exportgraphics(ff,MapFileOut,'Resolution',300); % resolution=DPI
    end
    fprintf("...done.\n");
end

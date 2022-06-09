function CompareDDSSummaryAndProfiles(barsSumm,fwhmsSumm,intsSumm,BARs,FWHMs,INTs)
    fprintf("Comparing summary data and statistics data on profiles...\n");

    figure();
    planes=["HOR" "VER"];
    
    for iWhat=1:3
        switch iWhat
            case 1
                what=BARs; whatSumm=barsSumm; myYlab="%s [mm]"; myTitle="BARicentre";
            case 2
                what=FWHMs; whatSumm=fwhmsSumm; myYlab="%s [mm]"; myTitle="FWHM";
            case 3
                what=INTs; whatSumm=intsSumm; myYlab="%s [counts]"; myTitle="INTegrals";
        end
        for iPlane=1:length(planes)
            iPlot=(iPlane-1)*3+iWhat;
            axs(iPlot)=subplot(2,3,iPlot);
            plot(1:size(what,1),what(:,iPlane),"o-");
            hold on;
            plot(1:size(whatSumm,1),whatSumm(:,iPlane),"*-");
            grid(); title(sprintf("%s %s",planes(iPlane),myTitle));
            xlabel("ID []"); ylabel(sprintf(myYlab,myTitle));
            legend(["stat on profiles" "summary data"],"Location","best");
        end
    end
    
    % global
    linkaxes(axs,"x");
    
    fprintf("...done.\n");
end
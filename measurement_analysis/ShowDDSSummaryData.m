function ShowDDSSummaryData(bars,fwhms,asyms,ints)
    figure();
    planes=["HOR" "VER"];
    
    for iWhat=1:4
        switch iWhat
            case 1
                what=bars; myYlab="%s [mm]"; myTitle="BARicentre";
            case 2
                what=fwhms; myYlab="%s [mm]"; myTitle="FWHM";
            case 3
                what=asyms; myYlab="%s [mm]"; myTitle="ASYmmetry";
            case 4
                what=ints; myYlab="%s [counts]"; myTitle="INTegrals";
        end
        axs(iWhat)=subplot(2,2,iWhat);
        for iPlane=1:length(planes)
            if ( iPlane>1 ), hold on; end
            plot(1:size(what,1),what(:,iPlane),".-");
        end
        grid(); title(myTitle);
        xlabel("ID []"); ylabel(sprintf(myYlab,myTitle));
        legend(planes+" plane","Location","best");
    end
    
    % global
    linkaxes(axs,"x");
    
end

function ShowDCTtime(DCTtStamps,DCTcurrs,DCTcyCodes,xVals,whatYlab,whatXlab)

    fprintf("plotting %s data vs time...\n",whatYlab);
    [rangeCodes,partCodes]=DecodeCyCodes(DCTcyCodes);
    indicesP=FlagPart(partCodes,"p");
    indicesC=FlagPart(partCodes,"C");
    figure();

    % DCT data
    ax1=subplot(2,1,1);
    plot(datenum(DCTtStamps(indicesP)),DCTcurrs(indicesP,1),"r.",...
         datenum(DCTtStamps(indicesC)),DCTcurrs(indicesC,1),"b.");
    ylabel(whatYlab); set(gca, 'YScale', 'log');
    datetick('x','dd-mm HH:MM:ss'); set(gca,'XTickLabelRotation',45);
    legend("proton","carbon",'location','best'); grid();

    % beam energies/ranges
    ax2=subplot(2,1,2);
    plot(datenum(DCTtStamps(indicesP)),xVals(indicesP),"r.",...
         datenum(DCTtStamps(indicesC)),xVals(indicesC),"b.");
    ylabel(whatXlab);
    datetick('x','dd-mm HH:MM:ss'); set(gca,'XTickLabelRotation',45);
    legend("proton","carbon",'location','best'); grid();

    % global
    dynamicDateTicks([ax1 ax2], 'linked');
    linkaxes([ax1 ax2],"x");
        
    fprintf("...done;\n");
end


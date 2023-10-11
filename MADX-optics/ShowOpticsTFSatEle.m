function ShowOpticsTFSatEle(myOptics,optLabels)
    %% identify columns
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
        GetColumnsAndMappingTFS("optics","SCAN");
    planes=["x" "y"];

    nPoints=length(myOptics{1});
    nOptics=size(myOptics,1);
    if (nOptics==1)
        nRows=2; nCols=2;
    else
        nRows=4; nCols=2;
        if (~exist("optLabels","var"))
            optLabels=compose("optics #%d",1:nOptics);
        end
    end
    
    %% actually plot
    iPlot=0;
    figure();
    cm=colormap(jet(nOptics));
    iCol=[ mapping(strcmp(colNames,'BETX')) mapping(strcmp(colNames,'BETY')) ];
    if (nOptics==1)
        iPlot=iPlot+1;
        subplot(nRows,nCols,iPlot);
        plot(1:nPoints,myOptics{nOptics,iCol(1)},"ro-",1:nPoints,myOptics{nOptics,iCol(2)},"b*-");
        ylabel("\beta [m]"); grid on; xlabel("ID []");
        legend(compose("\\beta_{%s}",planes),"Location","best");
    else
        for iPlane=1:2
            % planes
            iPlot=iPlot+1;
            subplot(nRows,nCols,iPlot);
            for iOpt=1:nOptics
                % optics
                if (iOpt>1), hold on; end
                plot(1:nPoints,myOptics{iOpt,iCol(iPlane)},".-","Color",cm(iOpt,:));
            end
            ylabel(sprintf("\\beta_{%s} [m]",planes(iPlane))); grid on; xlabel("ID []");
            legend(optLabels,"Location","best");
        end
    end

    iCol=[ mapping(strcmp(colNames,'X')) mapping(strcmp(colNames,'Y')) ];
    if (nOptics==1)
        iPlot=iPlot+1;
        subplot(nRows,nCols,iPlot);
        plot(1:nPoints,myOptics{nOptics,iCol(1)},"ro-",1:nPoints,myOptics{nOptics,iCol(2)},"b*-");
        ylabel("pos [m]"); grid on; xlabel("ID []");
        legend(compose("%s",planes),"Location","best");
    else
        for iPlane=1:2
            % planes
            iPlot=iPlot+1;
            subplot(nRows,nCols,iPlot);
            for iOpt=1:nOptics
                % optics
                if (iOpt>1), hold on; end
                plot(1:nPoints,myOptics{iOpt,iCol(iPlane)},".-","Color",cm(iOpt,:));
            end
            ylabel(sprintf("%s [m]",planes(iPlane))); grid on; xlabel("ID []");
            legend(optLabels,"Location","best");
        end
    end

    iCol=[ mapping(strcmp(colNames,'DX')) mapping(strcmp(colNames,'DY')) ];
    if (nOptics==1)
        iPlot=iPlot+1;
        subplot(nRows,nCols,iPlot);
        plot(1:nPoints,myOptics{nOptics,iCol(1)},"ro-",1:nPoints,myOptics{nOptics,iCol(2)},"b*-");
        ylabel("D [m]"); grid on; xlabel("ID []");
        legend(compose("D_{%s}",planes),"Location","best");
    else
        for iPlane=1:2
            % planes
            iPlot=iPlot+1;
            subplot(nRows,nCols,iPlot);
            for iOpt=1:nOptics
                % optics
                if (iOpt>1), hold on; end
                plot(1:nPoints,myOptics{iOpt,iCol(iPlane)},".-","Color",cm(iOpt,:));
            end
            ylabel(sprintf("D_{%s} [m]",planes(iPlane))); grid on; xlabel("ID []");
            legend(optLabels,"Location","best");
        end
    end

    iCol=[ mapping(strcmp(colNames,'MUX')) mapping(strcmp(colNames,'MUY')) ];
    if (nOptics==1)
        iPlot=iPlot+1;
        subplot(nRows,nCols,iPlot);
        plot(1:nPoints,myOptics{nOptics,iCol(1)}*360,"ro-",1:nPoints,myOptics{nOptics,iCol(2)}*360,"b*-");
        ylabel("\mu [degs]"); grid on; xlabel("ID []");
        legend(compose("\\mu_{%s}",planes),"Location","best");
    else
        for iPlane=1:2
            % planes
            iPlot=iPlot+1;
            subplot(nRows,nCols,iPlot);
            for iOpt=1:nOptics
                % optics
                if (iOpt>1), hold on; end
                plot(1:nPoints,myOptics{iOpt,iCol(iPlane)}*360,".-","Color",cm(iOpt,:));
            end
            ylabel(sprintf("\\mu_{%s} [degs]",planes(iPlane))); grid on; xlabel("ID []");
            legend(optLabels,"Location","best");
        end
    end
    
end

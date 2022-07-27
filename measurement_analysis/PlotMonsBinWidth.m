function PlotMonsBinWidth(xVals,myMon,color)
    if ( ~exist("color","var") ), color="r"; end
    switch upper(extractBetween(myMon,1,3))
        case {"GIM"}
            hold on; plot([min(xVals) max(xVals)],[0.5 0.5],"-","Color",color);
        case {"CAM","SFM","SFH","SFP"}
            hold on; plot([min(xVals) max(xVals)],[1 1],"-","Color",color);
        case "DDS"
            hold on; plot([min(xVals) max(xVals)],[1.65 1.65],"-","Color",color);
    end
end

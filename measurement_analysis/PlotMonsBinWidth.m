function PlotMonsBinWidth(xVals,myMon,color)
    if ( ~exist("color","var") ), color="r"; end
    BinWidth=ReturnMonBinWidth(myMon);
    hold on; plot([min(xVals) max(xVals)],[BinWidth BinWidth],"-","Color",color);
end

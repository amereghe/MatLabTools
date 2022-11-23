function BinWidth=ReturnMonBinWidth(myMon)
    switch upper(extractBetween(myMon,1,3))
        case {"GIM"}
            BinWidth=0.5;
        case {"CAM","SFM","SFH","SFP"}
            BinWidth=1;
        case "DDS"
            BinWidth=1.65;
    end
end

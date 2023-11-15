function [refFWHM,xVals]=Spots_LoadEffectiveSpecs(beamPart,myXwhat,config,spotType,relLev,absLev)
    if (~exist("myXwhat","var")), myXwhat="Range"; end
    if (~exist("config","var")), config="TM"; end
    if (~exist("spotType","var")), spotType="STEERPAZ"; end
    if (~exist("relLev","var")), relLev=0.1; end % default: 10%
    if (~exist("absLev","var")), absLev=1.0; end % default: 1 mm
    machine=["Sala1" "Sala2H" "Sala2V" "Sala3"];
    nSets=length(machine);
    FWHMs=missing();
    for iSet=1:nSets
        % - parse DB file
        clear tmpCyProgs tmpCyCodes tmpBARs tmpFWHMs tmpASYMs tmpINTs tmpXvals;
        myConfig=sprintf("%s,%s,%s",machine(iSet),beamPart,config);
        FullFileName=ReturnDefFile(spotType,myConfig);
        switch upper(spotType)
            case "STEERPAZ"
                [tmpCyProgs,tmpCyCodes,tmpBARs,tmpFWHMs,tmpASYMs,tmpINTs]=ParseBeamProfileSummaryFiles(FullFileName,"CAM");
                if (length(tmpCyProgs)<=1), error("...no ary data aquired!"); end
            otherwise
                error("Unknown spot type %s!",spotType);
        end
        % - convert cyCodes
        [tmpXvals,~]=MapCyCodes(tmpCyCodes,myXwhat);
        % - store data
        FWHMs=ExpandMat(FWHMs,tmpFWHMs);
        if (iSet==1), xVals=tmpXvals; end
    end
    % - compute actual reference
    [FWHMgeoMean,refASYM]=Spots_MeritFWHM(FWHMs);
    refFWHM=Spots_FWHMRefSeries(FWHMgeoMean,relLev,absLev);
end

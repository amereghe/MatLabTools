function [Eks,Mms,FWHMs,pos]=Spots_LoadRef(machine,beamPart,config,spotType,loc)
    if (~exist("config","var")), config="TM"; end
    if (~exist("spotType","var")), spotType="STEERPAZ"; end
    if (~exist("loc","var")), loc="ISO"; end
    myConfig=sprintf("%s,%s,%s",machine,beamPart,config);
    FullFileName=ReturnDefFile(spotType,myConfig);
    switch upper(spotType)
        case {"STEERINGPAZIENTI","SP","STEERPAZ"}
            [cyProgs,cyCodes,BARs,FWHMs,ASYMs,INTs]=ParseBeamProfileSummaryFiles(FullFileName,"CAM");
            if (length(cyProgs)<=1), error("...no data aquired!"); end
            % - convert cyCodes
            [Eks,~]=MapCyCodes(cyCodes,"Ek");
            [Mms,~]=MapCyCodes(cyCodes,"Range");
            pos=NaN();
        case {"MEDICALPHYSICS","MP","MEDPHYS"}
            [Eks,Mms,FWHMs,pos]=ParseMPrefFWHMfile(FullFileName,beamPart,loc);
            if (length(Eks)<=1), error("...no data aquired!"); end
        otherwise
            error("Unknown spot type %s!",spotType);
    end
end

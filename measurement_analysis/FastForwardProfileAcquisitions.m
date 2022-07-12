function [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,currCyProg,lastCyProg,fFormat)
    if ( ~exist("fFormat","var") ), fFormat="SFM"; end
    fprintf("...storing %d empty data set for absent cyProgs in range (%d:%d)...\n",currCyProg-lastCyProg-1,lastCyProg,currCyProg);
    nRows=size(measData,1);
    nColumns=size(measData,2);
    nDims=size(measData,3);
    nToInsert=currCyProg-lastCyProg-1;
    switch upper(fFormat)
        case {"GIM","PMM","PIB","QBM","SFH","SFM","SFP"}
            % profile monitors along beam lines have time-resolved
            %    distributions
            for iFast=1:nToInsert
                measData(:,:,:,actualDataSets)=NaN(nRows,nColumns,nDims);
                cyProgs(actualDataSets)=cyProgs(actualDataSets-1)+iFast;
                cyCodes(actualDataSets)=missing();
                actualDataSets=actualDataSets+1;
            end
        case {"DDS","CAV"}
            % cameretta and DDS show only cumulative distribution over
            %    entire spill
            measData(:,nColumns+1:nColumns+nToInsert,:)=NaN(nRows,nToInsert,nDims);
            cyProgs(nColumns-1+1:nColumns-1+nToInsert)=lastCyProg+1:currCyProg-1;
            cyCodes(nColumns-1+1:nColumns-1+nToInsert)=missing();
        otherwise
            error("Not recognised monitor: %s! Available: GIM/PMM/PIB/QBM/SFH/SFM/SFP and DDS/CAM",fFormat);
    end
    fprintf("...done.\n");
end

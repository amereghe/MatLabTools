function [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,currCyProg,lastCyProg)
    fprintf("...storing %d empty data set for absent cyProgs in range (%d:%d)...\n",currCyProg-lastCyProg-1,lastCyProg,currCyProg);
    nRows=size(measData,1);
    nColumns=size(measData,2);
    nDims=size(measData,3);
    for iFast=1:currCyProg-lastCyProg-1
        measData(:,:,:,actualDataSets)=NaN(nRows,nColumns,nDims);
        cyProgs(actualDataSets)=cyProgs(actualDataSets-1)+iFast;
        cyCodes(actualDataSets)=missing();
        actualDataSets=actualDataSets+1;
    end
    fprintf("...done.\n");
end
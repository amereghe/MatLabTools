function [tStamps,LGENs,LPOWs,racks,repoVals,appVals,cyCodes,cyProgs,endCycs]=ParseLPOWLog(paths2Files)
    fprintf("acquring LPOW error logs...\n");
    nDataTot=0;
    nReadFiles=0;
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nFiles=length(files);
        fprintf("...parsing %i files in path %s ...\n",nFiles,paths2Files(iPath));
        for iSet=1:nFiles
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nFiles,files(iSet).name);
            fileID = fopen(sprintf("%s\\%s",files(iSet).folder,files(iSet).name));
            C = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s','HeaderLines',1);
            fclose(fileID);
            
            fprintf("...crunching data...\n");
            nData=length(C{:,1});
            if ( nData>0 )
                tStamps(nDataTot+1:nDataTot+nData,1)=datetime(join(string([C{:,1},C{:,2}])),"InputFormat","dd-MM-yy HH.mm.ss");
                LGENs(nDataTot+1:nDataTot+nData,1)=string(C{:,3});
                LPOWs(nDataTot+1:nDataTot+nData,1)=string(C{:,4});
                racks(nDataTot+1:nDataTot+nData,1)=string(C{:,5});
                repoVals(nDataTot+1:nDataTot+nData,1)=str2double(C{:,6});
                appVals(nDataTot+1:nDataTot+nData,1)=str2double(C{:,7});
                cyCodes(nDataTot+1:nDataTot+nData,1)=extractAfter(string(C{:,8}),4);
                cyProgs(nDataTot+1:nDataTot+nData,1)=string(C{:,9});
                endCycs(nDataTot+1:nDataTot+nData,1)=string(C{:,10});
                nDataTot=nDataTot+nData;
                nReadFiles=nReadFiles+1;
            end
            fprintf("...acquired %d entries in file %s...\n",nData,files(iSet).name);
        end
    end
    
    if ( nReadFiles>0 )
        cyCodes=PadCyCodes(cyCodes);
        cyCodes=UpperCyCodes(cyCodes);
        if ( nReadFiles>1 )
            fprintf("...sorting by time stamp...\n");
            [tStamps,appVals,ids]=SortByTime(tStamps,appVals); % sort by timestamps
            LGENs=LGENs(ids(:,1));
            LPOWs=LPOWs(ids(:,1));
            racks=racks(ids(:,1));
            repoVals=repoVals(ids(:,1));
            cyCodes=cyCodes(ids(:,1));
            cyProgs=cyProgs(ids(:,1));
            endCycs=endCycs(ids(:,1));
        end
    else
        tStamps=missing;
        LGENs=missing;
        LPOWs=missing;
        racks=missing;
        appVals=missing;
        repoVals=missing;
        cyCodes=missing;
        cyProgs=missing;
        endCycs=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nDataTot);
end
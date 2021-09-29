function [cyProgs,cyCodes,currs,tStamps,ZZs]=ParseDCTFiles(paths2Files)
% ParseDCTFiles        parse log files of the synchro DCT
%
% input:
% - paths2Files (array of strings): path(s) where the file(s) is located (a dir command is anyway performed).
% output:
% - cyProgs (array of strings): cycle prog associated to each event;
% - cyCodes (array of strings): cycle code associated to each event;
% - currs (2D array of floats): charge [10^9 charges]:
%   . column 1: accelerated;
%   . column 2: injected;
% - tStamps (array of time stamps): time stamps of events (not clear which event of
%   timing, actually...);
% - ZZs (array of floats): ZZ of the particle, used as particle ID (1: proton; 6: carbon; -1: no particle);
%
% file of counts must have the following format:
% - 1 header line;
% - a line for each cycle prog; the format of the line is eg: "195873069  420036440900  0.433  0.863  50.166  00:02:13"

    fprintf("acquring DCT data...\n");
    nReadFiles=0;
    nCountsTot=0;
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nDataSets=length(files);
        fprintf("...acquring %i data sets in %s ...\n",nDataSets,paths2Files(iPath));
        for iSet=1:nDataSets
            fileNameSplit=split(files(iSet).name,"_"); 
            fileName=strcat(files(iSet).folder,"\",files(iSet).name);
            fileID = fopen(fileName,"r");
            C = textscan(fileID,'%s %s %f %f %f %s','HeaderLines',1);
            fclose(fileID);
            nCounts=length(C{:,1});
            if ( strcmpi(fileNameSplit(1),"dct-Proton") )
                ZZs(nCountsTot+1:nCountsTot+nCounts)=1;
            elseif ( strcmpi(fileNameSplit(1),"dct-Carbon") )
                ZZs(nCountsTot+1:nCountsTot+nCounts)=6;
            elseif ( strcmpi(fileNameSplit(1),"dct-No Particle") )
                ZZs(nCountsTot+1:nCountsTot+nCounts)=-1;
            else
                error("...unable to recognise particle in DCT file name: %s",files(iSet).name);
            end
            tStampAss=fileNameSplit(2); tStampAss(1:nCounts)=tStampAss; % time stamp: day
            tStamps(nCountsTot+1:nCountsTot+nCounts)=datetime(join(string([tStampAss(:),C{:,6}])),"InputFormat","dd-MM-yyyy HH:mm:ss");
            cyProgs(nCountsTot+1:nCountsTot+nCounts)=C{:,1};
            cyCodes(nCountsTot+1:nCountsTot+nCounts)=C{:,2};
            currs(nCountsTot+1:nCountsTot+nCounts,1)=C{:,3};
            currs(nCountsTot+1:nCountsTot+nCounts,2)=C{:,4};
            fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
            nCountsTot=nCountsTot+nCounts;
            nReadFiles=nReadFiles+1;
        end
    end
    if ( nReadFiles>0 )
        % try to return a vector array, not a row
        if ( size(tStamps,2)>size(tStamps,1) )
            tStamps=tStamps';
            cyProgs=cyProgs';
            cyCodes=cyCodes';
            ZZs=ZZs';
        end
        if ( nReadFiles>1 )
            [tStamps,currs,ids]=SortByTime(tStamps,currs); % sort by timestamps
            cyProgs=cyProgs(ids(:,1));
            cyCodes=cyCodes(ids(:,1));
            ZZs=ZZs(ids(:,1));
        end
    else
        tStamps=missing;
        cyProgs=missing;
        cyCodes=missing;
        currs=missing;
        ZZs=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
    
end

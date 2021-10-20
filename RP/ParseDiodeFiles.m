function [tStamps,counts]=ParseDiodeFiles(path2Files)
% ParseDiodeFiles         acquire data in log files of diodes (REM counters)
%
% input:
% - path2Files: path where the file(s) is located (a dir command is anyway performed).
%               All data files are associated to a single monitor.
% output:
% - tStamps (array of time stamps): time stamps of counts;
% - counts (array of floats): counts at each time stamp;
%
% file of counts must have the following format:
% - no header;
% - a line for each count; the format of the line is eg: "2021/02:13-00:17:40 CEST,13"
% - the counter is incremental: a new measurement starts at count==1;
%
% See also ParseStationaryFiles and ParsePolyMasterFiles.

    files=dir(path2Files);
    nDataSets=length(files);
    fprintf("acquring %i data sets in %s ...\n",nDataSets,path2Files);
    nReadFiles=0;
    nCountsTot=0;
    for iSet=1:nDataSets
        fileName=strcat(files(iSet).folder,"\",files(iSet).name);
        fileID = fopen(fileName,"r");
        try
            C = textscan(fileID,"%{yyyy/MM:dd-HH:mm:ss}D CEST,%d"); % RP measurements till 18/10/2021 (included)
        catch
            C = textscan(fileID,"%{yyyy/MM/dd-HH:mm:ss}D CEST,%d"); % RP measurements after 19/10/2021 (included)
        end
        fclose(fileID);
        nCounts=length(C{:,1});
        tStamps(nCountsTot+1:nCountsTot+nCounts)=C{1,1};
        counts(nCountsTot+1:nCountsTot+nCounts)=C{1,2};
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    if ( nDataSets>0 )
        % try to return a vector array, not a row
        if ( size(tStamps,2)>size(tStamps,1) )
            tStamps=tStamps';
            counts=counts';
        end
        if ( nDataSets>1 )
            [tStamps,counts,~]=SortByTime(tStamps,counts); % sort by timestamps
        end
    else
        tStamps=missing;
        counts=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

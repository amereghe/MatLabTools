function [tStamps,counts]=ParseDiodeFiles(path2Files)
    % input:
    % - path2Files: path where the file(s) is located (a dir command is anyway performed);
    % output:
    % - tStamps (array of time stamps): time stamps of counts;
    % - counts (array of floats): counts at each time stamp;
    %
    % file of counts must have the following format:
    % - no header;
    % - a line for each count; the format of the line is eg: "2021/02:13-00:17:40 CEST,13"
    % - the counter is incremental: a new measurement starts at count==1;
    files=dir(path2Files);
    nDataSets=length(files);
    fprintf("acquring %i data sets in %s...\n",nDataSets,path2Files);
    nReadFiles=0;
    nCountsTot=0;
    for iSet=1:nDataSets
        fileName=strcat(files(iSet).folder,"\",files(iSet).name);
        fileID = fopen(fileName,"r");
        C = textscan(fileID,"%{yyyy/MM:dd-HH:mm:ss}D CEST,%d");
        fclose(fileID);
        nCounts=length(C{:,1});
        tStamps(nCountsTot+1:nCountsTot+nCounts)=C{1,1};
        counts(nCountsTot+1:nCountsTot+nCounts)=C{1,2};
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    % try to return a vector array, not a row
    if ( size(tStamps,2)>size(tStamps,1) )
        tStamps=tStamps';
        counts=counts';
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

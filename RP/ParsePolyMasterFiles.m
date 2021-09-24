function [tStamps,doses]=ParsePolyMasterFiles(path2Files)
    % input:
    % - path2Files: path where the file(s) is located (a dir command is anyway performed);
    % output:
    % - tStamps (array of time stamps): time stamps of counts;
    % - counts (array of floats): counts at each time stamp;
    %
    % file of counts must have the following format:
    % - a 1-line header;
    % - a line with the integrated dose over 10 minutes; the format of the line is eg: "2021/07/23;23:04:26;PM1610 #218161;Dose Rate;0.0900 uSv/h;0.0000 uSv;0.0000 uSv;Gamma"
    % - the reported does is NOT cumulative!
    files=dir(path2Files);
    nDataSets=length(files);
    fprintf("acquring %i data sets in %s ...\n",nDataSets,path2Files);
    nReadFiles=0;
    nCountsTot=0;
    for iSet=1:nDataSets
        fileName=strcat(files(iSet).folder,"\",files(iSet).name);
        fileID = fopen(fileName,"r");
        C = textscan(fileID,'%s %s %s %s %s %s %s %s','HeaderLines',1,'Delimiter',';');
        fclose(fileID);
        nCounts=length(C{:,1});
        tStamps(nCountsTot+1:nCountsTot+nCounts)=datetime(join(string([C{:,1},C{:,2}])),"InputFormat","yyyy/MM/dd HH:mm:ss");
        temp=split(C{:,6});
        doses(nCountsTot+1:nCountsTot+nCounts)=str2double(temp(:,1));
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    if ( nDataSets>0 )
        % try to return a vector array, not a row
        if ( size(tStamps,2)>size(tStamps,1) )
            tStamps=tStamps';
            doses=doses';
        end
    else
        tStamps=missing;
        doses=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

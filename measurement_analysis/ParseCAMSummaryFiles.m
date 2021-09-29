function [cyProgs,cyCodes,BARs,FWHMs,ASYMs,INTs]=ParseCAMSummaryFiles(paths2Files)
% ParseCAMSummaryFiles        parse summary files of Cameretta (ministrip monitor)
%
% input:
% - paths2Files (array of strings): path(s) where the file(s) is located (a dir command is anyway performed).
% output:
% - cyProgs (array of strings): cycle prog associated to each event;
% - cyCodes (array of strings): cycle code associated to each event;
% - BARs (2D array of floats): baricentre of distribution [mm];
% - FWHMs (2D array of floats): FWHM of distribution [mm];
% - INTs (2D array of floats): integral of distribution [number of ions];
%
% The 2D arrays have:
% - horizontal plane in column 1;
% - vertical plane in column 2;
%
% file of counts must have the following format:
% - 1 header line;
% - a line for each cycle prog; the format of the line is eg: "6000ECC0900	-9.297985	-10.947896	35.661529	34.325630	0.398755	6.695736	2.640946E+9	2.443980E+9	195453981"

    fprintf("acquring summary data from Cameretta...\n");
    nReadFiles=0;
    nCountsTot=0;
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nDataSets=length(files);
        fprintf("...acquring %i data sets in %s ...\n",nDataSets,paths2Files(iPath));
        for iSet=1:nDataSets
            fileName=strcat(files(iSet).folder,"\",files(iSet).name);
            fileID = fopen(fileName,"r");
            C = textscan(fileID,'%s %f %f %f %f %f %f %f %f %s','HeaderLines',1);
            fclose(fileID);
            nCounts=length(C{:,1});
            cyCodes(nCountsTot+1:nCountsTot+nCounts)=C{:,1};
            for ii=1:2
                BARs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,1+ii};
                FWHMs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,3+ii};
                ASYMs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,5+ii};
                INTs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,7+ii};
            end
            cyProgs(nCountsTot+1:nCountsTot+nCounts)=C{:,10};
            fprintf("   ...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
            nCountsTot=nCountsTot+nCounts;
            nReadFiles=nReadFiles+1;
        end
    end
    if ( nReadFiles>0 )
        % try to return a vector array, not a row
        if ( size(cyProgs,2)>size(cyProgs,1) )
            cyProgs=cyProgs';
            cyCodes=cyCodes';
        end
        if ( nReadFiles>1 )
            [cyProgs,cyCodes,ids]=SortByTime(cyProgs,cyCodes); % sort by cycle progs
            BARs(:,:)=BARs(ids,:);
            FWHMs(:,:)=FWHMs(ids,:);
            ASYMs(:,:)=ASYMs(ids,:);
            INTs(:,:)=INTs(ids,:);
        end
    else
        cyProgs=missing;
        cyCodes=missing;
        BARs=missing;
        FWHMs=missing;
        ASYMs=missing;
        INTs=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

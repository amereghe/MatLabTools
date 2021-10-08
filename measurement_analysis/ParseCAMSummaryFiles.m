function [cyProgs,cyCodes,BARs,FWHMs,ASYMs,INTs]=ParseCAMSummaryFiles(paths2Files,fFormat)
% ParseCAMSummaryFiles        parse summary files of Cameretta (ministrip monitor)
%                                and DDS (nozzle)
%
% input:
% - paths2Files (array of strings): path(s) where the file(s) is located (a dir command is anyway performed).
% - fFormat [string, optional]: detector that generated the data; this
%   parameter sets formats for reading data; default: DDS
%
% output:
% - cyProgs (array of strings): cycle prog associated to each event;
% - cyCodes (array of strings): cycle code associated to each event;
% - BARs (2D array of floats): baricentre of distribution [mm];
% - FWHMs (2D array of floats): FWHM of distribution [mm];
% - INTs (2D array of floats): integral of distribution [number of ions];
%
% For the time being, the column "RippleFilter" in the DDS summary file
%   is not returned. In addition, for DDS, ASYMs are filled with zeros,
%   and INTs are repeated.
%
% The 2D arrays have:
% - horizontal plane in column 1;
% - vertical plane in column 2;
%
% file of counts must have the following format:
% - CAMeretta:
%   . 1 header line;
%   . a line for each cycle prog; the format of the line is eg: "6000ECC0900	-9.297985	-10.947896	35.661529	34.325630	0.398755	6.695736	2.640946E+9	2.443980E+9	195453981"
% - DDS:
%   . 1 header line;
%   . a line for each cycle prog; the format of the line is eg: "0A003E440900	195445867	-0.51	4.613	-0.151	5.959	835773	0"

    
    if ( ~exist('fFormat','var') ), fFormat="CAM"; end % default: CAMeretta
    if ( ~strcmpi(fFormat,"CAM") && ~strcmpi(fFormat,"DDS") )
        error("wrong indication of format of file: %s. Can only be DDS and CAM",fFormat);
    end
    sig2FWHM=2*sqrt(2*log(2));
    
    fprintf("acquring summary data from %s ...\n",fFormat);
    nReadFiles=0;
    nCountsTot=0;
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nDataSets=length(files);
        fprintf("...acquring %i data sets in %s ...\n",nDataSets,paths2Files(iPath));
        for iSet=1:nDataSets
            fileName=strcat(files(iSet).folder,"\",files(iSet).name);
            fileID = fopen(fileName,"r");
            if ( strcmpi(fFormat,"CAM") )
                C = textscan(fileID,'%s %f %f %f %f %f %f %f %f %s','HeaderLines',1);
            else % DDS
                C = textscan(fileID,'%s %s %f %f %f %f %f %f','HeaderLines',1);
            end
            fclose(fileID);
            nCounts=length(C{:,1});
            if ( strcmpi(fFormat,"CAM") )
                cyCodes(nCountsTot+1:nCountsTot+nCounts)=string(C{:,1});
                for ii=1:2
                    BARs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,1+ii};
                    FWHMs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,3+ii};
                    ASYMs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,5+ii};
                    INTs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,7+ii};
                end
                cyProgs(nCountsTot+1:nCountsTot+nCounts)=string(C{:,10});
            else % DDS
                cyCodes(nCountsTot+1:nCountsTot+nCounts)=string(C{:,1});
                cyProgs(nCountsTot+1:nCountsTot+nCounts)=string(C{:,2});
                for ii=1:2
                    BARs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,1+2*ii};            % cols 3 and 5
                    FWHMs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,2+2*ii}*sig2FWHM;  % cols 4 and 6
                    ASYMs(nCountsTot+1:nCountsTot+nCounts,ii)=0.0;
                    INTs(nCountsTot+1:nCountsTot+nCounts,ii)=C{:,7};
                end
            end
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
        cyCodes=PadCyCodes(cyCodes);
        cyCodes=UpperCyCodes(cyCodes);
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

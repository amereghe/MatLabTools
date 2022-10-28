function [measData,cyCodes,cyProgs]=ParseBeamProfiles(paths2Files,fFormat)
% ParseBeamProfiles     parses distributions recorded by CAM, DDS, GIM, PIB/PMM,
%                          QBM and SFH/SFM/SFP;
%                       for the time being, the function does not parse QIM data
%
% input:
% - paths2Files (array of strings): path(s) where the file(s) is(are)
%   located. A regexp can be given, e.g. "PRC-544-210509-1437-Z2-021B-SFM\Data-*-*-Z2-021B-SFM.csv"
% - fFormat [string, optional]: detector that generated the data; this
%   parameter sets formats for reading data; default: SFM
%
% output:
% - measData [float(max(Nx,Ny),maxColumns,2,nDataSets)]: array of data;
%   . Nx,Ny: number of hor/ver fibers;
%   . maxColumns: number of time acquisitions + values of X (first column);
%     in case of CAM/DDS, there is only an acquisition per plane;
%   . 2: planes: 1: hor; 2: ver;
%   . nDataSets: number of files;
% - cyCodes [string(nDataSets,1)]: array of cycle codes;
% - cyProgs [float(nDataSets,1)]: array of cycle progs;
%
% cyCodes and cyProgs are taken from the file name. Therefore, in case of
%   PIB/PMM data, only the latter will be available
% see also SumSpectra, IntegrateSpectra and ShowSpectra.

    %% format
    if ( ~exist('fFormat','var') ), fFormat="SFM"; end % default: SFM
    % data structure
    switch upper(fFormat)
        case "CAM"
            Nx=127; Ny=127;
            maxColumns=2;
        case "DDS"
            Nx=128; Ny=128;
            maxColumns=2;
        case "GIM"
            Nx=127; Ny=127;
            maxColumns=300;
        case {"PMM","PIB"}
            Nx=32;  Ny=32;
            maxColumns=2;
        case "QBM"
            Nx=34;  Ny=45;
            maxColumns=59;
        case {"SFH","SFM"}
            Nx=64;  Ny=64;
            maxColumns=59;
        case "SFP"
            Nx=128; Ny=128;
            maxColumns=59;
        otherwise
            error("wrong indication of format of file: %s. Can only be GIM, PMM/PIB, QBM and SFH/SFM/SFP",fFormat);
    end
    
    %% data storage
    actualDataSets=1;
    measData=NaN(max(Nx,Ny),maxColumns,2,actualDataSets);
    cyProgs=NaN(actualDataSets,1);
    cyCodes=strings(actualDataSets,1);

    %% actually parse
    for iPath=1:length(paths2Files)
        
        %% filename and extension
        switch upper(fFormat)
            case "CAM"
                tmpPath=paths2Files(iPath);
                if (~contains(tmpPath,"\profiles\"))
                    if (~endsWith(tmpPath,"\")), tmpPath=strcat(tmpPath,"\"); end
                    tmpPath=strcat(tmpPath,"profiles\");
                end
                [filepath,name,ext]=fileparts(tmpPath);
                if (strlength(name)==0), name="*_profiles"; end
                if (strlength(ext)==0), ext=".txt"; end
            case "DDS"
                tmpPath=paths2Files(iPath);
                if (~contains(tmpPath,"\Profiles\"))
                    if (~endsWith(tmpPath,"\")), tmpPath=strcat(tmpPath,"\"); end
                    tmpPath=strcat(tmpPath,"Profiles\");
                end
                [filepath,name,ext]=fileparts(tmpPath);
                if (strlength(name)==0), name="Data-*"; end
                if (strlength(ext)==0), ext=".csv"; end
            case "GIM"
                [filepath,name,ext]=fileparts(paths2Files(iPath));
                if (strlength(name)==0), name="XY_*"; end
                if (strlength(ext)==0), ext=".txt"; end
            case {"SFH","SFM","SFP"}
                [filepath,name,ext]=fileparts(paths2Files(iPath));
                if (strlength(name)==0), name="Data-*"; end
                if (strlength(ext)==0), ext=".csv"; end
            otherwise
                error("...please specify name for %s profile files",fFormat);
        end

        tmpPath=strcat(filepath,"\",name,ext);
        files=dir(tmpPath);
        nDataSets=length(files);
        fprintf("acquring %i data sets with %s format in path %s ...\n",nDataSets,upper(fFormat),tmpPath);

        nAcq=0;
        for iSet=1:nDataSets
            switch upper(fFormat)
                case "CAM"
                    nAcq=nAcq+1;
                    fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                    % check cycle prog, to guarantee continuity
                    tmp=split(files(iSet).name,"_");
                    tmpCyProg=str2num(tmp{1});
                    tmpCyCode=string(tmp{2});
                    if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                        % fast forward with NaNs
                        [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1));
                    end
                    %
                    tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
                    % x-axis values
                    measData(1:Nx,1,1)=tmp(1:Nx,1);                % fiber positions
                    measData(1:Nx,1+actualDataSets,1)=tmp(1:Nx,2); % values
                    % y-axis values
                    measData(1:Ny,1,2)=tmp(1:Ny,1);                % fiber positions
                    measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,3); % values
                case "DDS"
                    nAcq=nAcq+1;
                    fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                    % check cycle prog, to guarantee continuity
                    tmp=split(files(iSet).name,"-");
                    tmpCyProg=str2num(tmp{3});
                    tmpCyCode=string(tmp{2});
                    if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                        % fast forward with NaNs
                        [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1));
                    end
                    %
                    tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
                    % x-axis values
                    measData(1:Nx,1,1)=tmp(1:Nx,1);                % fiber positions
                    measData(1:Nx,1+actualDataSets,1)=tmp(1:Nx,2); % values
                    % y-axis values
                    measData(1:Ny,1,2)=tmp(1:Ny,3);                % fiber positions
                    measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,4); % values
                case "GIM"
                    if (strcmp(files(iSet).name,"Dati_SummaryGIM.txt") | startsWith(files(iSet).name,"Int_","IgnoreCase",true) | startsWith(files(iSet).name,"Profiles_","IgnoreCase",true))
                        % matlab does not support single char wildcard...
                        continue
                    end
                    nAcq=nAcq+1;
                    fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                    % check cycle prog, to guarantee continuity
                    tmp=split(files(iSet).name,"_");
                    tmpCyProg=str2num(tmp{2});
                    tmpCyCode=string(tmp{3});
                    if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                        % fast forward with NaNs
                        [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1));
                    end
                    %
                    tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
                    % actual number of columns in file (ie frames+1)
                    nColumns=size(tmp,2);
                    % x-axis values
                    measData(1:Nx,1:nColumns,1,actualDataSets)=tmp(1:Nx,1:nColumns); % values
                    % y-axis values
                    measData(1:Ny,1:nColumns,2,actualDataSets)=tmp(Nx+2:Nx+1+Ny,1:nColumns); % values
                    % check cycle code
                    tmpCyCode=extractBetween(tmpCyCode,5,strlength(tmpCyCode));
                case {"PMM","PIB"}
                    if (strfind(files(iSet).name,"Norm"))
                        fprintf("   ...skipping Norm file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                        continue
                    end
                    nAcq=nAcq+1;
                    fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                    % check cycle prog, to guarantee continuity
                    tmp=split(files(iSet).name,"-");
                    tmp=split(tmp{2},".");
                    tmpCyProg=str2num(tmp{1});
                    tmpCyCode=string(missing());
                    if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                        % fast forward with NaNs
                        [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1));
                    end
                    %
                    tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'MultipleDelimsAsOne',true));
                    % x-axis values
                    measData(1:Nx,1:maxColumns,1,actualDataSets)=tmp(1:Nx,1:maxColumns); % values
                    % y-axis values
                    measData(1:Ny,1:maxColumns,2,actualDataSets)=tmp(1:Ny,1+2:2+maxColumns); % values
                case {"QBM","SFH","SFM","SFP"}
                    nAcq=nAcq+1;
                    fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                    % check cycle prog, to guarantee continuity
                    tmp=split(files(iSet).name,"-");
                    tmpCyProg=str2num(tmp{3});
                    tmpCyCode=string(tmp{2});
                    if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                        % fast forward with NaNs
                        [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1));
                    end
                    %
                    tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',10,'MultipleDelimsAsOne',true));
                    % actual number of columns in file (ie frames+1)
                    nColumns=size(tmp,2);
                    % x-axis values
                    measData(1:Nx,1:nColumns,1,actualDataSets)=tmp(1:Nx,1:nColumns); % values
                    % y-axis values
                    measData(1:Ny,1:nColumns,2,actualDataSets)=tmp(Nx+2:Nx+1+Ny,1:nColumns); % values
                    % check cycle code
                    if ( strcmpi(fFormat,"SFP") || strcmpi(fFormat,"SFM") || strcmpi(fFormat,"QBM") )
                        tmpCyCode=extractBetween(tmpCyCode,5,strlength(tmpCyCode));
                    end
            end
            % store cycle prog and cycle code
            cyProgs(actualDataSets)=tmpCyProg;
            cyCodes(actualDataSets)=tmpCyCode;
            actualDataSets=actualDataSets+1;
        end
        fprintf("...acqured %i files;\n",nAcq);
    end
    
    %% post-processing
    if ( strcmpi(fFormat,"CAM") | strcmpi(fFormat,"DDS") )
        nAcquired=size(measData,2)-1;
    else
        nAcquired=size(measData,4);
    end
    fprintf("...for a total of %i cyProgs;\n",nAcquired);
    if ( nAcquired>0 )
        cyCodes=PadCyCodes(cyCodes);
        cyCodes=UpperCyCodes(cyCodes);
        if ( size(cyProgs,2)>size(cyProgs,1) )
            cyProgs=cyProgs';
        end
        if ( size(cyCodes,2)>size(cyCodes,1) )
            cyCodes=cyCodes';
        end
        % sort by cyProg
        [cyProgs,idx]=sort(cyProgs);
        if ( strcmpi(fFormat,"CAM") | strcmpi(fFormat,"DDS") )
            measData=measData(:,[1 idx'+1],:,:);
        else
            measData=measData(:,:,:,idx);
        end
        cyCodes=cyCodes(idx);
        cyProgs=string(cyProgs);
    else
        measData=missing;
        cyProgs=missing;
        cyCodes=missing;
    end
end

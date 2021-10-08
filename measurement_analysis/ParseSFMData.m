function [measData,cyCodes,cyProgs]=ParseSFMData(path2Files,fFormat)
% ParseSFMData     parses distributions recorded by GIM, PIB/PMM, QBM and SFH/SFM/SFP;
%                  for the time being, the function does not parse QIM data
%
% input:
% - path2Files [string]: path were files to be parsed are stored; it can be
%   a regexp, e.g. "PRC-544-210509-1437-Z2-021B-SFM\Data-*-*-Z2-021B-SFM.csv"
% - fFormat [string, optional]: detector that generated the data; this
%   parameter sets formats for reading data; default: SFM
%
% output:
% - measData [float(max(Nx,Ny),maxColumns,2,nDataSets)]: array of data;
%   . Nx,Ny: number of hor/ver fibers;
%   . maxColumns: number of time acquisitions + values of X (first column);
%   . 2: planes: 1: hor; 2: ver;
%   . nDataSets: number of files;
% - cyCodes [string(nDataSets,1)]: array of cycle codes;
% - cyProgs [float(nDataSets,1)]: array of cycle progs;
%
% cyCodes and cyProgs are taken from the file name. Therefore, in case of
%   PIB/PMM data, only the latter will be available
% see also SumSpectra, IntegrateSpectra and ShowSpectra.

    % default format: SFM data structure
    myFormat="SFM";
    Nx=64;         % number of horizontal fibers
    Ny=64;         % number of vertical fibers
    maxColumns=59; % number of time acquisitions + values of X (first column)
    
    if ( exist('fFormat','var') )
        % change data structure
        if ( strcmpi(fFormat,"QBM") )
            myFormat="QBM";
            Nx=34;
            Ny=45;
            maxColumns=59;
        elseif ( strcmpi(fFormat,"GIM") )
            myFormat="GIM";
            Nx=127;
            Ny=127;
            maxColumns=119;
        elseif ( strcmpi(fFormat,"PMM") || strcmpi(fFormat,"PIB") )
            myFormat="PMM";
            Nx=32;
            Ny=32;
            maxColumns=2;
        elseif ( strcmpi(fFormat,"SFP") )
            myFormat="SFP";
            Nx=128;
            Ny=128;
            maxColumns=59;
        elseif ( ~strcmpi(fFormat,"SFM") || ~strcmpi(fFormat,"SFH")  )
            error("wrong indication of format of file: %s. Can only be GIM, PMM/PIB, QBM and SFM/SFH",fFormat);
        end
    end
    
    files=dir(path2Files);
    nDataSets=length(files);
    actualDataSets=1;
    measData=zeros(max(Nx,Ny),maxColumns,2,actualDataSets);
    cyProgs=zeros(actualDataSets,1);
    cyCodes=strings(actualDataSets,1);
    fprintf("acquring %i data sets...\n",nDataSets);
    if ( strcmp(myFormat,"SFM") )
        fprintf("...SFH/SFM format...\n");
    elseif ( strcmp(myFormat,"QBM") )
        fprintf("...QBM format...\n");
    elseif ( strcmp(myFormat,"PMM") )
        fprintf("...PIB/PMM format...\n");
    elseif ( strcmp(myFormat,"GIM") )
        fprintf("...GIM format...\n");
    end
    
    for iSet=1:nDataSets
        if ( strcmpi(myFormat,"GIM") )
            if (strcmp(files(iSet).name,"Dati_SummaryGIM.txt"))
                % matlab does not support single char wildcard...
                continue
            end
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            % x-axis values
            tmp=table2array(readtable(sprintf("%s\\%s\\%s",files(iSet).folder,files(iSet).name,"XProfiles.txt"),'HeaderLines',1,'MultipleDelimsAsOne',true));
            % actual number of columns in file (ie frames+1)
            nColumns=size(tmp,2);
            measData(1:Nx,1:nColumns,1,actualDataSets)=tmp(1:Nx,1:nColumns); % values
            % y-axis values
            tmp=table2array(readtable(sprintf("%s\\%s\\%s",files(iSet).folder,files(iSet).name,"YProfiles.txt"),'HeaderLines',1,'MultipleDelimsAsOne',true));
            % actual number of columns in file (ie frames+1)
            nColumns=size(tmp,2);
            measData(1:Ny,1:nColumns,2,actualDataSets)=tmp(1:Ny,1:nColumns); % values
            % store cycle code and cycle prog
            tmp=split(files(iSet).name,"_");
            cyProgs(actualDataSets)=str2num(tmp{1});
            cyCodes(actualDataSets)=tmp{2};
        elseif ( strcmpi(myFormat,"PMM") )
            if (strfind(files(iSet).name,"Norm"))
                fprintf("   ...skipping Norm file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
                continue
            end
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'MultipleDelimsAsOne',true));
            % x-axis values
            measData(1:Nx,1:maxColumns,1,actualDataSets)=tmp(1:Nx,1:maxColumns); % values
            % y-axis values
            measData(1:Ny,1:maxColumns,2,actualDataSets)=tmp(1:Ny,1+2:2+maxColumns); % values
            % store cycle code and cycle prog
            tmp=split(files(iSet).name,"-");
            tmp=split(tmp{2},".");
            cyProgs(actualDataSets)=str2num(tmp{1});
        else
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',10,'MultipleDelimsAsOne',true));
            % actual number of columns in file (ie frames+1)
            nColumns=size(tmp,2);
            % x-axis values
            measData(1:Nx,1:nColumns,1,actualDataSets)=tmp(1:Nx,1:nColumns); % values
            % y-axis values
            measData(1:Ny,1:nColumns,2,actualDataSets)=tmp(Nx+2:Nx+1+Ny,1:nColumns); % values
            % store cycle code and cycle prog
            tmp=split(files(iSet).name,"-");
            cyProgs(actualDataSets)=str2num(tmp{3});
            if ( strcmpi(myFormat,"SFP") )
                cyCodes(actualDataSets)=extractBetween(tmp{2},5,strlength(tmp{2}));
            else
                cyCodes(actualDataSets)=tmp{2};
            end
        end
        actualDataSets=actualDataSets+1;
    end
    actualDataSets=actualDataSets-1;
    fprintf("...acqured %i files;\n",actualDataSets);
    if ( size(cyProgs,2)>size(cyProgs,1) )
        cyProgs=cyProgs';
    end
    if ( size(cyCodes,2)>size(cyCodes,1) )
        cyCodes=cyCodes';
    end
end



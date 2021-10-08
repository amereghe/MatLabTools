function [measData,cyCodes,cyProgs]=ParseDDSProfiles(path2Files,fFormat)
% ParseDDSData     parses profiles recorded by DDS (nozzle) and cameretta (mini-strip);
%
% input:
% - path2Files [string]: path were files to be parsed are stored; it can be
%   a regexp, e.g. "PRC-544-210919-1756-X0-013C-DDSF\Profiles\Data-*-*-X0-013C-DDSF.csv"
% - fFormat [string, optional]: detector that generated the data; this
%   parameter sets formats for reading data; default: DDS
%
% output:
% - measData [float(Nn,nDataSets+1,2)]: array of data;
%   . Nn: number of fibers/channels;
%   . nDataSets: number of files; the second dimension of the array
%     also contains the positions of fibers/channels x/y in the first column;
%   . 2: planes: 1: hor; 2: ver;
% - cyCodes [string(nDataSets,1)]: array of cycle codes;
% - cyProgs [float(nDataSets,1)]: array of cycle progs;
%
% cyCodes and cyProgs are taken from the file name.
% see also ParseSFMData and SumSpectra.

    % default format: DDS data structure
    myFormat="DDS";
    Nx=128;         % number of horizontal fibers
    Ny=128;         % number of vertical fibers
    
    if ( exist('fFormat','var') )
        % change data structure
        if ( strcmpi(fFormat,"CAM") )
            myFormat="CAM";
            Nx=127;
            Ny=127;
        elseif ( ~strcmpi(fFormat,"DDS") )
            error("wrong indication of format of file: %s. Can only be DDS and CAM",fFormat);
        end
    end
    
    files=dir(path2Files);
    nDataSets=length(files);
    actualDataSets=1;
    measData=zeros(max(Nx,Ny),actualDataSets,2);
    cyProgs=zeros(actualDataSets,1);
    cyCodes=strings(actualDataSets,1);
    fprintf("acquring %i data sets...\n",nDataSets);
    if ( strcmp(myFormat,"DDS") )
        fprintf("...DDS format...\n");
    elseif ( strcmp(myFormat,"CAM") )
        fprintf("...CAM(eretta) format...\n");
    end

    for iSet=1:nDataSets
        if ( strcmpi(myFormat,"DDS") )
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
            % x-axis values
            measData(1:Nx,1,1)=tmp(1:Nx,1);                % fiber positions
            measData(1:Nx,1+actualDataSets,1)=tmp(1:Nx,2); % values
            % y-axis values
            measData(1:Ny,1,2)=tmp(1:Ny,3);                % fiber positions
            measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,4); % values
            % store cycle code and cycle prog
            tmp=split(files(iSet).name,"-");
            cyProgs(actualDataSets)=str2num(tmp{3});
            cyCodes(actualDataSets)=tmp{2};
        else  % CAM(eretta)
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
            % x-axis values
            measData(1:Nx,1,1)=tmp(1:Nx,1);                % fiber positions
            measData(1:Nx,1+actualDataSets,1)=tmp(1:Nx,2); % values
            % y-axis values
            measData(1:Ny,1,2)=tmp(1:Ny,1);                % fiber positions
            measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,3); % values
            % store cycle code and cycle prog
            tmp=split(files(iSet).name,"_");
            cyProgs(actualDataSets)=str2num(tmp{1});
            if ( strlength(tmp{2})<12 )
                cyCodes(actualDataSets)=strcat("0",tmp{2});
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
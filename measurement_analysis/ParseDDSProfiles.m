function [measData,cyCodes,cyProgs]=ParseDDSProfiles(paths2Files,fFormat)
% ParseDDSData     parses profiles recorded by DDS (nozzle) and cameretta (mini-strip);
%
% input:
% - paths2Files (array of strings): path(s) where the file(s) is located (a dir command is anyway performed).
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

    if ( ~exist('fFormat','var') ), fFormat="DDS"; end % default: DDS
    if ( strcmpi(fFormat,"CAM") )
        Nx=127;
        Ny=127;
    elseif  (strcmpi(fFormat,"DDS") )
        Nx=128;         % number of horizontal fibers
        Ny=128;         % number of vertical fibers
    else
        error("wrong indication of format of file: %s. Can only be DDS and CAM",fFormat);
    end
    fprintf("acquring %s profiles ...\n",fFormat);
    
    actualDataSets=0;
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nDataSets=length(files);
        fprintf("...acquring %i data sets in %s ...\n",nDataSets,paths2Files(iPath));

        for iSet=1:nDataSets
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            actualDataSets=actualDataSets+1;
            if ( strcmpi(fFormat,"DDS") )
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
            else  % CAM(eretta)
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
            end
            cyCodes(actualDataSets)=string(tmp{2});
        end
        fprintf("...acqured %i files;\n",actualDataSets);
    end
    if ( actualDataSets>0 )
        % cyCodes<12 chars: head as many "0" as needed
        cyCodes=pad(cyCodes,12,"left","0");
        if ( size(cyProgs,2)>size(cyProgs,1) )
            cyProgs=cyProgs';
            cyCodes=cyCodes';
        end
    else
        measData=missing;
        cyProgs=missing;
        cyCodes=missing;
    end
end

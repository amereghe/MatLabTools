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
    maxColumns=2;   % number of columns per cyProg
    actualDataSets=1;
    maxColumns=2;
    measData=NaN(max(Nx,Ny),maxColumns,2,actualDataSets);
    cyProgs=NaN(actualDataSets,1);
    cyCodes=strings(actualDataSets,1);
    
    fprintf("acquring %s profiles ...\n",fFormat);
    for iPath=1:length(paths2Files)
        files=dir(paths2Files(iPath));
        nDataSets=length(files);
        fprintf("...acquring %i data sets in %s ...\n",nDataSets,paths2Files(iPath));

        nAcq=0;
        for iSet=1:nDataSets
            % check cycle prog, to guarantee continuity
            if ( strcmpi(fFormat,"DDS") )
                tmp=split(files(iSet).name,"-");
                tmpCyProg=str2num(tmp{3});
            else  % CAM(eretta)
                tmp=split(files(iSet).name,"_");
                tmpCyProg=str2num(tmp{1});
            end
            tmpCyCode=string(tmp{2});
            if ( actualDataSets>1 && tmpCyProg>cyProgs(actualDataSets-1)+1 && nAcq>0 )
                % fast forward with NaNs
                [measData,cyProgs,cyCodes,actualDataSets]=FastForwardProfileAcquisitions(measData,cyProgs,cyCodes,actualDataSets,tmpCyProg,cyProgs(actualDataSets-1),fFormat);
            end
            %
            nAcq=nAcq+1;
            fprintf("...parsing file %d/%d: %s ...\n",iSet,nDataSets,files(iSet).name);
            tmp=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
            % x-axis values
            measData(1:Nx,1,1)=tmp(1:Nx,1);                % fiber positions
            measData(1:Nx,1+actualDataSets,1)=tmp(1:Nx,2); % values
            % y-axis values
            if ( strcmpi(fFormat,"DDS") )
                measData(1:Ny,1,2)=tmp(1:Ny,3);                % fiber positions
                measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,4); % values
            else  % CAM(eretta)
                measData(1:Ny,1,2)=tmp(1:Ny,1);                % fiber positions
                measData(1:Ny,1+actualDataSets,2)=tmp(1:Ny,3); % values
            end
            % store cycle prog and cycle code
            cyProgs(actualDataSets)=tmpCyProg;
            cyCodes(actualDataSets)=tmpCyCode;
            actualDataSets=actualDataSets+1;
        end
        fprintf("...acqured %i files;\n",nAcq);
    end
    nAcquired=size(measData,4);
    if ( nAcquired>0 )
        cyCodes=PadCyCodes(cyCodes);
        cyCodes=UpperCyCodes(cyCodes);
        if ( size(cyProgs,2)>size(cyProgs,1) )
            cyProgs=cyProgs';
            cyCodes=cyCodes';
        end
        % sort by cyProg
        [cyProgs,idx]=sort(cyProgs);
        measData=measData(:,[1 idx'+1],:);
        cyCodes=cyCodes(idx);
        cyProgs=string(cyProgs);
    else
        measData=missing;
        cyProgs=missing;
        cyCodes=missing;
    end
end

function [ particles, obsPoints, nParts ] = ReadSurvivors(path2Files)
% READSURVIVORS  Read survivors from MAD-X/PTC tracking.
%
% example format of line of parsed files (argument of ID is read as well):
% *             NUMBER               TURN                  X                 PX                  Y                 PY                  T                 PT                  S                  E 
% #segment       1      32  200000       0 start                                                                         
%                   1                  0              -0.02             -0.002             -0.013             -0.006                  0            -0.0013                  0                  0
% 
% input arguments:
%   path2Files: path to files to parse;
%
% output arguments:
%   particles: table of particle coordinates;
%       the third dimension identifies the obervation point;
%   obsPoints: list of names of the obervation points;

    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
        GetColumnsAndMappingTFS("track");
    
    % acquire files
    particles=missing(); obsPoints=missing(); nParts=missing();
    for kk=1:length(path2Files)
        files=dir(path2Files(kk));
        for ii=1:length(files)
            tmpFileName=sprintf("%s\\%s",files(ii).folder,files(ii).name);
            fprintf("reading file %s ...\n",tmpFileName);
            fileID = fopen(tmpFileName,'r');
            CO6D=zeros(6,1); CO6Dnames=["XC" "PXC" "YC" "PYC" "TC" "PTC"];
            while (~feof(fileID))
                tLine=strip(fgetl(fileID));
                if (startsWith(tLine,"@"))
                    % header
                    myFields=split(tLine);
                    iCol=strcmpi(CO6Dnames,myFields{2});
                    if (any(iCol))
                        CO6D(iCol)=str2double(myFields{2});
                        fprintf("...found %s=%f in header,\n",CO6Dnames(iCol),CO6D(iCol));
                    end
                elseif (startsWith(tLine,"#"))
                    % new section
                    myFields=split(tLine);
                    nParts=ExpandMat(nParts,double(string(myFields{4})));
                    clear tmpParticles;
                    tmpParticles=cell2mat(textscan(fileID,readFormat));
                    fprintf("...acquired %d particles at %s;\n",nParts(end),myFields{end});
                    % add closed orbit
                    if (strcmpi(myFields{end},"START"))
                        for jj=1:length(CO6Dnames)
                            if (CO6D(jj)~=0.0)
                                iCol=mapping(strcmpi(colNames,extractBetween(CO6Dnames(ii),1,strlength(CO6Dnames(ii))-1)));
                                tmpParticles(:,iCol)=tmpParticles(:,iCol)+CO6D(jj);
                                fprintf("...taking into account 6D closed orbit on %s at START;\n",colNames(iCol));
                            end
                        end
                    end
                    % store in memory
                    particles=ExpandMat(particles,tmpParticles);
                    obsPoints=ExpandMat(obsPoints,string(myFields{end}));
                end
            end
            fclose(fileID);
        end
    end
    fprintf("...done with parsing files;\n");
    
    % compact storage
    uObsPoints=unique(obsPoints);
    if (length(uObsPoints)~=length(obsPoints))
        fprintf("...compacting from %d data sets to %d (unique obs points);\n",length(obsPoints),length(uObsPoints));
        readParticles=particles; readObsPoints=obsPoints; readNparts=nParts;
        clear particles obsPoints nParts;
        particles=missing(); obsPoints=missing(); nParts=missing();
        for ii=1:length(uObsPoints)
            iObs=find(strcmp(readObsPoints,uObsPoints(ii)));
            clear tmpParticles;
            nParts=ExpandMat(nParts,sum(readNparts(iObs)));
            tmpParticles=NaN(nParts(end),length(colNames));
            jRead=0;
            for jj=1:length(iObs)
                tmpParticles(jRead+1:jRead+readNparts(iObs(jj)),:)=readParticles(1:readNparts(iObs(jj)),:,iObs(jj));
                jRead=jRead+readNparts(iObs(jj));
            end
            particles=ExpandMat(particles,tmpParticles);
            obsPoints=ExpandMat(obsPoints,uObsPoints(ii));
        end
        fprintf("...done with compacting data storage;\n");
    end
end
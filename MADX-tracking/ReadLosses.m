function [ losses, nLosses ] = ReadLosses(path2Files,nInitial,delays,nExpected)
% READLOSSES  Read losses from MAD-X tracking.
%
% example format of line of parsed files:
%                 NUMBER, TURN, X, PX, Y, PY, T, PT, S, E, ELEMENT
%
% [ losses, nLosses ] = ReadLosses(path2Files,nInitial,delays)
%
% input arguments:
%   path2Files: path to files to parse;
%               example: "delay_%02u\\beam2track*\\losses.tfs"
%
% optional input arguments:
%   nInitial: number of starting conditions of the tracking giving rise to
%        the losses parsed in a specific file, to be added to particle IDs;
%   delays: turn delays to be added to turn number;
%   nExpected: expected number of initial conditions;
%              if given, a check on the number of conditions parsed is
%              performed;
%
% output arguments:
%   losses: cell array of particle coordinates;
%   nLosses: total number of particles read

    losses=[];
    nLosses=0;
    if ( exist('delays','var') )
        kMax=length(delays);
    else
        kMax=1;
    end
    if ( exist('nInitial','var') )
        cumInitial=cumsum(nInitial);
    end
    for kk=1:kMax
        if ( exist('delays','var') )
            files=dir(sprintf(path2Files,delays(kk)));
        else
            files=dir(path2Files);
        end
        for ii=1:length(files)
            lossesFileName=sprintf("%s\\%s",files(ii).folder,files(ii).name);
            fprintf("reading file %s ...\n",lossesFileName);
            fileID = fopen(lossesFileName,'r');
            tmpLosses = textscan(fileID,'%f %f %f %f %f %f %f %f %f %f %s','HeaderLines',8);
            fclose(fileID);
            if ( exist('delays','var') )
                tmpLosses{2}=tmpLosses{2}+delays(kk);
            end
            if ( exist('nInitial','var') )
                if ( ii>1 )
                    tmpLosses{1}=tmpLosses{1}+cumInitial(ii-1);
                end
            end
            nLosses=nLosses+length(tmpLosses{1});
            if (length(losses)==0)
                losses=tmpLosses;
            else
                for jj=1:length(losses)
                    losses{jj}=[ losses{jj} ; tmpLosses{jj} ];
                end
            end
        end
    end
    fprintf("...acquired %u particle losses; \n",nLosses);
    
    if ( exist('nExpected','var') )
        if ( nLosses > nExpected )
            warning('...something wrong: I was expecting at most %u points whereas I have parsed %u',nExpected,nLosses);
        end
    end
end
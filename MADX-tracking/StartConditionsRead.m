function [ particles, nInitial, nTot ] = StartConditionsRead(path2Files,nExpected,tracker)
% STARTCONDITIONSREAD  Read starting conditions of MAD-X/PTC tracking.
%
% example format of line of parsed files (argument of ID is read as well):
%                 START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0;
%                 PTC_START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0;
% for the time being:
%     no empty lines;
%     no MAD-X comments;
%     a line heading with 'return' is skipped;
%
% input arguments:
%   path2Files: path to files to parse;
% optional input arguments:
%   nExpected: expected number of initial conditions;
%              if given, a check on the number of conditions parsed is
%              performed;
%   tracker: MADX, PTC
%
% output arguments:
%   particles: cell array of particle coordinates;
%   nInitial: array of cumulative number of particles;
%   nTot: total number of particles read

    if ( ~exist('nExpected','var') ), nExpected=missing(); end
    if ( ~exist('tracker','var') ), tracker="MADX"; end
    myFmt=StartConditionsFormat(tracker);
    particles=[];
    files=dir(path2Files);
    nInitial=[];
    for ii=1:length(files)
        tmpFileName=sprintf("%s\\%s",files(ii).folder,files(ii).name);
        fprintf("reading file %s ...\n",tmpFileName);
        fileID = fopen(tmpFileName,'r');
        tmpParticles = textscan(fileID,myFmt,'TreatAsEmpty','return;');
        nInitial=[ nInitial length(tmpParticles{1}) ];
        fclose(fileID);
        if (length(particles)==0)
            particles=tmpParticles;
        else
            for jj=1:length(particles)
                particles{jj}=[ particles{jj} ; tmpParticles{jj} ];
            end
        end
    end
    nTot=sum(nInitial);
    fprintf("...acquired %u starting conditions; \n",nTot);
    if ( ~ismissing(nExpected) )
        if ( nTot ~= nExpected )
            warning('...something wrong: I was expecting %u points whereas I have parsed %u',nExpected,nTot);
        else
            fprintf('...as expected!\n');
        end
    end

end
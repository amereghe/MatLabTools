function [tStamps,counts]=ParseDiodeFiles(path2Files,lCollapse)
% ParseDiodeFiles         acquire data in log files of diodes (REM counters)
%
% input:
% - path2Files: path where the file(s) is located (a dir command is anyway performed).
%               All data files are associated to a single monitor.
% - lCollapse: boolean, triggering the collapsing of parsed data to
%               available timestamps. This functionality can be useful
%               whenever the data set has more than a count per time
%               division, such that the number of entries can be reduced.
% output:
% - tStamps (array of time stamps): time stamps of counts;
% - counts (array of floats): counts at each time stamp;
%
% file of counts must have the following format:
% - no header;
% - a line for each count; the format of the line is eg: "2021/02:13-00:17:40 CEST,13"
% - the counter is incremental: a new measurement starts at count==1;
%
% See also ParseStationaryFiles and ParsePolyMasterFiles.

    if ( ~exist('lCollapse','var') ), lCollapse=false; end
    files=dir(path2Files);
    nDataSets=length(files);
    fprintf("acquring %i data sets in %s ...\n",nDataSets,path2Files);
    nReadFiles=0;
    nCountsTot=0;
    for iSet=1:nDataSets
        fileName=strcat(files(iSet).folder,"\",files(iSet).name);
        fileID = fopen(fileName,"r");
        try
            C = textscan(fileID,"%{yyyy/MM:dd-HH:mm:ss}D CEST,%d"); % RP measurements till 18/10/2021 (included)
        catch
            frewind(fileID);
            C = textscan(fileID,"%{yyyy/MM/dd-HH:mm:ss}D CEST,%d"); % RP measurements after 19/10/2021 (included)
        end
        fclose(fileID);
        nCounts=min(length(C{:,1}),length(C{:,2})); % try to catch the case where there are empty lines at the end, not correctly parsed
        ttStamps=C{1,1}; ttStamps=ttStamps(1:nCounts);
        tCounts=C{1,2}; tCounts=tCounts(1:nCounts);
        if ( nCountsTot==0 )
            % first data set: simply acquire data
            tStamps=ttStamps;
            counts=tCounts;
        else
            % insert new data in proper position
            [indCopy,iStart,iStop]=GetInsIndicesTimes(ttStamps,tStamps);
            % - shift existing data
            if ( iStart<nCountsTot )
                tStamps(indCopy)=tStamps;
                counts(indCopy)=counts;
            end
            % - insert new data
            tStamps(iStart:iStop)=ttStamps;
            counts(iStart:iStop)=tCounts;
        end
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    if ( nDataSets>0 )
        % try to return a vector array, not a row
        if ( size(tStamps,2)>size(tStamps,1) )
            tStamps=tStamps';
            counts=counts';
        end
        if ( nDataSets>1 )
            [tStamps,counts,~]=SortByTime(tStamps,counts); % sort by timestamps
        end
        if ( lCollapse )
            oldLength=length(tStamps);
            GC=[]; GR=[];
            % keep original structure of resets
            iOnes=find(counts==1);
            for iOne=1:length(iOnes)
                if ( iOne==length(iOnes) )
                    % last segment
                    [tmpGC,tmpGR]=groupcounts(tStamps(iOnes(end):end));
                elseif ( iOne==1 & iOnes(iOne)>1 )
                    % before first segment
                    [tmpGC,tmpGR]=groupcounts(tStamps(1:iOnes(iOne)-1));
                else
                    [tmpGC,tmpGR]=groupcounts(tStamps(iOnes(iOne):iOnes(iOne+1)-1));
                end
                GC=[GC cumsum(tmpGC)']; GR=[GR tmpGR'];
            end
            clear counts tStamps;
            counts=GC'; tStamps=GR';
            newLength=length(tStamps);
            warning("...collapsed raw data: from %d entries to %d entries;",oldLength,newLength);
        end
    else
        tStamps=missing;
        counts=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

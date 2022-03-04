function [tStamps,doses,means,maxs,mins]=ParseStationaryFiles(path2Files,lCumul)
% ParseStationaryFiles         acquire data in log files of monitors in stationary
%                              stations (both neutron and gamma monitors)
% 
% input:
% - path2Files: path where the file(s) is located (a dir command is anyway performed);
% - lCumul (boolean, optional): when parsing more than a file, cumulate all
%   values, as if all data were actually read from a single file;
% output:
% - tStamps (array of time stamps): time stamps of dose values;
% - doses (array of floats): dose values at each time stamp;
% - means (array of floats): average dose at each time stamp;
% - maxs (array of floats): max dose at each time stamp;
% - mins (array of floats): min dose at each time stamp;
%
% file of counts must have the following format:
% - 9 lines of header;
% - a line for each dose event; the format of the line is eg: "12.09.21;03:21:10;0.000E+00;0.000E+00;0.000E+00;3.167E-04;100;0;No Alarm;"
% - the counter is incremental;
%
% See also ParseDiodeFiles and ParsePolyMasterFiles
    if ( ~exist('lCumul','var') ), lCumul=false; end
    files=dir(path2Files);
    nDataSets=length(files);
    fprintf("acquring %i data sets in %s ...\n",nDataSets,path2Files);
    nReadFiles=0;
    nCountsTot=0;
    for iSet=1:nDataSets
        fileName=strcat(files(iSet).folder,"\",files(iSet).name);
        fileID = fopen(fileName,"r");
        C = textscan(fileID,'%s %s %f %f %f %f %d %d %s','HeaderLines',9,'Delimiter',';');
        fclose(fileID);
        nCounts=length(C{:,1});
        ttStamps=datetime(join(string([C{:,1},C{:,2}])),"InputFormat","dd.MM.yy HH:mm:ss");
        tMeans=C{:,3};
        tMaxs=C{:,4};
        tMins=C{:,5};
        tDoses=C{:,6};
        if ( nCountsTot==0 )
            % first data set: simply acquire data
            tStamps=ttStamps;
            means=tMeans;
            maxs=tMaxs;
            mins=tMins;
            doses=tDoses;
        else
            % insert new data in proper position
            [indCopy,iStart,iStop]=GetInsIndicesTimes(ttStamps,tStamps);
            % - shift existing data
            if ( iStart<nCountsTot )
                tStamps(indCopy)=tStamps;
                means(indCopy)=means;
                maxs(indCopy)=maxs;
                mins(indCopy)=mins;
                doses(indCopy)=doses;
            end
            % - insert new data
            tStamps(iStart:iStop)=ttStamps;
            means(iStart:iStop)=tMeans;
            maxs(iStart:iStop)=tMaxs;
            mins(iStart:iStop)=tMins;
            doses(iStart:iStop)=tDoses;
            % - cumulative dose
            if ( lCumul )
                if ( iStart<nCountsTot ), doses(iStop+1:end)=doses(iStop+1:end)+tDoses(end); end
                if ( iStart>1 ), doses(iStart:iStop)=doses(iStart:iStop)+doses(iStart-1); end
            end
        end 
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    if ( nDataSets>0 )
        % try to return a vector array, not a row
        if ( size(tStamps,2)>size(tStamps,1) )
            tStamps=tStamps';
            doses=doses';
            means=means';
            mins=mins';
            maxs=maxs';
        end
        if ( nDataSets>1 )
            [tStamps,doses,ids]=SortByTime(tStamps,doses); % sort by timestamps
            means=means(ids);
            mins=mins(ids);
            maxs=maxs(ids);
        end
    else
        tStamps=missing;
        doses=missing;
        means=missing;
        mins=missing;
        maxs=missing;
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

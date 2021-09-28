function [tStamps,doses,means,maxs,mins]=ParseStationaryFiles(path2Files)
% ParseStationaryFiles         acquire data in log files of monitors in stationary
%                              stations (both neutron and gamma monitors)
%
% input:
% - path2Files: path where the file(s) is located (a dir command is anyway performed);
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
        tStamps(nCountsTot+1:nCountsTot+nCounts)=datetime(join(string([C{:,1},C{:,2}])),"InputFormat","dd.MM.yy HH:mm:ss");
        means(nCountsTot+1:nCountsTot+nCounts)=C{:,3};
        maxs(nCountsTot+1:nCountsTot+nCounts)=C{:,4};
        mins(nCountsTot+1:nCountsTot+nCounts)=C{:,5};
        doses(nCountsTot+1:nCountsTot+nCounts)=C{:,6};
        nCountsTot=nCountsTot+nCounts;
        fprintf("...acquired %d entries in file %s...\n",nCounts,files(iSet).name);
        nReadFiles=nReadFiles+1;
    end
    % try to return a vector array, not a row
    if ( size(tStamps,2)>size(tStamps,1) )
        tStamps=tStamps';
        doses=doses';
        means=means';
        mins=mins';
        maxs=maxs';
    end
    fprintf("...acqured %i files, for a total of %d entries;\n",nReadFiles,nCountsTot);
end

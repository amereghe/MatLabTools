function tfsTable = ParseTfsTable(fileNames,whichTFS,genBy)
% ParseTfsTable     read TFS table from file.
%
% The function can read multiple files at the same time.
%
% tfsTable = ParseTfsTable(fileNames,whichTFS,nHeader)
%
% input arguments:
%   fileNames: name of files with optics data (can contain fullpath).
%              Please make sure that the strings are defined within double
%              quotes, not single quotes!
%   whichTFS: type of TFS table, determining the format to be read.
%             For the format of the file, please see
%             GetColumnsAndMappingTFS.
%
% ouput arguments:
%   tfsTable: table data. A cell array is returned, where the first index is
%             the column number. If more than a file has to be parsed, a cell
%             matrix is returned, where the first index is the optics ID
%             and the second one the column.
%
% optional input arguments:
%   genBy: format of the table:
%       'TWISS': a TFS table as generated by a MADX TWISS command;
%       'SCAN': a TFS table as generated by a current scan;
%       'CURR': a TFS table listing scan currents;
%   Nota Bene: the column names and formats are considered as part of the
%            header;
% 
% See also GetColumnsAndMappingTFS, ParseOpticsFileHeader, GetAperture, PlotLattice.
    
    if (~exist("genBy","var") | ismissing(genBy))
        if (strcmpi(whichTFS,"CURR"))
            genBy="SCAN";
        else
            genBy="TWISS";
        end
    end
    if (strcmpi(whichTFS,"CURR"))
        nHeader=7;
    else
        switch upper(genBy)
            case "TWISS"
                nHeader=48; % 52; % 48;
            case "PTC_TWISS"
                nHeader=90;
            case "SCAN"
                nHeader=1;
            otherwise
                error("How was the .tfs table generated (TWISS/SCAN)? %s NOT recognised!",genBy);
        end
    end
    
    if ( length(fileNames)==1 )
        fprintf('parsing %s file %s generated by %s ...\n',whichTFS,fileNames,genBy);
        % - get format of the file
        if (strcmpi(whichTFS,"CURR"))
            [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                GetColumnsAndMappingTFS(whichTFS,genBy,fileNames);
        else
            [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                GetColumnsAndMappingTFS(whichTFS,genBy);
        end
        % - actually parse file
        fileID = fopen(fileNames,'r');
        tfsTable = textscan(fileID,readFormat,'HeaderLines',nHeader);
        fclose(fileID);
    else
        tfsTable=[];
        for iFileName=1:length(fileNames)
            tmpTfsTable = ParseTfsTable(fileNames(iFileName),whichTFS,genBy);
            tfsTable=[ tfsTable ; tmpTfsTable ];
        end
        fprintf('...acquired %i %s files.\n',length(fileNames),whichTFS);
    end
    
    fprintf('...done.\n');
    
end
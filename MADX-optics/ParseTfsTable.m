function tfsTable = ParseTfsTable(fileNames,whichTFS,nHeader)
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
%   nHeader: number of header lines;
%            if not specified, the default value (i.e. 48) is used;
%   Nota Bene: the column names and formats are considered as part of the
%            header;
% 
% See also GetColumnsAndMappingTFS, ParseOpticsFileHeader, GetAperture, PlotLattice.
    
    nHeaderUsr=48;
    if ( exist('nHeader','var') )
        nHeaderUsr=nHeader;
    end
    
    % get format of the file
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
        GetColumnsAndMappingTFS(whichTFS);
    
    if ( length(fileNames)==1 )
        fprintf('parsing %s file %s ...\n',whichTFS,fileNames);
        fileID = fopen(fileNames,'r');
        tfsTable = textscan(fileID,readFormat,'HeaderLines',nHeaderUsr);
        fclose(fileID);
    else
        tfsTable=[];
        for fileName=fileNames
            tmpTfsTable = ParseTfsTable(fileName,whichTFS,nHeaderUsr);
            tfsTable=[ tfsTable ; tmpTfsTable ];
        end
        fprintf('...acquired %i %s files.\n',length(fileNames),whichTFS);
    end
    
    fprintf('...done.\n');
    
end
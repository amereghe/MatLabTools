function [Qx,Qy,DQx,DQy,Laccel,headerNames,headerValues] = ...
    ParseTfsTableHeader(fileNames,nHeader)
% ParseTfsTableHeader  read header of TFS file.
% 
% The function returns all the names and values of the parameters listed
%     in the header of a TFS table by MAD-X.
% The format of the header is:
%     @ NAME VALUE FORMAT
% Some relevant parameters are returned explicitly.
% The function can read multiple files at the same time.
%
% [Qx,Qy,DQx,DQy,Laccel,headerNames,headerValues] = 
%                          ParseTfsTableHeader(fileNames,nHeader)
%
% input arguments:
%   fileNames: name of files with TFS table (can contain fullpath);
%              Please make sure that the strings are defined within double
%              quotes, not single quotes!
%
% ouput arguments:
%   Qx,Qy: horizontal and vertical tunes;
%   DQx,DQy: horizontal and vertical chromaticity;
%   Laccel: length of beam line;
%   headerNames,headerValues: arrays storing field name and value of each
%               header line. Returned for user convenience;
%
% optional input arguments:
%   nHeader: number of header lines;
%            if not specified, the default value (i.e. 48) is used;
%   Nota Bene: the column names and formats are considered as part of the
%            header;
% 
% See also ParseTfsTable.
    
    nHeaderUsr=48;
    if ( exist('nHeader','var') )
        nHeaderUsr=nHeader;
    end
    switch nHeaderUsr
        case{48}
            % first 4 lines of general text
            iStart01=1;
            iStop01=4;    
            % part of header with actual data
            iStart02=5;
            iStop02=42;    
            % additional 4 lines of general text
            iStart03=43;
            iStop03=46;
        otherwise
            error('unknown number of header lines!');
            return
    end
    
    if ( length(fileNames)==1 )
        fid = fopen(fileNames,'r');
        headerNames=[];
        headerValues=[];
        for ii = iStart01:iStop01
            % text data
            tmp = textscan(fgetl(fid),'@ %s %s %s');
            % headerNames=[headerNames tmp{1}];
            % headerValues=[headerValues tmp{3}];
        end
        for ii = iStart02:iStop02
            % real data
            tmpLine=fgetl(fid);
            tmp = textscan(tmpLine,'@ %s %s %f'); 
            headerNames=[headerNames tmp{1}];
            headerValues=[headerValues tmp{3}];
        end
        for ii = iStart03:iStop03
            % text data
            tmpLine=fgetl(fid);
            tmp = textscan(tmpLine,'@ %s %s %s');
            % headerNames=[headerNames tmp{1}];
            % headerValues=[headerValues tmp{2}];
        end
        fclose(fid);

        Qx=headerValues(find(strcmp(headerNames,'Q1')));
        Qy=headerValues(find(strcmp(headerNames,'Q2')));
        DQx=headerValues(find(strcmp(headerNames,'DQ1')));
        DQy=headerValues(find(strcmp(headerNames,'DQ2')));
        Laccel=headerValues(find(strcmp(headerNames,'LENGTH')));
    else
        Qx=[];
        Qy=[];
        DQx=[];
        DQy=[];
        Laccel=[];
        headerNames=[];
        headerValues=[];
        for fileName=fileNames
            [tmpQx,tmpQy,tmpDQx,tmpDQy,tmpLaccel,tmpHeaderNames,tmpHeaderValues] = ...
                ParseTfsTableHeader(fileName,nHeaderUsr);
            Qx=[ Qx tmpQx ];
            Qy=[ Qy tmpQy ];
            DQx=[ DQx tmpDQx ];
            DQy=[ DQy tmpDQy ];
            Laccel=[ Laccel tmpLaccel ];
            headerNames=[ headerNames ; tmpHeaderNames ];
            headerValues=[ headerValues ; tmpHeaderValues ];
        end
        fprintf('...acquired the header of %i files.\n',length(fileNames));
    end
end
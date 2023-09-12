function [Qx,Qy,DQx,DQy,Laccel,headerNames,headerValues] = ...
    ParseTfsTableHeader(fileNames)
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
% See also ParseTfsTable.
    
    if ( length(fileNames)==1 )
        myGets=[ "Q1" "Q2" "DQ1" "DQ2" "LENGTH" ];
        myNums=NaN(size(myGets));
        headerNames=[];
        headerValues=[];
        fid = fopen(fileNames,'r');
        while (~feof(fid))
            tmpL=fgetl(fid);
            if (startsWith(tmpL,"@"))
                tmp = textscan(tmpL,'@ %s %s %s');
                myMatch = strcmpi(myGets,tmp{1});
                if (any(myMatch)), myNums(myMatch)=str2double(tmp{3}); end
                if (~startsWith(tmp{3},'"'))
                    headerNames=[ headerNames tmp{1} ];
                    headerValues=[ headerValues tmp{3} ];
                end
            else
                break
            end
        end
        fclose(fid);
        Qx=myNums(strcmpi(myGets,"Q1"));
        Qy=myNums(strcmpi(myGets,"Q2"));
        DQx=myNums(strcmpi(myGets,"DQ1"));
        DQy=myNums(strcmpi(myGets,"DQ2"));
        Laccel=myNums(strcmpi(myGets,"LENGTH"));
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
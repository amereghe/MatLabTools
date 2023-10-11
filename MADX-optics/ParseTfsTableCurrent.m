function [myTable,myColNames,MagNames,iMagNames]=ParseTfsTableCurrent(fileName)
    myDelimiter=",";
    %% get header from first line
    fid=fopen(fileName,'r');
    tmpLine=fgetl(fid);
    fclose(fid);
    % - crunch columns
    myColNames=string(split(tmpLine,myDelimiter));
    MagNames=[]; iMagNames=[];
    for ii=1:length(myColNames)
        [myName,myUnit]=DecodeColumn(myColNames(ii));
        if (startsWith(upper(myName),"I_"))
            MagNames=[ MagNames extractAfter(upper(myName),"I_") ];
            iMagNames=[ iMagNames ii ];
        end
    end
    %% get data
    myTable=readmatrix(fileName,'HeaderLines',1,'Delimiter',myDelimiter,'FileType','text');
end

function [myName,myUnit]=DecodeColumn(myColHeadIN)
    myColHead=myColHeadIN;
    if (startsWith(myColHead,"#"))
        myColHead=split(myColHead,"#");
        myColHead=myColHead(2);
    end
    tmp=split(myColHead,"[");
    myName=tmp(1);
    tmp=split(tmp(2),"]");
    myUnit=tmp(1);
end

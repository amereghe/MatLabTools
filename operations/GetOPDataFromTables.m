function myData=GetOPDataFromTables(FileName,sheetName)
% GetOPDataFromTables     get operational settings of magnets from tables
% used in operations, e.g. table for rampgen or table of LGEN currents.
    tmpFile=dir(FileName);
    if ( length(tmpFile)>1 )
        error("Path %s is not a single file!",FileName);
    elseif ( length(tmpFile)<1 )
        error("File %s does not exist!",FileName);
    end
    fprintf("acquring data from file %s in folder %s...\n",tmpFile(1).name,tmpFile(1).folder);
    if ( exist('sheetName','var') )
        myData=readcell(sprintf("%s\\%s",tmpFile(1).folder,tmpFile(1).name),"Sheet",sheetName);
    else
        myData=readcell(sprintf("%s\\%s",tmpFile(1).folder,tmpFile(1).name));
    end
end

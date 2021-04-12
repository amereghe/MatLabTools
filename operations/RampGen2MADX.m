function RampGen2MADX(rampFileName,MADXFileName,rampSheetName)
% RampGen2MADX       convert the table used by RampGen into the MADX format
    % parse data in rampGen table
    if ( exist('rampSheetName','var') )
        rampGenData = GetOPDataFromTables(rampFileName,rampSheetName);
    else
        rampGenData = GetOPDataFromTables(rampFileName);
    end
    nCols=size(rampGenData,2);
    
    % replace characters in header that will cause MADX to error
    headers=string(rampGenData(1,:));
    old=[ "(" ")" "[" "]" "{" "}" "-" " " ];
    new=[ " " ""  " " ""  " " ""  "_" ""  ];
    for ii=1:length(old)
        headers = strrep(headers,old(ii),new(ii));
    end

    % build numerical table
    myTable=zeros(size(rampGenData,1)-1,size(rampGenData,2));
    myTable(:,2:end)=cell2mat(rampGenData(2:end,2:end));
    % replace CyCodes with an increasing ID
    headers(1,1)="ID";
    myTable(:,1)=1:size(rampGenData,1)-1;
    
    % dump data in format readable by MADX
    myTitle="myTable";
    headerTypes=strings(1,nCols);
    headerTypes(:)="%le";
    ExportMADXtable(MADXFileName,"",myTable,headers,headerTypes);
end

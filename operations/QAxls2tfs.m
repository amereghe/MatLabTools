function QAxls2tfs(iFileName,oFileName)
    if (~exist("oFileName","var"))
        [tmpDir,tmpNam,tmpExt]=fileparts(iFileName);
        oFileName=strcat(tmpDir,"/",tmpNam,".tfs");
    end
    fprintf("Converting QA file %s into TFS-like file %s ...\n",iFileName,oFileName);
    
    %% get data and store it
    myData=readcell(iFileName);
    PSNames=string(myData(2:end,1));
    currValues=cell2mat(myData(2:end,3:end));
    
    %% convert to .tfs format
    headers=compose("%s_A",PSNames);
    headerTypes=strings(1,length(headers));
    headerTypes(:)="%le";
    myTitle=sprintf("from %s",iFileName);
    myTable=currValues';
    ExportMADXtable(oFileName,myTitle,myTable,headers,headerTypes);

    %%
    fprintf("...done;\n");
end

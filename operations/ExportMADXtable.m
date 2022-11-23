function ExportMADXtable(FileName,title,myTable,headers,headerTypes)
% ExportMADXtable       save a MatLab table into a MADX table file
    fprintf("saving data to file %s...\n",FileName);
    T=now;
    % - replace characters in header that will cause MADX to error
    old=[ "(" ")" "[" "]" "{" "}" "-" " " ];
    new=[ "-" ""  "-" ""  "-" ""  "_" ""  ];
    for ii=1:length(old)
        headers = strrep(headers,old(ii),new(ii));
    end
    
    fileID = fopen(FileName,'w');
    % - MADX table header
    writeMADXHeaderLine(fileID,"TYPE","TWISS");
    writeMADXHeaderLine(fileID,"TITLE",title);
    writeMADXHeaderLine(fileID,"ORIGIN","MatLab");
    writeMADXHeaderLine(fileID,"DATE",datestr(T,'dd/mm/yy'));
    writeMADXHeaderLine(fileID,"TIME",datestr(T,'hh.mm.ss'));
    % - column names
    fprintf(fileID,"*");
    fprintf(fileID," %-18s",headers);
    fprintf(fileID,"\n");
    % - column types
    fprintf(fileID,"$");
    fprintf(fileID," %-18s",headerTypes);
    fprintf(fileID,"\n");
    % - actual data
    for ii=1:size(myTable,1)
        fprintf(fileID,"  ");
        fprintf(fileID," %-18.10g",myTable(ii,:));
        fprintf(fileID,"\n");
    end
    fclose(fileID);
end

function writeMADXHeaderLine(fileID,what,content)
    fprintf(fileID,"@ %-16s %%%02is ""%s""\n",what,strlength(content),content);
end

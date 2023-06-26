function [data,header]=ParseRMTfsTable(TFSfileNames)
% ParseRMTfsTable                to acquire data from a MADX output file
%                                   containing data to fit RMs
%
% example of header and data:
%   brho[tm],bp[mm],i[a]:h2_019a_ceb,hkick[rad]:h2_019a_ceb,
%         x[m]:h2_025b_sfh,y[m]:h2_025b_sfh,
%         x[m]:he_010b_qpp,y[m]:he_010b_qpp,
%         x[m]:he_012b_sfp,y[m]:he_012b_sfp
    nFiles=length(TFSfileNames);
    for iFile=1:nFiles
        % parse data
        fprintf("parsing file %s (%d/%d) ...\n",TFSfileNames(iFile),iFile,nFiles);
        tmpData=readmatrix(TFSfileNames(iFile),"FileType","text","NumHeaderLines",1,"Delimiter",",");
        % parse header
        fid=fopen(TFSfileNames(iFile),"r"); myHeader=string(fgets(fid)); fclose(fid);
        tmpHeader=split(erase(strtrim(myHeader),"#"),",");
        fprintf("...acquired %gx%g data;\n",size(tmpData));
        % store data
        if (iFile==1)
            % store all data
            data=tmpData;
            header=tmpHeader;
        else
            % append only new data
            % - common columns
            [com,ia,ib]=intersect(header,tmpHeader,"stable");
            nCols=size(data,2);
            nAdd=length(tmpHeader)-length(ib);
            ids=1:length(tmpHeader); ids(ib)=[];
            data(:,nCols+1:nCols+nAdd)=tmpData(:,ids);
            header(nCols+1:nCols+nAdd)=tmpHeader(ids);
        end
    end
    fprintf("...for a total of %gx%g data;\n",size(data));
end

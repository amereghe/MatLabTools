function SaveBeamProfileSummaryFile(oFileName,BARs,FWHMs,INTs,cyCodes,cyProgs,qFormat,ADDs)
    if ( ~exist("qFormat","var") ), qFormat="DDS"; end
    fprintf("saving data to %s-like summary file %s ...\n",upper(qFormat),oFileName);
    
    nAcquisitions=size(FWHMs,1);
    switch upper(qFormat)
        case "CAM"
            C=cell(nAcquisitions+1,10);
            if ( ~exist("ADDs","var") ), ADDs=zeros(nAcquisitions,2); end
            % header
            C(1,:)=cellstr(["Cycle Code" "Baricentro X" "Baricentro Y" "FWHM FIT X" "FWHM FIT Y" "Asymmetry X" "Asymmetry Y" "Integrale1" "Integrale2" "Cycle Prog"]);
            % data
            C(2:end,1)=cellstr(cyCodes); C(2:end,10)=cellstr(cyProgs);
            C(2:end,2:3)=num2cell(BARs); C(2:end,4:5)=num2cell(FWHMs); C(2:end,6:7)=num2cell(ADDs);
            C(2:end,8:9)=num2cell(INTs); % asymmetries
        case "DDS"
            C=cell(nAcquisitions+1,8);
            if ( ~exist("ADDs","var") ), ADDs=zeros(nAcquisitions,1); end
            sig2FWHM=2*sqrt(2*log(2));
            % header
            C(1,:)=cellstr(["#CycleCode" "CycleProg" "Bar X" "Sigma X" "Bar Y" "Sigma Y" "Integral" "RippleFilter"]);
            % data
            C(2:end,1)=cellstr(cyCodes); C(2:end,2)=cellstr(cyProgs);
            C(2:end,[3 5])=num2cell(BARs); C(2:end,[4 6])=num2cell(FWHMs/sig2FWHM); C(2:end,7)=num2cell(mean(INTs,2));
            C(2:end,8)=num2cell(ADDs); % ripple filter flag
        case "GIM"
            C=cell(nAcquisitions+1,8); % ADDs is ignored
            sig2FWHM=2*sqrt(2*log(2));
            % header
            C(1,:)=cellstr(["Cycle_Prog" "Cycle_Code" "X_Spill_Pos" "X_Spill_Sigma" "Y_Spill_Pos" "Y_Spill_Sigma" "1mm_Intensity" "5mm_Intensity"]);
            % data
            C(2:end,1)=cellstr(cyProgs); C(2:end,2)=cellstr(strcat("0000",cyCodes));
            C(2:end,[3 5])=num2cell(BARs); C(2:end,[4 6])=num2cell(FWHMs/sig2FWHM); C(2:end,7:8)=num2cell(INTs);
        otherwise
            error("requested format unknow: %s (either CAM or DDS or GIM)",qFormat);
    end

    % write to file
    writecell(C,oFileName,"Delimiter","\t");
    fprintf("...done.\n");
    
end

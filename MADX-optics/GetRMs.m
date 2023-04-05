function [RMs,unNomParVals,Brhos]=GetRMs(data,header,lShow,xName,yName,nominalParName,actualParName)
% iColPar,iColXs,iColYs,unNomParVals,Brhos,lShow)
    %% preliminary checks
    if (~exist("lShow","var")), lShow=true; end
    if (~exist("xName","var")), xName="I[A]"; end
    if (~exist("yName","var")), yName="KICK[rad]"; end
    if (~exist("nominalParName","var")), nominalParName="BP[mm]"; end
    if (~exist("actualParName","var")), actualParName="Brho[Tm]"; end
    [iColXs]=RecogInRMHeader(header,xName);
    [iColYs]=RecogInRMHeader(header,yName);
    [iColNomPar]=RecogInRMHeader(header,nominalParName);
    unNomParVals=unique(data(:,iColNomPar));
    [iColBrho]=RecogInRMHeader(header,actualParName);
    Brhos=unique(data(:,iColBrho));
    
    %% dimensions
    nParValues=length(unNomParVals);
    nMons=length(iColYs);
    RMs=NaN(nParValues,nMons);
    
    %% preliminary plotting
    if (lShow)
        [nRows,nCols]=GetNrowsNcols(nMons);
        figure();
        xMin=min(data(:,iColXs)); xMax=max(data(:,iColXs)); 
        yMin=min(data(:,iColYs),[],"all"); yMax=max(data(:,iColYs),[],"all"); 
    end
    
    %% actual loop
    for ii=1:nParValues
        myIDs=(data(:,iColNomPar)==unNomParVals(ii));
        myXs=data(myIDs,iColXs);
        for jj=1:nMons
            myYs=data(myIDs,iColYs(jj));
            P=polyfit(myXs,myYs,1);
            RMs(ii,jj)=P(1);
            if (lShow)
                subplot(nRows,nCols,jj);
                yfit = P(1)*myXs+P(2);
                plot(myXs,myYs,"k.",myXs,yfit,"r-");
                grid on; xlabel(LabelMe(header(iColXs))); ylabel(LabelMe(header(iColYs(jj))));
                xlim([xMin xMax]); ylim([yMin yMax]);
            end
        end
        if (lShow)
            sgtitle(sprintf("%s=%g",header(iColNomPar),unNomParVals(ii)));
            shg();
            % pause(0.1);
        end
    end
    
    %% actual response matrix: mm/A*Tm
    RMs=RMs*1E3.*repmat(Brhos,1,nMons);
    
end

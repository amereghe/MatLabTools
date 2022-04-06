function ShowDCThistograms(DCTcurrs,DCTcyCodes,xVals,whatYlab,whatXlab)
    fprintf("plotting histograms of DCT data...\n");
    [rangeCodes,partCodes]=DecodeCyCodes(DCTcyCodes);
    indicesP=FlagPart(partCodes,"p");
    indicesC=FlagPart(partCodes,"C");
    figure();
    
    % proton data
    fprintf("...computing histograms for protons...\n");
    [myXs,myYs,aves,maxs,uEks,Ibs,myHist]=GetHistograms(DCTcurrs(indicesP,1),xVals(indicesP));
    fprintf("...showing proton data...\n");
    subplot(1,2,1);
    ShowHistograms(myXs,myYs,aves,maxs,uEks,Ibs,myHist,"proton",whatYlab,whatXlab);

    % carbon data
    fprintf("...computing histograms for carbon ions...\n");
    [myXs,myYs,aves,maxs,uEks,Ibs,myHist]=GetHistograms(DCTcurrs(indicesC,1),xVals(indicesC));
    fprintf("...showing carbon ion data...\n");
    subplot(1,2,2);
    ShowHistograms(myXs,myYs,aves,maxs,uEks,Ibs,myHist,"carbon",whatYlab,whatXlab);
    
    % bye bye
    fprintf("...done.\n");
end

function [myXs,myYs,aves,maxs,uEks,Ibs,myHist]=GetHistograms(DCTcurrs,Eks)
    % unique Eks
    uEks=unique(Eks);
    % intensity bins
    Imin=min(DCTcurrs); Imax=max(DCTcurrs); NI=100; Ibs=Imin:(Imax-Imin)/NI:Imax;
    showIs=Ibs(1:end-1)+0.5*(Imax-Imin)/NI;
    myHist=zeros(NI*length(uEks),1);
    myXs=zeros(NI*length(uEks),1);
    myYs=zeros(NI*length(uEks),1);
    aves=zeros(length(uEks),1);
    maxs=zeros(length(uEks),1);
    for ii=1:length(uEks)
        jj=(ii-1)*NI;
        myHist(jj+1:jj+NI)=histcounts(DCTcurrs(Eks==uEks(ii),1),Ibs)';
        aves(ii)=mean(DCTcurrs(Eks==uEks(ii),1));
        [myMax,IDmax]=max(myHist(jj+1:jj+NI));
        maxs(ii)=showIs(IDmax);
        myXs(jj+1:jj+NI)=uEks(ii);
        myYs(jj+1:jj+NI)=showIs;
    end
end

function ShowHistograms(myXs,myYs,aves,maxs,uEks,Ibs,myHist,myTitle,whatYlab,whatXlab)
    scatter(myXs,myYs,32,myHist,'filled','s');
    hold on; plot(uEks,aves,"r*");
    hold on; plot(uEks,maxs,"mo");
    ylim([Ibs(1) Ibs(end)]);
    colorbar();
    legend("hist","mean int","most freq int","Location","best");
    xlabel(whatXlab); ylabel(whatYlab);
    title(sprintf("Spill histogram - %s",myTitle));
end

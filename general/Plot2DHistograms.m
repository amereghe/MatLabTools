function [axM,axX,axY]=Plot2DHistograms(showMe,showMe1DX,showMe1DY,xINs,yINs,xShowLabel,yShowLabel,contours,lHist,lSquared,lBinEdges)
    if ( ~exist("lHist","var") ), lHist=true; end
    if ( ~exist("lSquared","var") ), lSquared=false; end
    if ( ~exist("lBinEdges","var") ), lBinEdges=true; end
    
    contourFmts=["o" "*"];
    
    if (lBinEdges)
        xShow=xINs;
        yShow=yINs;
        xCentres=xINs(2:end)-0.5*diff(xINs(1:2));
        yCentres=yINs(2:end)-0.5*diff(yINs(1:2));
    else
        xShow=[xINs-0.5*diff(xINs(1:2)) xINs(end)+0.5*diff(xINs(1:2))];
        yShow=[yINs-0.5*diff(yINs(1:2)) yINs(end)+0.5*diff(yINs(1:2))];
        xCentres=xINs;
        yCentres=yINs;
    end
    
    %% 2D histogram
    axM=subplot('Position', [0.10, 0.10, 0.6, 0.6]);
    if ( lHist )
        hh=histogram2('XBinEdges',xShow,'YBinEdges',yShow,...
                      'BinCounts',showMe,'FaceColor','flat','ShowEmptyBins','on');
        view(2); % starts appearing as a 2D plot
    else
        plot(showMe(:,1),showMe(:,2),"k.");
    end
    if ( exist("contours","var") )
        if ( ~all(ismissing(contours),"all") )
            for ii=1:size(contours,3)
                hold on; contourFmt=".-";
                if (ii<=length(contourFmts)), contourFmt=contourFmts(ii); end
                if (lHist)
                    plot3(contours(:,1,ii),contours(:,2,ii),ones(size(contours(:,1,ii)))*max(hh.Values,[],"all")/2,strcat(contourFmt,"-"));
                else
                    plot(contours(:,1,ii),contours(:,2,ii),strcat(contourFmt,"-"));
                end
            end
        end
    end
    % additionals
    xlabel(xShowLabel);
    ylabel(yShowLabel);
    % colorbar();
    % caxis manual;
    % caxis([cmin cmax]);
    if ( lSquared )
        myMin=min(min(xShow),min(yShow)); myMax=max(max(xShow),max(yShow));
        if ( exist("contours","var") )
            if ( ~all(ismissing(contours),"all") )
                myMin=min(myMin,min(contours,[],"all"));
                myMax=max(myMax,max(contours,[],"all"));
            end
        end
        xlim([myMin myMax]); ylim([myMin myMax]);
    end
    grid on;
    % set(axM,'ColorScale','log')
    
    %% hor variable
    axX=subplot('Position', [0.10, 0.75, 0.6, 0.15]);
    bar(xCentres,showMe1DX,1,"EdgeColor","none");
    if ( ~lSquared ), xlim([min(xShow) max(xShow)]); end
    ylabel('[]'); grid on;
    set(axX,'xticklabel',{[]})

    %% ver variable
    axY=subplot('Position', [0.75, 0.10, 0.15, 0.6]);
    barh(yCentres,showMe1DY,1,"EdgeColor","none");
    if ( ~lSquared ), ylim([min(yShow) max(yShow)]); end
    xlabel('[]'); grid on;
    set(axY,'yticklabel',{[]})
    
    %% general stuff
    linkaxes([axM,axX],'x');
    linkaxes([axM,axY],'y');
    
end

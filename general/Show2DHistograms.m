function Show2DHistograms(showMe,showMe1DX,showMe1DY,xShow,yShow,xShowLabel,yShowLabel,actualTitle)
    figure('Name',actualTitle,'NumberTitle','off');
    
    %% 2D histogram
    axM=subplot('Position', [0.10, 0.10, 0.6, 0.6]);
    hh=histogram2('XBinEdges',xShow,'YBinEdges',yShow,...
                  'BinCounts',showMe,'DisplayStyle','tile','ShowEmptyBins','on');
    % additionals
    xlabel(xShowLabel);
    ylabel(yShowLabel);
    % colorbar();
    % caxis manual;
    % caxis([cmin cmax]);
    grid on;
    % set(axM,'ColorScale','log')
    
    %% hor variable
    axX=subplot('Position', [0.10, 0.75, 0.6, 0.15]);
    edges = xShow(2:end) - 0.5*(xShow(2)-xShow(1));
    bar(edges,showMe1DX,1);
    xlim([min(xShow) max(xShow)]);
    ylabel('[]');
    set(axX,'xticklabel',{[]})
    grid on;

    %% ver variable
    axY=subplot('Position', [0.75, 0.10, 0.15, 0.6]);
    edges = yShow(2:end) - 0.5*(yShow(2)-yShow(1));
    barh(edges,showMe1DY,1);
    ylim([min(yShow) max(yShow)]);
    xlabel('[]');
    set(axY,'yticklabel',{[]})
    grid on;
    
    %% general stuff
    linkaxes([axM,axX],'x');
    linkaxes([axM,axY],'y');
    sgtitle(actualTitle);
    
end

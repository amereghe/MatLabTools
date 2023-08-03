function PlotSinogram(xs,ys,data,l3D)
% input variables:
% - xs, ys: bin centres (1D float);
% - data: 2D (color) map (2D float);
%         . data vs X: cols;
%         . data vs Y: rows;
% - l3D: boolean requesting a 3D plot (top view by default);
    if (~exist("l3D","var")), l3D=true; end
    [xT,idx]=sort(xs);
    [yT,idy]=sort(ys);
    if (l3D)
        % 3D plot via histogram2:
        % - XBinEdges,YBinEdges are bin-edge values!
        % - size(BinCounts)=[length(XBinEdges)-1 length(YBinEdges)-1]
        xShow=BinCentres2Edges(xT);
        yShow=BinCentres2Edges(yT);
        showMe=data';
        showMe=showMe(idx,:);
        showMe=showMe(:,idy);
        histogram2('XBinEdges',xShow,'YBinEdges',yShow,...
                   'BinCounts',showMe,'FaceColor','flat','ShowEmptyBins','on');
        view(2); % starts appearing as a 2D plot
    else
        % 2D plot via imagesc:
        % - XData,YData are centre values!
        % - size(CData)=[length(YData) length(XData)]
        showMe=data;
        showMe=showMe(:,idx);
        showMe=showMe(idy,:);
        imagesc('XData',xT,'YData',yT,'CData',showMe);
        colorbar;
    end
    grid();
end

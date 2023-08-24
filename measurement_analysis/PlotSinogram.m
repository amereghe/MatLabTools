function PlotSinogram(xs,ys,data,l3D,iNotShow)
% input variables:
% - xs, ys: bin centres (1D float);
% - data: 2D (color) map (2D float);
%         . data vs X: cols;
%         . data vs Y: rows;
% - l3D: boolean requesting a 3D plot (top view by default);
% - iNotShow: do not show specific rows or columns:
%   . (array of booleans): length(iNotShow)=length(xs);
%   . (array of integers): length(iNotShow)<=length(xs);
    if (~exist("l3D","var")), l3D=true; end
    if (~exist("iNotShow","var")), iNotShow=missing(); end
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
        showMe(isnan(showMe))=0.0; % histogram2 cannot handle NaNs...
        if (any(~ismissing(iNotShow)))
            showMe(:,iNotShow)=0.0;
        end
        histogram2('XBinEdges',xShow,'YBinEdges',yShow,...
                   'BinCounts',showMe,'FaceColor','flat',...
                   'ShowEmptyBins','on','LineStyle','none');
        view(2); % starts appearing as a 2D plot
    else
        % 2D plot via imagesc:
        % - XData,YData are centre values!
        % - size(CData)=[length(YData) length(XData)]
        showMe=data;
        showMe=showMe(:,idx);
        showMe=showMe(idy,:);
        if (any(~ismissing(iNotShow)))
            showMe(iNotShow,:)=0.0;
        end
        imagesc('XData',xT,'YData',yT,'CData',showMe);
        colorbar;
    end
    grid();
end

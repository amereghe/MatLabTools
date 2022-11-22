function LGENvisualCheck(psNames,xVals,xLab,yVals,yLab,magNames,myTitle,myLegend,LGENs)
    if (~exist("myTitle","var") || strlength(myTitle)==0 ), myTitle=missing(); end
    if (~exist("myLegend","var")), myLegend=missing(); end
    if (~exist("LGENs","var")), LGENs=unique(psNames); end % default: do not filter
    nMagnets=size(LGENs,1);
    nSets=size(psNames,2);

    figure();
    cm=colormap(parula(nSets+1));
    % - set grid of plots
    nPlots=nMagnets;
    if (~ismissing(myLegend)), nPlots=nPlots+1; end
    [nRows,nCols]=GetNrowsNcols(nPlots);
    % - set markers
    if ( nSets==2 )
        markers=[ "o" "*" ];
    else
        markers=strings(nSets,1);
        markers(:)=".";
    end
    % - actually plot
    for iMagnet=1:nMagnets
        subplot(nRows,nCols,iMagnet);
        lFirst=true;
        for iSet=1:nSets
            jj=find(strcmp(psNames(:,iSet),LGENs(iMagnet)));
            if ( isempty(jj) )
                warning("...unable to find LGEN %s in list of PS names!",LGENs(iMagnet));
                continue
            end
            if (lFirst), lFirst=false; else, hold on; end
            [~,IDs]=sort(xVals(:,iSet));
            plot(xVals(IDs,iSet),yVals(IDs,jj,iSet),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        xlabel(xLab); ylabel(yLab); grid on;
        title(sprintf("%s (aka %s)",magNames(jj,iSet),LGENs(iMagnet)));
    end
    % - legend plot
    if (~ismissing(myLegend))
        subplot(nRows,nCols,nPlots);
        lFirst=true;
        for iSet=1:nSets
            if (lFirst), lFirst=false; else, hold on; end
            plot(NaN(),NaN(),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        legend(myLegend);
    end
    % - general stuff
    if (~ismissing(myTitle)), sgtitle(myTitle); end
    
end

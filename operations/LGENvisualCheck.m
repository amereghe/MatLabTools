function LGENvisualCheck(psNames,xVals,xLab,yVals,yLab,magNames,myTitle,LGENs)
    if (~exist("LGENs","var")), LGENs=psNames; end
    figure();
    nSets=length(LGENs);
    % automatically set grid of subplots
    [nRows,nCols]=GetNrowsNcols(nSets);
    
    for iSet=1:nSets
        subplot(nRows,nCols,iSet);
        jj=find(strcmp(psNames,LGENs(iSet)));
        if ( isempty(jj) )
            warning("...unable to find LGEN %s in list of PS names!",LGENs(iSet));
            continue
        end
        plot(xVals,yVals(:,jj),'*');
        xlabel(xLab); ylabel(yLab);
        grid on;
        title(sprintf("%s (aka %s)",magNames(jj),LGENs(iSet)));
    end
    
    sgtitle(myTitle);
    
end

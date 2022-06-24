function ShowLPOWerrLogTime(tStampsLPOWMon,LGENsLPOWMon,requestedLGENs,repoValsLPOWMon,appValsLPOWMon,cyCodesLPOWMon,xVals,whatXlab,nLGENsPerFig)

    fprintf("plotting LPOW error log data vs time...\n");
    
    if (~exist("nLGENsPerFig","var")), nLGENsPerFig=4; end
    
    [rangeCodes,partCodes]=DecodeCyCodes(cyCodesLPOWMon);
    indicesP=FlagPart(partCodes,"p");
    indicesC=FlagPart(partCodes,"C");
    nLGENsReq=length(requestedLGENs);
    nFigs=ceil(nLGENsReq/nLGENsPerFig);
    
    iLGEN=0;
    for iFig=1:nFigs
        if (iFig==nFigs)
            nPlots=mod(nLGENsReq-1,nLGENsPerFig)+1;
        else
            nPlots=nLGENsPerFig;
        end
    
        figure("Name",sprintf("LPOW err Log - LGENs: %s",join(requestedLGENs(iLGEN+1:iLGEN+nPlots),", ")));
        clear axs;

        for iPlot=1:nPlots
            clear legends;
            axs(iPlot)=subplot(nPlots+1,1,iPlot);
            iLGEN=iLGEN+1;
            currLGEN=requestedLGENs(iLGEN);
            LGENindices=(LGENsLPOWMon==currLGEN);
            % - repo values:
            plot(datenum(tStampsLPOWMon(LGENindices)),repoValsLPOWMon(LGENindices),"k*");
            jj=1; legends(jj)="repo value";
            % - proton values:
            myIndices=(indicesP & LGENindices);
            if ( sum(myIndices)>0 )
                hold on; plot(datenum(tStampsLPOWMon(myIndices)),appValsLPOWMon(myIndices),"r.");
                jj=jj+1; legends(jj)="proton";
            end
            % - carbon values:
            myIndices=(indicesC & LGENindices);
            if ( sum(myIndices)>0 )
                hold on; plot(datenum(tStampsLPOWMon(myIndices)),appValsLPOWMon(myIndices),"b.");
                jj=jj+1; legends(jj)="carbon";
            end
            ylabel(sprintf("%s - I [A]",currLGEN));
            datetick('x','dd-mm HH:MM:ss'); set(gca,'XTickLabelRotation',45);
            legend(legends,'location','best'); grid();
        end

        % beam energies/ranges
        axs(nPlots+1)=subplot(nPlots+1,1,nPlots+1);
        plot(datenum(tStampsLPOWMon(indicesP)),xVals(indicesP),"r.",...
             datenum(tStampsLPOWMon(indicesC)),xVals(indicesC),"b.");
        ylabel(whatXlab);
        datetick('x','dd-mm HH:MM:ss'); set(gca,'XTickLabelRotation',45);
        legend("proton","carbon",'location','best'); grid();

        % global
        dynamicDateTicks(axs, 'linked');
        linkaxes(axs,"x");
    end
    
    fprintf("...done;\n");
end

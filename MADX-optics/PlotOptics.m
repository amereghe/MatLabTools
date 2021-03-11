function PlotOptics(tfsTables,what,emig,sigdpp,refTfsTable,whatRef)

    emigUsr=0.0; % [mm mrad]
    if ( exist('emig','var') )
        emigUsr=emig;
    end
    sigdppUsr=0.0; % [mm mrad]
    if ( exist('sigdpp','var') )
        sigdppUsr=sigdpp;
    end
    
    nTables=size(tfsTables,1);
    colormap(parula(nTables));
    for jj=1:nTables
        if ( exist('refTfsTable','var') )
            if ( exist('whatRef','var') )
                PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,refTfsTable,whatRef);
            else
                % be careful to plot the reference optics only ones
                if ( jj == 1 )
                    PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,refTfsTable);
                else
                    PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr);
                end
            end
        else
            PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr);
        end
        if ( jj<nTables )
            hold on;
        end
    end
end

function PlotOpticsActual(tfsTables,what,SeriesIndex,emig,sigdpp,refTfsTable,whatRef)

    emigUsr=0.0; % [mm mrad]
    if ( exist('emig','var') )
        emigUsr=emig;
    end
    sigdppUsr=0.0; % [mm mrad]
    if ( exist('sigdpp','var') )
        sigdppUsr=sigdpp;
    end

    % column mapping
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                                  GetColumnsAndMappingTFS('optics');
    Xs=tfsTables{mapping(find(strcmp(colNames,'S')))};
    maxS=max(Xs);
    minS=min(Xs);
    if ( exist('refTfsTable','var') )
       XsRef=refTfsTable{mapping(find(strcmp(colNames,'S')))};
       if ( length(Xs) ~= length(XsRef) )
           error('Reference optics and current optics have different number of elements!')
       end
    end

    uppWhat=upper(what);
    if ( contains(uppWhat,"SIG") | contains(uppWhat,"ENV") )
        Ys=zeros(length(Xs),1);
        if ( exist('refTfsTable','var') )
            YsRef=zeros(1,length(XsRef));
        end
        tmpTitles=[];
        if ( emigUsr==0.0 & sigdppUsr==0.0 )
            error("Cannot plot %s with no geometrical emittance and sigma delta_p/p!",what);
        end
        if ( length(uppWhat{1}) == 4 )
            plane=uppWhat{1}(4);
            if ( plane~="X" & plane~="Y" )
                error("Not recognised optical quantity to plot: %s!",what);
            end
            if ( emigUsr ~= 0.0 )
                betas=tfsTables{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                Ys=Ys+sqrt(betas*emig);
                if ( exist('refTfsTable','var') )
                    betas=tfsTables{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                    YsRef=YsRef+sqrt(betas*emig);
                end
                tmpTitles=[ tmpTitles sprintf("\\epsilon_g=%g [\\mum]",emig*1E6) ];
            end
            if ( sigdppUsr ~= 0.0 )
                Ds=tfsTables{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
                Ys=Ys+abs(Ds)*sigdpp;
                if ( exist('refTfsTable','var') )
                    Ds=tfsTables{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
                    YsRef=YsRef+abs(Ds)*sigdpp;
                end
                tmpTitles=[ tmpTitles sprintf("\\sigma_{\\Deltap/p}=%g []",sigdpp) ];
            end
            varName=sprintf("\\sigma_{%s}",lower(plane));
            varUnit="mm";
        elseif ( length(uppWhat{1}) == 5 )
            plane=uppWhat{1}(5);
            if ( plane~="X" & plane~="Y" )
                error("Not recognised optical quantity to plot: %s!",what);
            end
            if ( emigUsr ~= 0.0 )
                gammas=(1+tfsTables{mapping(find(strcmp(colNames,sprintf('ALF%s',plane))))}^2) ...
                    /tfsTables{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                Ys=Ys+sqrt(gammas*emig);
                if ( exist('refTfsTable','var') )
                    gammas=(1+tfsTables{mapping(find(strcmp(colNames,sprintf('ALF%s',plane))))}^2) ...
                        /tfsTables{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                    YsRef=YsRef+sqrt(gammas*emig);
                end
                tmpTitles=[ tmpTitles sprintf("\\epsilon_g=%g [\\mum]",emig*1E6) ];
            end
            if ( sigdppUsr ~= 0.0 )
                Dps=tfsTables{mapping(find(strcmp(colNames,sprintf('DP%s',plane))))};
                Ys=Ys+abs(Dps)*sigdpp;
                if ( exist('refTfsTable','var') )
                    Dps=tfsTables{mapping(find(strcmp(colNames,sprintf('DP%s',plane))))};
                    YsRef=YsRef+abs(Dps)*sigdpp;
                end
                tmpTitles=[ tmpTitles sprintf("\\sigma_{\\Deltap/p}=%g []",sigdpp) ];
            end
            varName=sprintf("\\sigma_{p%s}",lower(plane));
            varUnit="10^{-3}";
        else
            error("Not recognised optical quantity to plot: %s!",what);
        end
        title(join(tmpTitles," - "));
        Ys=Ys*1E3;
        
        if ( exist('refTfsTable','var') )
            YsRef=YsRef*1E3;
        end

    else
        iY=find(strcmp(colNames,what));
        if ( isempty(iY) )
            error("Column name '%s' not present in TFS table(s)",what)
        else
            Ys=tfsTables{mapping(iY)}*colFacts(find(strcmp(colNames,what)));
            if ( exist('refTfsTable','var') )
                YsRef=refTfsTable{mapping(iY)}*colFacts(find(strcmp(colNames,what)));
            end
            varName=what;
            varUnit=colUnits(find(strcmp(colNames,what)));
        end
    end
    if ( exist('refTfsTable','var') )
        if ( exist('whatRef','var') )
            switch lower(whatRef)
                case {"ratio"}
                    Ys=Ys./YsRef;
                    varName=sprintf("R=%s/%s_{ref}",varName,varName);
                    varUnit="";
                case {"perc","percent"}
                    Ys=Ys./YsRef*100;
                    varName=sprintf("R=%s/%s_{ref}",varName,varName);
                    varUnit="%";
                case {"delta"}
                    Ys=1-Ys./YsRef;
                    varName=sprintf("\\Delta %s=1-%s/%s_{ref}",varName,varName,varName);
                    varUnit="";
                case {"deltaperc","deltapercent"}
                    Ys=(1-Ys./YsRef)*100;
                    varName=sprintf("\\Delta %s=1-%s/%s_{ref}",varName,varName,varName);
                    varUnit="%";
                otherwise
                    error('Unidentified action with reference optics %s',whatRef);
            end
        else
            % just plot the optics and the reference
            plot(XsRef,YsRef,'ks-','SeriesIndex',0);
            hold on;
        end
    end
    cmap = colormap(gcf);
    if ( strfind(uppWhat,"ENV") )
        % beam envelop
        if ( plane=="X" )
            COs=tfsTables{mapping(find(strcmp(colNames,'X')))};
        else
            COs=tfsTables{mapping(find(strcmp(colNames,'Y')))};
        end
        COs=COs*1E3;
        BEp=COs+Ys;
        BEm=COs-Ys;
        patch([Xs' fliplr(Xs')],[COs' fliplr(BEp')],cmap(SeriesIndex,:),'FaceAlpha',0.3,'EdgeColor',cmap(SeriesIndex,:));
        patch([Xs' fliplr(Xs')],[COs' fliplr(BEm')],cmap(SeriesIndex,:),'FaceAlpha',0.3,'EdgeColor',cmap(SeriesIndex,:));
        ylabel(sprintf("[%s]",varUnit));
    else
        % plot the optics
        plot(Xs,Ys,'.-','Color',cmap(SeriesIndex,:));
        ylabel(sprintf("%s [%s]",varName,varUnit));
    end
    xlim([minS maxS]);
end

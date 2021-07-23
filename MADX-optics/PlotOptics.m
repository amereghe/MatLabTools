function PlotOptics(tfsTables,what,emig,sigdpp,avedpp,refTfsTable,whatRef)

    emigUsr=1.0E-06; % [m rad]
    if ( exist('emig','var') )
        emigUsr=emig;
    end
    sigdppUsr=0.0; % []
    if ( exist('sigdpp','var') )
        sigdppUsr=sigdpp;
    end
    avedppUsr=0.0; % []
    if ( exist('avedpp','var') )
        avedppUsr=avedpp;
    end
    
    nTables=size(tfsTables,1);
    if ( nTables>1 )
        colormap(parula(nTables));
    end
    for jj=1:nTables
        if ( exist('refTfsTable','var') )
            if ( exist('whatRef','var') )
                PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,avedppUsr,refTfsTable,whatRef);
            else
                % be careful to plot the reference optics only ones
                if ( jj == 1 )
                    PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,avedppUsr,refTfsTable);
                else
                    PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,avedppUsr);
                end
            end
        else
            PlotOpticsActual(tfsTables(jj,:),what,jj,emigUsr,sigdppUsr,avedppUsr);
        end
        if ( jj<nTables )
            hold on;
        end
    end
end

function PlotOpticsActual(tfsTables,what,SeriesIndex,emig,sigdpp,avedpp,refTfsTable,whatRef)

    emigUsr=1.0E-06; % [m rad]
    if ( exist('emig','var') )
        emigUsr=emig;
    end
    sigdppUsr=0.0; % []
    if ( exist('sigdpp','var') )
        sigdppUsr=sigdpp;
    end
    avedppUsr=0.0; % []
    if ( exist('avedpp','var') )
        avedppUsr=avedpp;
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
                Ys=Ys+betas.*emigUsr;
                if ( exist('refTfsTable','var') )
                    betas=refTfsTable{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                    YsRef=YsRef+betas.*emigUsr;
                end
            end
            if ( sigdppUsr ~= 0.0 )
                Ds=tfsTables{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
                Ys=Ys+(Ds*sigdppUsr).^2;
                if ( exist('refTfsTable','var') )
                    Ds=refTfsTable{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
                    YsRef=YsRef+(Ds*sigdppUsr).^2;
                end
            end
            Ys=sqrt(Ys);
            if ( exist('refTfsTable','var') )
                YsRef=sqrt(YsRef);
            end
            varName=sprintf("\\sigma_{%s}",lower(plane));
            varUnit="mm";
        elseif ( length(uppWhat{1}) == 5 )
            plane=uppWhat{1}(5);
            if ( plane~="X" & plane~="Y" )
                error("Not recognised optical quantity to plot: %s!",what);
            end
            if ( emigUsr ~= 0.0 )
                gammas=(1+refTfsTable{mapping(find(strcmp(colNames,sprintf('ALF%s',plane))))}.^2) ...
                    ./refTfsTable{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                Ys=Ys+gammas.*emigUsr;
                if ( exist('refTfsTable','var') )
                    gammas=(1+refTfsTable{mapping(find(strcmp(colNames,sprintf('ALF%s',plane))))}.^2) ...
                        ./refTfsTable{mapping(find(strcmp(colNames,sprintf('BET%s',plane))))};
                    YsRef=YsRef+gammas.*emigUsr;
                end
            end
            if ( sigdppUsr ~= 0.0 )
                Dps=tfsTables{mapping(find(strcmp(colNames,sprintf('DP%s',plane))))};
                Ys=Ys+(Dps.*sigdppUsr)^2;
                if ( exist('refTfsTable','var') )
                    Dps=refTfsTable{mapping(find(strcmp(colNames,sprintf('DP%s',plane))))};
                    YsRef=YsRef+(Dps.*sigdppUsr)^2;
                end
            end
            Ys=sqrt(Ys);
            if ( exist('refTfsTable','var') )
                YsRef=sqrt(YsRef);
            end
            varName=sprintf("\\sigma_{p%s}",lower(plane));
            varUnit="10^{-3}";
        else
            error("Not recognised optical quantity to plot: %s!",what);
        end

    elseif ( contains(uppWhat,"CO") | contains(uppWhat,"ORB") )
        Ys=zeros(length(Xs),1);
        if ( exist('refTfsTable','var') )
            YsRef=zeros(1,length(XsRef));
        end
        plane=uppWhat{1}(end);
        if ( plane~="X" & plane~="Y" )
            error("Not recognised optical quantity to plot: %s!",what);
        end
        Ys=Ys+tfsTables{mapping(find(strcmp(colNames,plane)))};
        if ( exist('refTfsTable','var') )
            YsRef=YsRef+refTfsTable{mapping(find(strcmp(colNames,plane)))};
        end
        if ( avedppUsr ~= 0.0 )
            Ds=tfsTables{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
            Ys=Ys+Ds*avedppUsr;
            if ( exist('refTfsTable','var') )
                Ds=refTfsTable{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
                YsRef=YsRef+Ds*avedppUsr;
            end
        end
        varName=sprintf("ORB_{%s}",lower(plane));
        varUnit="m";
        
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
    if ( contains(uppWhat,"ENV") )
        % beam envelop
        COs=tfsTables{mapping(find(strcmp(colNames,plane)))};
        if ( avedppUsr ~= 0.0 )
            Ds=tfsTables{mapping(find(strcmp(colNames,sprintf('D%s',plane))))};
            COs=COs+Ds*avedppUsr;
        end
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

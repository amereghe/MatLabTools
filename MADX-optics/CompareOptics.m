function CompareOptics(optics,labels,geometry,whats,myTitle,emig,sigdpp)
% not yet ready to crunch a ref optics!
    emigUsr=1.0E-06; % [m rad]
    if ( exist('emig','var') )
        emigUsr=emig;
    end
    sigdppUsr=0.0; % []
    if ( exist('sigdpp','var') )
        sigdppUsr=sigdpp;
    end
    uppWhats=upper(whats);
    switch length(uppWhats)
        case 1
            switch uppWhats
                case "BET"
                    usrWhats=[ "BETX" "BETY" ];
                case "MU"
                    usrWhats=[ "MUX" "MUY" ];
                case "D"
                    usrWhats=[ "DX" "DY" ];
                case "CO"
                    usrWhats=[ "X" "Y" ];
                case "SIG"
                    usrWhats=[ "SIGX" "SIGY" ];
                case "SIGP"
                    usrWhats=[ "SIGPX" "SIGPY" ];
                case "ENV"
                    usrWhats=[ "ENVX" "ENVY" ];
                otherwise
                    error("cannot undestand single what %s!",whats);
            end
        case 2
            usrWhats=uppWhats;
        otherwise
            error("cannot use more than 2 whats!");
    end
    nCols=size(geometry,1);
    nOpts=size(optics,1);
    if ( nCols>1 )
        if ( nOpts ~= nCols )
            error("cannot overlay %d optics to %d geometries",nOpts,nCols);
        end
    end
    
    tmpTitle=sprintf("%s - %s - %s",usrWhats(1),usrWhats(2),myTitle);
    f1=figure('Name',tmpTitle,'NumberTitle','off');
    axs=cell(3,nCols);
    if ( nCols > 1 )
        % - nice lattice plots
        for ii=1:nCols
            axs{1,ii}=subplot(3,nCols,ii);
            PlotLattice(geometry(ii,:));
            title(labels(ii));
        end
        % - H plane
        for ii=1:nCols
            axs{2,ii}=subplot(3,nCols,ii+nCols);
            PlotOptics(optics(ii,:),usrWhats(1),emigUsr,sigdppUsr);
            grid on;
        end
        % - V plane
        for ii=1:nCols
            axs{3,ii}=subplot(3,nCols,ii+2*nCols);
            PlotOptics(optics(ii,:),usrWhats(2),emigUsr,sigdppUsr);
            grid on;
            xlabel("s [m]");
        end
        % - miscellanea
        for ii=1:nCols
            linkaxes([axs{:,ii}],'x');
        end
    else
        % - nice lattice plots
        axs{1,1}=subplot(3,nCols,1);
        PlotLattice(geometry(:,:));
        % - H plane
        axs{2,1}=subplot(3,nCols,2);
        PlotOptics(optics(:,:),usrWhats(1),emigUsr,sigdppUsr);
        legend(labels,"Location","best","NumColumns",ceil(nOpts/10.));
        grid on;
        % - V plane
        axs{3,1}=subplot(3,nCols,3);
        PlotOptics(optics(:,:),usrWhats(2),emigUsr,sigdppUsr);
        legend(labels,"Location","best","NumColumns",ceil(nOpts/10.));
        grid on;
        % - miscellanea
        linkaxes([axs{:,1}],'x');
        xlabel("s [m]");
    end
    sgtitle(tmpTitle);
end

function ShowOptics(optics,geometry,myTitle,Laccel,Qx,Qy,Chrx,Chry)
% showOptics      displays a quick plot of the optics of a certain machine
% 
% When calling this function, please remember to load the path to the whole
%    library, e.g. via:
%         pathToLibrary="D:\VMs\vb_share\repos\MatLabTools";
%         addpath(genpath(pathToLibrary));
%
% The function simply shows a figure with 4 plots (1 column, 4 rows):
% - lattice structure;
% - beta functions;
% - dispersion functions;
% - orbit;

    % - column names
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                              GetColumnsAndMappingTFS('optics');

    f1=figure('Name','optics','NumberTitle','off');

    % - geometry
    ax1=subplot(4,1,1);
    PlotLattice(geometry);
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    % - betas
    ax2=subplot(4,1,2);
    Xs=optics{mapping(find(strcmp(colNames,'S')))};
    plot(Xs,optics{mapping(find(strcmp(colNames,'BETX')))},'s-', ...
         Xs,optics{mapping(find(strcmp(colNames,'BETY')))},'s-' );
    legend("\beta_x","\beta_y");
    ylabel("[m]");
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - dispersion
    ax3=subplot(4,1,3);
    Xs=optics{mapping(find(strcmp(colNames,'S')))};
    plot(Xs,optics{mapping(find(strcmp(colNames,'DX')))},'s-', ...
         Xs,optics{mapping(find(strcmp(colNames,'DY')))},'s-' );
    legend("D_x","D_y");
    ylabel("[m]");
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - orbit
    ax4=subplot(4,1,4);
    Xs=optics{mapping(find(strcmp(colNames,'S')))};
    plot(Xs,optics{mapping(find(strcmp(colNames,'X')))},'s-', ...
         Xs,optics{mapping(find(strcmp(colNames,'Y')))},'s-' );
    legend("CO_x","CO_y");
    ylabel("[m]");
    xlabel("s [m]");
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - title
    tmpTitle="";
    if ( exist('myTitle','var') )
        tmpTitle=myTitle;
    end
    if ( exist('Qx','var') & exist('Qy','var') & exist('Chrx','var') & exist('Chry','var') )
        if ( strlength(tmpTitle) > 0 )
            tmpTitle=sprintf("%s\nQ_x=%g, Q_y=%g, \\xi_x=%g, \\xi_y=%g;",tmpTitle,Qx,Qy,Chrx,Chry);
        else
            tmpTitle=sprintf("Q_x=%g, Q_y=%g, \\xi_x=%g, \\xi_y=%g;",Qx,Qy,Chrx,Chry);
        end
    end
    if ( strlength(tmpTitle) > 0 )
        sgtitle(tmpTitle);
    end
    linkaxes([ax1 ax2 ax3 ax4],'x');
end
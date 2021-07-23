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

    Xs=optics{mapping(find(strcmp(colNames,'S')))};
    if ( exist('Laccel','var') ) xlims=[0 Laccel]; else xlims=[min(Xs) max(Xs)]; end
    
    % - geometry
    ax1=subplot(4,1,1);
    PlotLattice(geometry);
    xlim(xlims);
    % - betas
    ax2=subplot(4,1,2);
    plot(Xs,optics{mapping(find(strcmp(colNames,'BETX')))},'s-', ...
         Xs,optics{mapping(find(strcmp(colNames,'BETY')))},'s-' );
    legend("\beta_x","\beta_y");
    ylabel("\beta [m]");
    xlim(xlims);
    grid('on');
    % - dispersion
    ax3=subplot(4,1,3);
    yyaxis('left');
    plot(Xs,optics{mapping(find(strcmp(colNames,'DX')))},'s-');
    ylabel("D_x [m]");
    yyaxis('right');
    plot(Xs,optics{mapping(find(strcmp(colNames,'DY')))},'s-');
    ylabel("D_y [m]");
    yyaxis("left");
    xlim(xlims);
    grid('on');
    % - orbit
    ax4=subplot(4,1,4);
    yyaxis('left');
    plot(Xs,optics{mapping(find(strcmp(colNames,'X')))},'s-');
    ylabel("X [m]");
    yyaxis('right');
    plot(Xs,optics{mapping(find(strcmp(colNames,'Y')))},'s-');
    ylabel("Y [m]");
    yyaxis("left");
    xlabel("s [m]");
    xlim(xlims);
    grid('on');
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
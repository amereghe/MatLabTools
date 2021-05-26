function ShowRmatrix(optics,geometry,myTitle,Laccel)
% showRmatrix      displays a quick plot of selected elements of the Response matrix
% 
% When calling this function, please remember to load the path to the whole
%    library, e.g. via:
%         pathToLibrary="D:\VMs\vb_share\repos\MatLabTools";
%         addpath(genpath(pathToLibrary));
%
% The function simply shows a figure with 4 plots (1 column, 4 rows):
% - lattice structure;
% - R11,R12,R21,R22;
% - R33,R34,R43,R44;
% - R16,R26,R51,R52,R55,R56,R66;

    % - column names
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                              GetColumnsAndMappingTFS('rmatrix');

    f1=figure('Name','rmatrix','NumberTitle','off');
    Xs=optics{mapping(find(strcmp(colNames,'S')))};

    % - geometry
    ax1=subplot(4,1,1);
    PlotLattice(geometry);
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    % - horizontal plane
    ax2=subplot(4,1,2);
    lFirst=true;
    tmpLeg=[];
    for what=["RE11" "RE12" "RE21" "RE22"]
        iCol=mapping(find(strcmp(colNames,what)));
        if ( lFirst )
            lFirst=false;
        else
            hold on;
        end
        plot(Xs,optics{iCol},'s-' );
        tmpLeg=[tmpLeg sprintf("%s [%s]",what,colUnits(iCol))];
    end
    legend(tmpLeg);
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - vertical plane
    ax3=subplot(4,1,3);
    lFirst=true;
    tmpLeg=[];
    for what=["RE33" "RE34" "RE43" "RE44"]
        iCol=mapping(find(strcmp(colNames,what)));
        if ( lFirst )
            lFirst=false;
        else
            hold on;
        end
        plot(Xs,optics{iCol},'s-' );
        tmpLeg=[tmpLeg sprintf("%s [%s]",what,colUnits(iCol))];
    end
    legend(tmpLeg);
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - longitudinal plane
    ax4=subplot(4,1,4);
    lFirst=true;
    tmpLeg=[];
    for what=["RE16" "RE26" "RE36" "RE46" "RE51" "RE52" "RE55" "RE56" "RE66"]
        iCol=mapping(find(strcmp(colNames,what)));
        if ( lFirst )
            lFirst=false;
        else
            hold on;
        end
        plot(Xs,optics{iCol},'s-' );
        tmpLeg=[tmpLeg sprintf("%s [%s]",what,colUnits(iCol))];
    end
    legend(tmpLeg);
    if ( exist('Laccel','var') )
        xlim([0 Laccel]);
    end
    grid on;
    % - title
    tmpTitle="";
    if ( exist('myTitle','var') )
        tmpTitle=myTitle;
    end
    if ( strlength(tmpTitle) > 0 )
        sgtitle(tmpTitle);
    end
    linkaxes([ax1 ax2 ax3 ax4],'x');
end

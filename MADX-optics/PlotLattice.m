function PlotLattice(geometry)
% PlotLattice     make a nice plot of the accelerator lattice
%
% For the time being, all parameters controlling the plotting are
% hard-coded in the function.
% Nota bene: the function does not create a figure or a subplot, they
% should be created beforehand;
% 
% PlotLattice(geometry)
%
% input arguments:
%     geometry: geometry of the beam line as read from a geometry file.
%               For the format of the TFS table, please see
%                  GetColumnsAndMappingTFS.
%               Nota Bene: values of s-coordinate refer to end of thick
%               element;
%
% See also GetAperture, ParseTfsTable, GetColumnsAndMappingTFS.

    % column mapping
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
       GetColumnsAndMappingTFS('geometry');
    colS=mapping(find(strcmp(colNames,'S')));
    colL=mapping(find(strcmp(colNames,'L')));
    colAng=mapping(find(strcmp(colNames,'ANGLE')));
    colK1L=mapping(find(strcmp(colNames,'K1L')));
    colK2L=mapping(find(strcmp(colNames,'K2L')));
    colKey=mapping(find(strcmp(colNames,'KEYWORD')));
    
    % kickers are treated separately
    keywords      =[ "COLLIMATOR" "INSTRUMENT" "MONITOR" "QUADRUPOLE" "RFCAVITY" "SBEND" "SEXTUPOLE" ];
    lShowName     =[  1            1            0         1            1          1       0          ];
    yPosNames     =[  1            1            1         1            1.5        1       1          ];
    angleNames    =[  90           90           90        90           90         90      90         ];
    iColK         =[  0            0            0         colK1L       0          colAng  colK2L     ];
    yPosBoxes     ={ -0.5         -0.5         -0.5       [0 -1]      -0.5       -1       [0 -1]     };
    dyPosBoxes    =[  1            1            1         1            1          2       1          ];
    faceColorBoxes={ "k"          "w"          "c"        [0 .5 .5]   "y"        "b"      [0.9290 0.6940 0.1250] };
    edgeColorBoxes=[ "k"          "k"          "k"       "k"          "k"        "k"     "k"         ];
    
    maxS=max(geometry{colS})+geometry{colL}(end);
    minS=min(geometry{colS});

    % horizontal line, above which elements are displayed
    plot([minS maxS],[0 0],'k');
    
    for jj=1:length(keywords)
        
        % get elements with the given keyword
        indices=find(contains(geometry{colKey},keywords(jj)));
        for ii = 1:length(indices)
            
            % get position along line and extension
            [s,ds]=getSdS(geometry{colS}(indices(ii)),geometry{colL}(indices(ii)));
            
            % position of the box
            if ( length(yPosBoxes{jj}) == 2 )
                % box position depends on magnet powering
                if ( geometry{iColK(jj)}(indices(ii)) > 0 )
                    % 'focussing'
                    setBox(s,ds,yPosBoxes{jj}(1),dyPosBoxes(jj),faceColorBoxes{jj},edgeColorBoxes(jj));
                else
                    % 'defocussing'
                    setBox(s,ds,yPosBoxes{jj}(2),dyPosBoxes(jj),faceColorBoxes{jj},edgeColorBoxes(jj));
                end
            else
                setBox(s,ds,yPosBoxes{jj},dyPosBoxes(jj),faceColorBoxes{jj},edgeColorBoxes(jj));
            end
            
            % show name
            if (lShowName(jj))
                showName(s,ds,geometry{1}(indices(ii)),yPosNames(jj),angleNames(jj));
            end
            
        end
    end
    
    % KICKERs: special treatement
    indices=find(contains(geometry{2},'KICKER'));
    for ii = 1:length(indices)
        [s,ds]=getSdS(geometry{colS}(indices(ii)),geometry{colL}(indices(ii)));
        if contains(geometry{1}(indices(ii)),'SP')
            % septum
            setBox(s,ds,-0.5,1,'m','k');
            showName(s,ds,geometry{1}(indices(ii)),1,90);
        elseif contains(geometry{1}(indices(ii)),'BD')
            % septum
            setBox(s,ds,-0.5,1,[0.5 0.0 0.5],'k');
            showName(s,ds,geometry{1}(indices(ii)),1,90);
        else
            % regular corrector magnet
            setBox(s,ds,-0.5,1,'r','k');
        end
    end
    
    % additionals
    ylim([-2 5]);
    xlim([0 maxS]);
    grid on;
    set(gca,'YTickLabel',[]);
    
end

function [z,dz]=getSdS(S,L)
    z=S-L;
    dz=L;
end

function showName(x,dx,name,yPos,angle)
    t=text(x+0.5*dx,yPos,strrep(strip(name,'"'),'_','\_'),'FontSize',10);
    set(t,'Rotation',angle);
end

function setBox(x,dx,y,dy,faceColor,edgeColor)
    rectangle('Position',[x y dx dy], 'Facecolor', faceColor, 'EdgeColor', edgeColor );
end

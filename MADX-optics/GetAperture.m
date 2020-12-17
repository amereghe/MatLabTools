function [aper,aperOff,aperS]=GetAperture(geometry,angle)
% GetAperture           extract aperture profile from an accelerator lattice
%                         (geometry)
%
% For the time being, only RECTANGLE apertures are treated.
% The aperture profile is returned as 3 arrays.
%
% [aper,aperOff,aperS]=GetAperture(geometry,angle)
% 
% input arguments:
%     geometry: geometry of the beam line as read from a geometry file.
%               For the format of the TFS table, please see
%                  GetColumnsAndMappingTFS.
%               Nota Bene: values of s-coordinate refer to end of thick
%               element;
%     angle: plane onto which the aperture profile is requested.
%            For the time being, only 0 (hor) and 90 (ver) degs are accepted.
% 
% output arguments:
%     aper: aperture dimension on the specified plane, symmetric part [m];
%     aperOff: aperture offset on the specified plane [m];
%     aperS: s-coordinate of the given aperture markers [m];
% 
% see also ParseTfsTable, GetColumnsAndMappingTFS.

    % column mapping
    [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
       GetColumnsAndMappingTFS('geometry');
    colS=mapping(find(strcmp(colNames,'S')));
    colL=mapping(find(strcmp(colNames,'L')));
    switch angle
        case{0}
            colApe=mapping(find(strcmp(colNames,'APER_1')));
            colOff=mapping(find(strcmp(colNames,'APOFF_1')));
        case{90}
            colApe=mapping(find(strcmp(colNames,'APER_2')));
            colOff=mapping(find(strcmp(colNames,'APOFF_2')));
        otherwise
            error('cannot get aperture profile on planes different from hor and ver!');
            return
    end

    indices=find(geometry{colApe}~=0);
    aper=[];
    aperOff=[];
    aperS=[];
    for ii = 1:length(indices)
        if ( geometry{colL}(indices(ii)) > 0 )
            % thick element: add aperture point at upstream face
            aper=[aper geometry{colApe}(indices(ii))];
            aperOff=[aperOff geometry{colOff}(indices(ii))];
            aperS=[aperS geometry{colS}(indices(ii))-geometry{colL}(indices(ii))];
        end
        aper=[aper geometry{colApe}(indices(ii))];
        aperOff=[aperOff geometry{colOff}(indices(ii))];
        aperS=[aperS geometry{colS}(indices(ii))];
    end
    
end

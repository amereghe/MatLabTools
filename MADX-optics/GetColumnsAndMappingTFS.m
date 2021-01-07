function [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
    GetColumnsAndMappingTFS(whichTFS)
% GetColumnsAndMappingTFS     return column names, units and column
%                                    mapping of twiss tables
%
% [ colNames, colUnits, colFacts, mapping, readFormat ] =
%                                  GetColumnsAndMappingTFS(whichTFS)
%
% input arguments:
%   whichData: format of the table:
%       'optics': optics table by MAD-X;
%       'geometry': lattice geometry by MAD-X;
%
% output arguments:
%   colNames: array with name of columns/variables;
%   colUnits: array with units of columns/variables;
%   colFacts: array of multiplotcation factors to columns/variables;
%   mapping: on which column a given variable is found;
%   readFormat: format string necessary to correctly parse the file;
%
% This function states that the optics and geometry TFS tables have
% specific formats:
% - TFS table for optics:
%   NAME, KEYWORD, L, S, BETX, ALFX,  BETY, ALFY, X, PX, Y, PY,
%         DX, DPX, DY, DPY, MUX, MUY;
% - TFS table for geometry:
%   NAME, KEYWORD, L, S, KICK, HKICK, VKICK, ANGLE, K0L, K1L, K2L,
%         APERTYPE, APER_1, APER_2, APER_3, APER_4, APOFF_1, APOFF_2;
%
% See also ParseTfsTable.

    % from label to data column
    switch lower(whichTFS)
        case {'opt','optics'}
            colNames=[ "NAME" "KEYWORD" "L" "S"  "BETX" "ALFX" "BETY" "ALFY" ...
                       "X"    "PX"      "Y" "PY" "DX"   "DPX"  "DY"   "DPY"  ...
                       "MUX"  "MUY" ];
            colUnits=[ ""     ""        "m" "m"  "m"    ""     "m"    ""     ...
                       "m"    ""        "m" ""   "m"    ""     "m"    ""     ...
                       "2\pi" "2\pi"];
            mapping =[  1      2         3   4    5      6      7     8      ...
                        9      10        11  12   13     14     15    16     ...
                        17     18   ];
            colFacts = ones(1,length(colNames));
            readFormat = '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
        case {'geo','geometry'}
            colNames=[ "NAME"     "KEYWORD" "L"      "S"                                         ...
                       "KICK"     "HKICK"   "VKICK"  "ANGLE"  "K0L"    "K1L"        "K2L"        ...
                       "APERTYPE" "APER_1"  "APER_2" "APER_3" "APER_4" "APOFF_1"    "APOFF_2"    ];
            colUnits=[ ""         ""        "m"      "m"                                         ...
                       "rad"      "rad"     "rad"    "rad"    "rad"    "rad m^{-1}" "rad m^{-2}" ...
                       ""         "m"       "m"      "m"      "m"      "m"          "m"          ];
            mapping =[  1          2         3        4                                          ...
                        5          6         7        8        9        10           11          ...
                        12         13        14       15       16       17           18          ];
            colFacts = ones(1,length(colNames));
            readFormat = '%s %s %f %f %f %f %f %f %f %f %f %s %f %f %f %f %f %f %f';
        otherwise
            error('which column mapping for TFS table?');
            return
    end

end
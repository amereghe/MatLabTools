function [ colNames, colUnits, colFacts, mapping ] = ...
    GetVariablesAndMappingParticleData(whichData)
% GetVariablesAndMappingParticleData  return column names, units and column
%   mapping of particle data
%
% [ colNames, colUnits, colFacts, mapping ] = 
%                             GetVariablesAndMappingParticleData(whichData)
%
% input arguments:
%   whichData: format of the table:
%       'losses': losses out of MAD-X tracking;
%       'start': starting conditions of tracking;
%
% output arguments:
%   colNames: array with name of columns/variables
%       1: x;     2: px;     3: y;     4: py;     5: t;     6: pt;
%       7: s;     8: Etot;   9: turn; 10: ID;
%   colUnits: array with units of columns/variables
%       1: [mm];  2: [mrad]; 3: [mm];  4: [mrad]; 5: [mm];  6: []; 
%       7: [m];   8: [GeV];  9: [];   10: [];
%   colFacts: multiplication factors
%   mapping: on which column a given variable is found

    colNames=[ "x" "px" "y" "py" "t" "pt" "s" "E" "turn" "ID" ];
    colUnits=[ "mm" "10^{-3}" "mm" "10^{-3}" "mm" "10^{-3}" "m" "GeV" "" "" ];
    colFacts=[ 1000 1000 1000 1000 1000 1000 1 1 1 1 ];
    
    % from label to data column
    switch lower(whichData)
        case {'loss','losses'}
            mapping=[ 3 4 5 6 7 8 9 10 2 1 ];
        case {'start','starting'}
            mapping=[ 1 2 3 4 5 6 -1 -1 -1 -1 ];
        otherwise
            error('which column mapping for particle data?');
            return
    end

end
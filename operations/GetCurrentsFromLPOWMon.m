function [Is,comCyProgs,iDesired]=GetCurrentsFromLPOWMon(LGENnameQuery,cyProgsQuery,LGENnamesLPOWMon,cyProgsLPOWMon,currentsLPOWMon)
% GetCurrentsFromXLS         gets the current values of the queried LGEN name
%                              in the error log of the LPOW monitor
%
% NOTA BENE:
% - only one LGEN name is expected!
%
% input:
% * query data:
%   - cyProgsQuery (string(nCurrentsQuery,nSeriesQuery)):
%        cyProgs as from measurements (e.g. CAMeretta);
%   - LGENnameQuery (string(1,1)): name of the LGEN to be searched in the list
%        of values from the LPOW error log;
% * LPOW error log data (nDataLPOW)
%   - LGENnamesLPOWMon (string(nDataLPOW,1)): LGEN names in LPOW error log;
%   - cyProgsLPOWMon (string(nDataLPOW,1)): cyProgs in LPOW error log;
%   - currentsLPOWMon (float(nDataLPOW,1)): applied current values as from LPOW error log;
%
% output:
% - Is (float(nFound,1)): found values of the queried LGENs for the
%                         specified cyProgs as from LPOW error log;
% - comCyProgs (string(nFound,1)): found cyProgs of the queried LGENs for the
%                                 specified cyProgs as from LPOW error log;
% - iDesired (float(nFound,1)): indices in the found cyProgs of the queried LGENs for the
%                                 specified cyProgs as from LPOW error log;
%
% See also: BuildCurrentTable.
%
    Is=missing(); comCyProgs=missing(); iDesired=missing(); % default: LGEN is not in LPOW error log
    % check
    fprintf("looking for LGEN %s in values for LPOW monitor...\n",LGENnameQuery);
    tmpIndices=(LGENnameQuery==LGENnamesLPOWMon);
    if ( ~any(tmpIndices) )
        fprintf("...NOT found!\n");
    else
        tmpCyProgs=cyProgsLPOWMon(tmpIndices);
        tmpIs=currentsLPOWMon(tmpIndices);
        [tmpComCyProgs,ia,ib]=intersect(cyProgsQuery,tmpCyProgs);
        if ( isempty(tmpComCyProgs) )
            fprintf("...found NO values;\n");
        else
            Is=tmpIs(ib);
            comCyProgs=tmpComCyProgs;
            iDesired=ia;
            fprintf("...found %d values;\n",size(Is,1));
        end
    end
    fprintf("...done.\n");
end

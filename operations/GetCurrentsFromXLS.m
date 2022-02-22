function [Is]=GetCurrentsFromXLS(LGENnameQuery,currentsXLS,LGENnamesXLS)
% GetCurrentsFromXLS         gets the current values of the queried LGEN name
%                              in the .xlsx table of the scan
%
% NOTA BENE:
% - only one LGEN name is expected!
%
% input:
% * query data:
%   - LGENnameQuery (string(1,1)): name of the LGEN to be searched in TM repo;
% * XLS data: data found in .xlsx file (nDataXLS,nLGENsXLS):
%   - currentsXLS (float(nDataXLS,nLGENsXLS)): table of scan currents as from .xlsx;
%   - LGENnamesXLS (string(nLGENsXLS,1)): name of LGENs in .xlsx;
%
% output:
% - Is (float(nFound,1)): found current values of the queried LGENs for the
%                         specified cyCodes as from .xlsx file;
%
% See also BuildCurrentTable;
%
    Is=missing(); % default: LGEN is not in XLS file of scans
    % check
    fprintf("looking for LGEN %s in values from XLS of scanned currents...\n",LGENnameQuery);
    tmpIndices=(LGENnamesXLS==LGENnameQuery);
    if ( ~any(tmpIndices) )
        fprintf("...NOT found!\n");
    else
        if ( sum(tmpIndices)>1 )
            fprintf("...more than an occurrence found! using last one...\n");
            tmpIndices=tmpIndices(end);
        end
        Is=currentsXLS(:,tmpIndices);
        fprintf("...found %d values;\n",size(Is,1));
    end
    fprintf("...done.\n");
end

function [Is,comCyCodes,iDesired]=GetCurrentsFromTM(LGENnameQuery,cyCodesQuery,LGENnamesTM,cyCodesTM,currentsTM)
% GetCurrentsFromTM          gets the current values of the queried LGEN name for
%                              the specified cyCodes as in TM repo
%
% NOTA BENE:
% - only one LGEN name is expected!
% - only a single list (i.e. array) of cyCodes is expected!
%
% input:
% * query data:
%   - cyCodesQuery (string(nCurrentsQuery,1)): cyCodes to be searched in TM repo;
%   - LGENnameQuery (string(1,1)): name of the LGEN to be searched in TM repo;
% * DB data: TM data from repo (nDataTM,nLGENnamesTM):
%   - LGENnamesTM (string(nLGENnamesTM,1)): name of LGENs in TM repo;
%   - cyCodesTM (string(nDataTM,1)): cyCodes in TM repo;
%   - currentsTM (float(nDataTM,nLGENnamesTM)): currents in TM repo;
%
% output:
% - Is (float(nFound,1)): found TM values of the queried LGENs for the
%                         specified cyCodes as from TM repo;
% - comCyCodes (string(nFound,1)): found cyCodes of the queried LGENs for the
%                                 specified cyCodes as from TM repo;
% - iDesired (float(nFound,1)): indices in the found cyCodes of the queried LGENs for the
%                                 specified cyCodes as from TM repo;
%
% See also BuildCurrentTable;
%
    Is=missing(); comCyCodes=missing(); iDesired=missing(); % default: LGEN is not in TM
    % check
    fprintf("looking for LGEN %s in TM values...\n",LGENnameQuery);
    tmpLGENIndices=(LGENnamesTM==LGENnameQuery);
    if ( ~any(tmpLGENIndices) )
        fprintf("...NOT found!\n");
    else
        if ( sum(tmpLGENIndices)>1 )
            fprintf("...more than an occurrence found! using last one...\n");
            tmpLGENIndices=tmpLGENIndices(end);
        end
        [rangeCodes,partCodes]=DecodeCyCodes(cyCodesQuery);
        [~,tmpCyCodesIndices]=ismember(rangeCodes,cyCodesTM);
        Is=currentsTM(tmpCyCodesIndices(tmpCyCodesIndices>0),tmpLGENIndices);
        comCyCodes=cyCodesTM(tmpCyCodesIndices(tmpCyCodesIndices>0));
        iDesired=find(tmpCyCodesIndices>0);
        fprintf("...found in %d values;\n",size(Is,1));
    end
    fprintf("...done.\n");
end

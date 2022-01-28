function [currentTable]=BuildCurrentTable(cyCodesQuery,cyProgsQuery,LGENnamesQuery,...
    currentsXLS,LGENnamesXLS,LGENnamesTM,cyCodesTM,currentsTM,...
    LGENnamesLPOWMon,cyProgsLPOWMon,currentsLPOWMon,indices)
% BuildCurrentTable          builds the table of current values used in a
%                              magnet scan
%
% The function tries to build a current table based on:
% - query infos: one or more lists of cyProgs and corresponding cyCodes for
%   a bunch of LGEN names: nCurrentsQuery \times nSeriesQuery \times nLGENnamesQuery;
% - current values in the .xlsx file of LGENs: nDataXLS \times nLGENsXLS;
% - current values in TM repository: nDataTM \times nLGENnamesTM;
% - current values in LPOW error log (if present): nDataLPOW;
%
% Nota Bene
% - the proper alignment between current data and monitor data is recorded
%   in the indices var;
%
% input:
% * query data:
%   - cyCodesQuery,cyProgsQuery (string(nCurrentsQuery,nSeriesQuery)):
%        cyCodes and cyProgs as from measurements (e.g. CAMeretta);
%   - LGENnamesQuery (string(1,nLGENnamesQuery)): name of LGENs for which the table
%        should be built;
% * DB data:
%   ** XLS (nDataXLS,nLGENsXLS):
%      - currentsXLS (float(nDataXLS,nLGENsXLS)): table of scan currents as from .xlsx;
%      - LGENnamesXLS (string(nLGENsXLS,1)): name of LGENs in .xlsx;
%   ** TM data from repo (nDataTM,nLGENnamesTM):
%      - LGENnamesTM (string(nLGENnamesTM,1)): name of LGENs in TM repo;
%      - cyCodesTM (string(nDataTM,1)): cyCodes in TM repo;
%      - currentsTM (float(nDataTM,nLGENnamesTM)): currents in TM repo;
%   ** LPOW error log data (nDataLPOW)
%      - LGENnamesLPOWMon (string(nDataLPOW,1)): LGEN names in LPOW error log;
%      - cyProgsLPOWMon (string(nDataLPOW,1)): cyProgs in LPOW error log;
%      - currentsLPOWMon (float(nDataLPOW,1)): applied current values as from LPOW error log;
%  - indices (float(1+nSeriesQuery,2)): min and max indices of the points
%    of the actual scan in the (cyCodesQuery,cyProgsQuery) series and in
%    the currentsXLS array;
%    NB: first index refers to currents in .xlsx file;
%
% output:
% - currentTable (float(totNCurrents,,nLGENnamesQuery,nSeriesQuery)): table of
%   queried currents;
%
% See also: GetCurrentsFromLPOWMon, GetCurrentsFromTM and GetCurrentsFromXLS.
%
    fprintf("building table of currents based on LPOW error log, XLS of scans and TM values...\n");
    nCurrentsQuery=size(cyProgsQuery,1);
    nSeriesQuery=size(cyProgsQuery,2);
    nCurrs=max(size(currentsXLS,1),nCurrentsQuery);
    nLGENnamesQuery=length(LGENnamesQuery);
    
    iAdds=zeros(nSeriesQuery+1,1);
    if ( exist('indices','var') ), iAdds=AlignDataIndices(indices); end
    currentTable=NaN(nCurrs+max(iAdds),nLGENnamesQuery,nSeriesQuery);
    
    for iLGEN=1:nLGENnamesQuery
        fprintf("looking for LGEN %s current values used for measurements...\n",LGENnamesQuery(iLGEN));
        for iSeries=1:nSeriesQuery
            fprintf("...scan #%d...\n",iSeries);
            
            % get TM currents
            [Is,comCyCodes,iDesired]=GetCurrentsFromTM(LGENnamesQuery(iLGEN),cyCodesQuery(:,iSeries),LGENnamesTM,cyCodesTM,currentsTM);
            if ( ~ismissing(Is) ), currentTable(iDesired+iAdds(1+iSeries),iLGEN,iSeries)=Is; end
            
            % get currents from XLS
            [Is]=GetCurrentsFromXLS(LGENnamesQuery(iLGEN),currentsXLS,LGENnamesXLS);
            if ( ~ismissing(Is) ), currentTable((1:length(Is))+iAdds(1),iLGEN,iSeries)=Is; end
            
            % get currents from LPOW error log
            if ( ~ismissing(LGENnamesLPOWMon) )
                [Is,comCyProgs,iDesired]=GetCurrentsFromLPOWMon(LGENnamesQuery(iLGEN),cyProgsQuery(:,iSeries),LGENnamesLPOWMon,cyProgsLPOWMon,currentsLPOWMon);
                if ( ~ismissing(Is) ), currentTable(iDesired+iAdds(1+iSeries),iLGEN,iSeries)=Is; end
            end
        end
    end
    
    fprintf("...done.\n");
end

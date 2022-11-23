function [Is,LGENnames,nData]=AcquireCurrentData(fileName,sheetName)
% AcquireCurrentData      reads a .xlsx file with current values used in
%                           scans
%
% input:
% - fileName (string): fullname of file to be parsed;
% - sheetName (string, optional): name of sheet containing data (default:
%   "Foglio1");
%
% output:
% - Is [float(nData,nLGENs)]: matrix with current values read in .xlsx file;
% - LGENnames [string(nLGENs)]: name of LGEN parsed in file;
% - nData [scalar]: number of current values;

    if ( ~exist('sheetName','var') )
        sheetName="Foglio1";
        sheetNames=sheetnames(fileName);
        if ( sum(strcmpi(sheetNames,"Sheet1"))>0 )
            sheetName="Sheet1";
        end
    end
    
    % parsing file
    fprintf("parsing current file %s, sheet %s ...\n",fileName,sheetName);
    C=readcell(fileName,"Sheet",sheetName,"NumHeaderLines",1);

    % storing data
    Is=cell2mat(C(:,3:end))';
    LGENnames=string(C(:,1));
    nData=size(Is,1);
    
    fprintf("...acquired %d current values;\n",nData);
end

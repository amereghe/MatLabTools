% {}~

%% description
% this is a script which parses DCT files and plots them

%% include libraries
% - include Matlab libraries
pathToLibrary="..\externalMatLabTools";
addpath(genpath(pathToLibrary));
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath DCTpaths

kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
DCTpathMain="\Area dati MD\00monitoraggio\corrente\dct";

DCTpaths=[...
%     strcat(kPath,DCTpathMain,"\*\28-03-2022\dct-*_*_*.txt") 
%     strcat(kPath,DCTpathMain,"\*\29-03-2022\dct-*_*_*.txt") 
%     strcat(kPath,DCTpathMain,"\*\30-03-2022\dct-*_*_*.txt") 
    strcat(kPath,DCTpathMain,"\*\31-03-2022\dct-*_*_*.txt") 
    strcat(kPath,DCTpathMain,"\*\*-04-2022\dct-*_*_*.txt") 
    ];

%% parse files
clear DCTcyProgs DCTcyCodes DCTcurrs DCTtStamps Eks

% - parse DCT log files
[DCTcyProgs,DCTcyCodes,DCTcurrs,DCTtStamps]=ParseDCTFiles(DCTpaths);
if (length(DCTcurrs)<=1), error("...no data aquired, nothing to plot!"); end

% - get Eks corresponding to list of cyCodes
Eks=ConvertCyCodes(DCTcyCodes,"Ek","MeVvsCyCo_P.xlsx");
mms=ConvertCyCodes(DCTcyCodes,"mm","MeVvsCyCo_P.xlsx");

%% show data
ShowDCTtime(DCTtStamps,DCTcurrs(:,1),DCTcyCodes,Eks,"DCT-Acc\_Part [10^9]","HEBT E_k [MeV/u]");
ShowDCThistograms(DCTcurrs(:,1),DCTcyCodes,Eks,"DCT-Acc\_Part [10^9]","HEBT E_k [MeV/u]");
%
ShowDCTtime(DCTtStamps,DCTcurrs(:,2),DCTcyCodes,mms,"DCT-Inj\_Part [10^9]","HEBT range in water [mm]");
ShowDCThistograms(DCTcurrs(:,2),DCTcyCodes,mms,"DCT-Inj\_Part [10^9]","HEBT range in water [mm]");
%
ShowDCTtime(DCTtStamps,DCTcurrs(:,1)./DCTcurrs(:,2),DCTcyCodes,Eks,"T_{Acc/Inj} []","HEBT E_k [MeV/u]");
ShowDCThistograms(DCTcurrs(:,1)./DCTcurrs(:,2),DCTcyCodes,Eks,"T_{Acc/Inj} []","HEBT E_k [MeV/u]");

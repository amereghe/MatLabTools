% {}~

%% description
% this is a basic script which parses DCT files and plots them:
% - the script crunches as many DCT files as desired, provided the
%   fullpaths;
% - the script shows a spill-per-spill time evolution of the DCT current,
%   togethere with beam energy/water range, and some statistics data vs 
%   beam energy/water range;
% - the user can customize what to plot. By default, Acc_Part, Inj_Part and
%   Acc_Part/Inj_Part vs beam energy;
% - time plots show data for carbon and protons with different colors;
% - statistics plots show data for carbon separated from that of protons;

%% include libraries
% - include Matlab libraries
pathToLibrary="..\externalMatLabTools";
addpath(genpath(pathToLibrary));
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath DCTpaths

% -------------------------------------------------------------------------
% USER's input data
kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
DCTpathMain="\Area dati MD\00monitoraggio\corrente\dct";
DCTpaths=[...
    strcat(kPath,DCTpathMain,"\*\31-03-2022\dct-*_*_*.txt") 
    strcat(kPath,DCTpathMain,"\*\*-04-2022\dct-*_*_*.txt") 
    ];
% -------------------------------------------------------------------------

%% parse files
clear DCTcyProgs DCTcyCodes DCTcurrs DCTtStamps Eks

% - parse DCT log files
[DCTcyProgs,DCTcyCodes,DCTcurrs,DCTtStamps]=ParseDCTFiles(DCTpaths);
if (length(DCTcurrs)<=1), error("...no data aquired, nothing to plot!"); end

% - get Eks corresponding to list of cyCodes
Eks=ConvertCyCodes(DCTcyCodes,"Ek","MeVvsCyCo_P.xlsx");
mms=ConvertCyCodes(DCTcyCodes,"mm","MeVvsCyCo_P.xlsx");

% -------------------------------------------------------------------------
% - data to show and labels (user's input)
dataToShow=[DCTcurrs*1E9 DCTcurrs(:,1)./DCTcurrs(:,2)];
labelsToShow=["DCT-Acc\_Part []" "DCT-Inj\_Part []" "T_{Acc/Inj} []"];
% -------------------------------------------------------------------------

%% show data
ShowDCTtime(DCTtStamps,dataToShow,DCTcyCodes,Eks,labelsToShow,"HEBT E_k [MeV/u]");
ShowDCThistograms(dataToShow,DCTcyCodes,Eks,labelsToShow,"HEBT E_k [MeV/u]");

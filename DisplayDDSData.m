% {}~

%% description
% this is a script which parses DDS files and plots them

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath DDSpathMain DDSpaths

kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
DDSpathMain="T:\AMereghetti\DDS_for_RP";

DDSpaths=[...
    strcat(DDSpathMain,"\PRC-544-220410*") 
    ];

%% parse files
% - clear summary data
clear DScyProgsSumm DDScyCodesSumm DDSbarsSumm DDSfwhmsSumm DDSasymsSumm DDSintsSumm
% - clear profiles
clear DDSprofiles DDScyCodes DDScyProgs

% - parse DDS summary files
[DScyProgsSumm,DDScyCodesSumm,DDSbarsSumm,DDSfwhmsSumm,DDSasymsSumm,DDSintsSumm]=ParseCAMSummaryFiles(DDSpaths+"\Data-*.csv","DDS",0);
if (length(DScyProgsSumm)<=1), error("...no summary data aquired!"); end
% - parse DDS profiles
[DDSprofiles,DDScyCodes,DDScyProgs]=ParseDDSProfiles(DDSpaths+"\Profiles\Data-*.csv");
if (length(DDScyProgs)<=1), error("...no summary data aquired!"); end

if ( length(DScyProgsSumm)~=length(DDScyProgs) ), error("...inconsistent data set between summary data and actual profiles"); end

%% show data
% - 3D plot
ShowSpectra(DDSprofiles,sprintf("DDS profiles in %s",DDSpathMain));
% - series
ShowDDSSummaryData(DDSbarsSumm,DDSfwhmsSumm,DDSasymsSumm,DDSintsSumm);

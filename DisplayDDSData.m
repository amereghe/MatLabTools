% {}~

%% description
% this is a script which parses DDS files and plots them

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath DDSpathMain DDSpaths DDSsummFiles DDSprofFiles

kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
DDSpathMain="T:\AMereghetti\DDS_for_RP";

DDSpaths=[
    strcat(DDSpathMain,"\PRC-544-220410*") 
    ];

DDSsummFiles=DDSpaths+"\Data-*.csv";
DDSprofFiles=DDSpaths+"\Profiles\Data-*.csv";

%% parse files
% - clear summary data
clear DDScyProgsSumm DDScyCodesSumm DDSbarsSumm DDSfwhmsSumm DDSasymsSumm DDSintsSumm
% - clear profiles
clear DDSprofiles DDScyCodes DDScyProgs

% - parse DDS summary files
[DDScyProgsSumm,DDScyCodesSumm,DDSbarsSumm,DDSfwhmsSumm,DDSasymsSumm,DDSintsSumm]=ParseCAMSummaryFiles(DDSsummFiles,"DDS",0);
if (length(DDScyProgsSumm)<=1), error("...no summary data aquired!"); end
% - parse DDS profiles
[DDSprofiles,DDScyCodes,DDScyProgs]=ParseDDSProfiles(DDSprofFiles,"DDS");
if (length(DDScyProgs)<=1), error("...no summary data aquired!"); end
% - get statistics out of profiles
[BARs,FWHMs,INTs]=StatDistributionsBDProcedure(DDSprofiles);

if ( length(DDScyProgsSumm)~=length(DDScyProgs) ), error("...inconsistent data set between summary data and actual profiles"); end

%% show data
% - 3D plot
ShowSpectra(DDSprofiles,sprintf("DDS profiles in %s",DDSpathMain));
% - series
ShowDDSSummaryData(DDSbarsSumm,DDSfwhmsSumm,DDSasymsSumm,DDSintsSumm);
% - compare summary data and statistics on profiles
CompareDDSSummaryAndProfiles(DDSbarsSumm,DDSfwhmsSumm,DDSintsSumm,BARs,FWHMs,INTs);

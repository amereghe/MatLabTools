% {}~

%% description
% this is a script which parses DDS files and plots them
% - the script crunches as many DDS files as desired, provided the
%   fullpaths;
% - both summary files and actual profiles in the same path are aquired;
% - the script visualises in 3D the spill-per-spill profiles, horizontal and
%   vertical planes separately;
% - the script shows summary data, and compares summary data against
%   statistics data computed on profiles;

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath DDSpathMain DDSpaths DDSsummFiles DDSprofFiles

% -------------------------------------------------------------------------
% USER's input data
kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
DDSpathMain="T:\AMereghetti\DDS_for_RP";
DDSpaths=[...
    strcat(DDSpathMain,"\PRC-544-220410-2143") 
    strcat(DDSpathMain,"\PRC-544-220410-2204") 
    strcat(DDSpathMain,"\PRC-544-220410-2208") 
    strcat(DDSpathMain,"\PRC-544-220410-2210") 
    ];
DDSsummFiles=DDSpaths+"\Data-*.csv";
DDSprofFiles=DDSpaths+"\Profiles\Data-*.csv";
% -------------------------------------------------------------------------

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
if (length(DDScyProgs)<=1), error("...no profiles aquired!"); end
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

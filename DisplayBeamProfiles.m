% {}~

%% description
% this is a script which parses DDS/CAMeretta files and plots them
% - the script crunches as many DDS/CAMeretta files as desired, provided the
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
clear kPath MonPathMain MonPaths SummFiles ProfFiles

% -------------------------------------------------------------------------
% USER's input data
kPath="S:\Area Ricerca\EMITTANZE SUMMARY\EMITTANZE SUMMARY";
% kPath="K:";
MonPathMain="\2022\Emittanze 2022\secondo giro\Scan U1-08-H23";
MonPaths=[...
    strcat(kPath,MonPathMain,"\CarbSO1_LineU_Size6_13-03-2022_2002") 
%     strcat(kPath,MonPathMain,"\PRC-544-220313-2001") 
    ];
monType="CAM"; % DDS, CAM
myFigTitle=monType;
% -------------------------------------------------------------------------

%% parse files
% - files to crunch:
switch upper(monType)
    case "DDS"
        SummFiles=MonPaths+"\Data-*.csv";
        ProfFiles=MonPaths+"\Profiles\Data-*.csv";
    case "CAM"
        SummFiles=MonPaths+"\*summary.txt";
        ProfFiles=MonPaths+"\profiles\*_profiles.txt";
    otherwise
        error("Mon type NOT recognised: %s! - presently only DDS and CAM are available",monType);
end

% - clear summary data
clear cyProgsSumm cyCodesSumm BarsSumm FwhmsSumm AsymsSumm IntsSumm
% - clear profiles
clear profiles cyCodes cyProgs

% - parse summary files
[cyProgsSumm,cyCodesSumm,BarsSumm,FwhmsSumm,AsymsSumm,IntsSumm]=ParseCAMSummaryFiles(SummFiles,monType,0);
if (length(cyProgsSumm)<=1), error("...no summary data aquired!"); end

% - parse profiles
[profiles,cyCodes,cyProgs]=ParseDDSProfiles(ProfFiles,monType);
if (length(cyProgs)<=1), error("...no profiles aquired!"); end
% - get statistics out of profiles
switch upper(monType)
    case "CAM"
        [BARs,FWHMs,INTs]=StatDistributionsCAMProcedure(profiles);
    otherwise
        [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles);
end

% - quick check of consistency of parsed data
if ( length(cyProgsSumm)~=length(cyProgs) ), error("...inconsistent data set between summary data and actual profiles"); end

%% show data
% - 3D plot
ShowSpectra(profiles,sprintf("%s profiles in %s",monType,MonPathMain));
% - series
ShowBeamProfilesSummaryData(BarsSumm,FwhmsSumm,AsymsSumm,IntsSumm,myFigTitle);
% - compare summary data and statistics on profiles
CompBars=BarsSumm; CompBars(:,:,2)=BARs;
CompFwhms=FwhmsSumm; CompFwhms(:,:,2)=FWHMs;
CompInts=IntsSumm; CompInts(:,:,2)=INTs;
CompareStats(CompBars,CompFwhms,CompInts,missing(),["stat on profiles" "summary data"]);

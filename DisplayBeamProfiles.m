% {}~

%% description
% this is a script which parses beam profiles files and plots them
% - the script crunches as many files as desired, provided the fullpaths;
% - for the time being, only CAMeretta/DDS/SFH/SFM monitors;
%   QBM/GIM/PMM/PIB/SFP are NOT supported but the implementation should be
%   straightforward;
% - for CAMeretta/DDS: both summary files and actual profiles in the same
%   path are aquired;
% - for SFH/SFM: profiles are acquired, but only the integral ones are
%   shown;
% - the script visualises in 3D the spill-per-spill profiles, horizontal and
%   vertical planes separately;
% - the script shows summary data; for CAMeretta/DDS only, the script also
%   compares summary data against statistics data computed on profiles;

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath MonPathMain MonPaths SummFiles ProfFiles

% -------------------------------------------------------------------------
% USER's input data
kPath="D:\GuessOptics\data\PROTON\090mm\HEBT";
% kPath="K:";
MonPathMain="\alone_H5-009A-QUE";
MonPaths=[...
    strcat(kPath,MonPathMain,"\PRC-544-220109-0259_U1-021B-SFM") 
    ];
monType="SFM"; % DDS, CAM, SFH/SFM - QBM/GIM/PMM/PIB/SFP to come
myTit=sprintf("%s profiles in %s",monType,MonPathMain);
% -------------------------------------------------------------------------

%% parse files
% - files to crunch:
switch upper(monType)
    case "CAM"
        SummFiles=MonPaths+"\*summary.txt";
        ProfFiles=MonPaths+"\profiles\*_profiles.txt";
    case "DDS"
        SummFiles=MonPaths+"\Data-*.csv";
        ProfFiles=MonPaths+"\Profiles\Data-*.csv";
    case {"SFH","SFM"}
        ProfFiles=MonPaths+"\Data-*.csv";
    otherwise
        error("Mon type NOT recognised: %s! - presently only CAM/DDS/SFM/SFH are available",monType);
end

% - clear summary data
clear cyProgsSumm cyCodesSumm BarsSumm FwhmsSumm AsymsSumm IntsSumm
% - clear profiles
clear profiles cyCodes cyProgs

% - parse files
switch upper(monType)
    case {"CAM","DDS"}
        % - parse summary files
        [cyProgsSumm,cyCodesSumm,BarsSumm,FwhmsSumm,AsymsSumm,IntsSumm]=ParseCAMSummaryFiles(SummFiles,monType,0);
        if (length(cyProgsSumm)<=1), error("...no summary data aquired!"); end
        % - parse profiles
        [profiles,cyCodes,cyProgs]=ParseDDSProfiles(ProfFiles,monType);
        if (length(cyProgs)<=1), error("...no profiles aquired!"); end
        % - quick check of consistency of parsed data
        if ( length(cyProgsSumm)~=length(cyProgs) ), error("...inconsistent data set between summary data and actual profiles"); end
    
    otherwise % SFH,SFM
        % - parse profiles
        [diffProfiles,cyCodes,cyProgs]=ParseSFMData(ProfFiles,monType);
        if (length(cyProgs)<=1), error("...no profiles aquired!"); end
        % - get integral profiles
        profiles=SumSpectra(diffProfiles); 
end

% - get statistics out of profiles
if ( strcmpi(monType,"CAM") )
    [BARs,FWHMs,INTs]=StatDistributionsCAMProcedure(profiles);
else
    [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles);
end

%% show data
% - 3D plot
ShowSpectra(profiles,sprintf("%s - 3D profiles",myTit));
% - other plots
if ( strcmpi(monType,"CAM") || strcmpi(monType,"DDS") )
    % - series
    ShowBeamProfilesSummaryData(BarsSumm,FwhmsSumm,IntsSumm,AsymsSumm,missing(),"summary data",missing(),myTit);
    % - compare summary data and statistics on profiles
    CompBars=BarsSumm; CompBars(:,:,2)=BARs;
    CompFwhms=FwhmsSumm; CompFwhms(:,:,2)=FWHMs;
    CompInts=IntsSumm; CompInts(:,:,2)=INTs;
    ShowBeamProfilesSummaryData(CompBars,CompFwhms,CompInts,missing(),missing(),["stat on profiles" "summary data"],missing(),sprintf("%s - summary vs profile stats",myTit));
else
    % - series
    ShowBeamProfilesSummaryData(BARs,FWHMs,INTs,missing(),missing(),"integral profiles",missing(),myTit);
end

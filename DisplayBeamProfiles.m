% {}~

%% description
% this is a script which parses beam profiles files and plots them
% - the script crunches as many files as desired, provided the fullpaths;
% - for the time being, only CAMeretta/DDS/SFH/SFM/SFP monitors;
%   QBM/GIM/PMM/PIB are NOT supported but the implementation should be
%   straightforward;
% - for CAMeretta/DDS: both summary files and actual profiles in the same
%   path are aquired;
% - for SFH/SFM/SFP: profiles are acquired, but only the integral ones are
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
kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\23-08-2022";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\13-09-2022";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\13-09-2022\post-steering";
MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\2022-10-08\pre-steering";
% MonPathMain="\scambio\Alessio\2022-10-09\BD_Scans\HE-030B-SFP\P_030mm";
MonPaths=[...
    strcat(kPath,MonPathMain,"\PRC-544-*-SFP") 
    ];
monType="SFP"; % DDS, CAM, SFH/SFM - QBM/GIM/PMM/PIB/SFP to come
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
    case {"SFH","SFM","SFP"}
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
    
    otherwise % SFH,SFM,SFP
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
    if ( strcmpi(monType,"SFP") )
        noiseLevel=0.1;
        INTlevel=5;
        lDebug=true;
        [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles,noiseLevel,INTlevel,lDebug);
    else
        [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles);
    end
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
    ShowBeamProfilesSummaryData(CompBars,CompFwhms,CompInts,missing(),missing(),["summary data" "stat on profiles"],missing(),sprintf("%s - summary vs profile stats",myTit));
else
    % - series
    ShowBeamProfilesSummaryData(BARs,FWHMs,INTs,missing(),missing(),"integral profiles",missing(),myTit);
end

%% save summary data
oFileName=strcat(kPath,"\scambio\Alessio\Carbonio_preSteering_summary-from-profiles.csv");
SaveSummary(oFileName,BARs,FWHMs,INTs,cyCodes,cyProgs,"DDS");

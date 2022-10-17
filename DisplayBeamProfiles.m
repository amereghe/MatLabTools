% {}~

%% description
% this is a script which parses beam profiles files and plots them
% - the script crunches as many files as desired, provided the fullpaths;
% - for the time being, only CAMeretta/DDS/GIM/SFH/SFM/SFP monitors;
%   QBM/PMM/PIB are NOT supported but the implementation should be
%   straightforward;
% - for CAMeretta/DDS/GIM: both summary files and actual profiles in the same
%   path are aquired;
% - for GIM/SFH/SFM/SFP: profiles are acquired, but only the integral ones are
%   shown;
% - the script visualises in 3D the spill-per-spill profiles, horizontal and
%   vertical planes separately;
% - the script shows summary data; for CAMeretta/DDS/GIM only, the script also
%   compares summary data against statistics data computed on profiles;

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings
clear kPath MonPathMain MonPaths SummFiles ProfFiles

% -------------------------------------------------------------------------
% USER's input data
% kPath="S:\Accelerating-System\Accelerator-data";
kPath="P:\Accelerating-System\Accelerator-data";
% kPath="K:";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\23-08-2022";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\13-09-2022";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\13-09-2022\post-steering";
% MonPathMain="\Area dati MD\00XPR\XPR3\Protoni\MachinePhoto\2022-10-08\pre-steering";
% MonPathMain="\scambio\Alessio\2022-10-09\BD_Scans\HE-030B-SFP\P_030mm";
% GIM in and He-025B-SFM
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMIN\Hor\2022-08-22";
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMIN\Ver\2022-08-22";
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMIN\Hor\2022-07-19";
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMIN\Ver\2022-07-19";
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMOUT\Hor\2022-09-12_varieEnergie";
% MonPathMain="\Area dati MD\00sfh\Recal_H2025SFM\GIMOUT\Hor\2022-10-02_270mm";
% - GIM profiles
MonPathMain="\Area dati MD\00Summary\Carbonio\2022\09-Settembre\30-09-2022\GIM";
% MonPathMain="\Area dati MD\00Summary\Protoni\2022\09-Settembre\30-09-2022\GIM";
MonPaths=[...
%     strcat(kPath,MonPathMain,"\ProtSO1_*") 
    strcat(kPath,MonPathMain,"\PRC-544-*\") 
    ];
monType="GIM"; % CAM, DDS, GIM, SFH/SFM - QBM/PMM/PIB/SFP to come
myTit=sprintf("%s profiles in %s",monType,MonPathMain);
% -------------------------------------------------------------------------

%% parse files
% - clear summary data
clear cyProgsSumm cyCodesSumm BarsSumm FwhmsSumm AsymsSumm IntsSumm
% - clear profiles
clear profiles cyCodes cyProgs

% - parse profiles
if ( strcmpi(monType,"CAM") | strcmpi(monType,"DDS") )
    [profiles,cyCodes,cyProgs]=ParseBeamProfiles(MonPaths,monType);
    if (length(cyProgs)<=1), error("...no profiles aquired!"); end
else % GIM,SFH,SFM,SFP
    [diffProfiles,cyCodes,cyProgs]=ParseBeamProfiles(MonPaths,monType);
    if (length(cyProgs)<=1), error("...no profiles aquired!"); end
    % - get integral profiles
    profiles=SumSpectra(diffProfiles); 
end

% - parse summary files
if ( strcmpi(monType,"CAM") | strcmpi(monType,"DDS") | strcmpi(monType,"GIM") )
    [cyProgsSumm,cyCodesSumm,BarsSumm,FwhmsSumm,AsymsSumm,IntsSumm]=ParseBeamProfileSummaryFiles(MonPaths,monType);
    if (length(cyProgsSumm)<=1), error("...no summary data aquired!"); end
    % - quick check of consistency of parsed data
    if (length(cyProgsSumm)~=length(cyProgs)), error("...inconsistent data set between summary data and actual profiles"); end
end

% - get statistics out of profiles
switch upper(monType)
    case "CAM"
        [BARs,FWHMs,INTs]=StatDistributionsCAMProcedure(profiles);
    case "SFP"
        noiseLevel=0.1;
        INTlevel=5;
        lDebug=true;
        [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles,noiseLevel,INTlevel,lDebug);
    otherwise % BD: DDS,GIM,SFH,SFM
        [BARs,FWHMs,INTs]=StatDistributionsBDProcedure(profiles);
end

%% get Eks corresponding to list of cyCodes
clear Eks; Eks=ConvertCyCodes(cyCodes,"Ek","MeVvsCyCo_P.xlsx");
clear mms; mms=ConvertCyCodes(cyCodes,"mm","MeVvsCyCo_P.xlsx");

%% show data
% - 3D plot
ShowSpectra(profiles,sprintf("%s - 3D profiles",myTit),mms,"Range [mm]");
% - other plots
switch upper(monType)
    case {"CAM","DDS","GIM"}
        % - series
        ShowBeamProfilesSummaryData(BarsSumm,FwhmsSumm,IntsSumm,AsymsSumm,missing(),"summary data",missing(),myTit);
        % - compare summary data and statistics on profiles
        CompBars=BarsSumm; CompBars(:,:,2)=BARs;
        CompFwhms=FwhmsSumm; CompFwhms(:,:,2)=FWHMs;
        CompInts=IntsSumm; CompInts(:,:,2)=INTs;
        ShowBeamProfilesSummaryData(CompBars,CompFwhms,CompInts,missing(),missing(),["summary data" "stat on profiles"],missing(),sprintf("%s - summary vs profile stats",myTit));
    otherwise % SFH,SFM,SFP
        % - series
        ShowBeamProfilesSummaryData(BARs,FWHMs,INTs,missing(),missing(),"integral profiles",missing(),myTit);
end

%% save summary data
oFileName=strcat(kPath,"\scambio\Alessio\Carbonio_preSteering_summary-from-profiles.csv");
SaveSummary(oFileName,BARs,FWHMs,INTs,cyCodes,cyProgs,"DDS");

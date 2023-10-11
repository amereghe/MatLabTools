% {}~

%% description
% this is a script which parses files with beam iles vs time and plots them
%   as 2D histograms (iles vs time), giving also 1D histograms showing:
%   - sum distributions;
%   - evolution with time of integral;
% A single figure is shown per plane; for every extraction, new figures are
%   generated. A summary plot, showing the evolution of stats with time, is
%   shown as well.
%
% NOTA BENE: given the large amount of data, the script can crunch (for the
%            time being) only a single series of extractions;
%

%% default stuff
% -------------------------------------------------------------------------
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));
% - some clean up
clear all;
close all;

%% USER's input data
% -------------------------------------------------------------------------
MonPaths=[
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2213\"
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2219\"
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2222\";
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2225\";
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2227\";
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2229\";
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2231\";
    "P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2233\";
];
monTypes="CAMdumps";
myLabels=[
    "test 1: H scan (1E6 per spot)"
    "test 2: grid (1E6 per spot)"
    "test 3: V scan (1E6 per spot)"
    "test 4: V scan (1.2E6 per spot)"
    "test 5: V scan (1.2E6 per spot)"
    "test 6: H scan (1.2E6 per spot)"
    "test 7: H scan (1.2E6 per spot)"
    "test 8: grid (1.2E6 per spot)"
];
myFigPath=".";
myFigName="TestsWithDDS";
myTit="Tests with DDS";

% skip fibers/channels?
iNotCons=false(127,2); 
iNotCons(1:2,1)=true;  % do not consider left-most fibers on hor plane (broken)
lConcatenate=true;     % concatenate all extractions as if only a long one took place
lSuperImposeStats=false;

%% check USER's input data
% -------------------------------------------------------------------------
if ( length(MonPaths)~=length(myLabels) )
    error("number of paths different from number of labels: %d~=%d",length(MonPaths),length(myLabels));
else
    nDataSets=length(MonPaths);
end
if (length(monTypes)~=nDataSets)
    if ( length(monTypes)==1 )
        myStrings=strings(nDataSets,1);
        myStrings(:,1)=monTypes;
        monTypes=myStrings;
    else
        error("please specify a label for each data set");
    end
end
if (~exist("lConcatenate","var")), lConcatenate=false; end
if (~exist("iNotCons","var")), iNotCons=NaN(1,2); end
if (~exist("lSuperImposeStats","var")), lSuperImposeStats=false; end

%% set up running vars
% - plotting style:
myConts=missing(); lHist=true; lSquared=false; lBinEdges=false;
yLab="t [ms]";
planes=["HOR" "VER"];
xLabs=[ "x [mm]" "y [mm]" ];
FWHM2sig=2*sqrt(2*log(2));

%% crunch stuff
for iDataAcq=1:nDataSets

    % for saving figures
    figNameCase=myLabels(iDataAcq);
    figNameCase=strrep(figNameCase," ","");
    figNameCase=strrep(figNameCase,":","-");
    
    %% parse profiles
    clear tmpDiffiles tmpCyProgs tmpCyCodes tmpTimes ProfsToCrunch;
    [tmpProfiles,tmpCyCodes,tmpCyProgs,tmpTimes]=ParseBeamProfiles(MonPaths(iDataAcq),monTypes(iDataAcq));
    if (lConcatenate)
        % concatenate all extractions, as if there was only a very long one
        [tmpProfiles,tmpTimes]=BeamProfilesConcatenateTimes(tmpProfiles,tmpTimes);
    else
        % align time frames, such that all extractions have the same time
        %   framework
        tmpTimes=BeamProfilesAlignTimes(tmpTimes);
    end
    
    %% post-processing
    % - cleaning: set to 0.0 channels to be ignored and get integrals
    ProfsToCrunch=tmpProfiles;
    if (exist("iNotCons","var"))
        for iPlane=1:2
            ProfsToCrunch(iNotCons(:,iPlane),2:end,iPlane,:)=0.0;
        end
    end
    % - Eks,mms
    tmpEksProf=ConvertCyCodes(tmpCyCodes,"Ek","MeVvsCyCo_P.xlsx");
    tmpMmsProf=ConvertCyCodes(tmpCyCodes,"mm","MeVvsCyCo_P.xlsx");
    % - integrals
    integratedProfiles=SumSpectra(ProfsToCrunch); 
    intensityEvolutions=SumSpectra(ProfsToCrunch,tmpTimes); 
    % - some cleaning:
    [BARsProf,FWHMsProf,INTsProf]=deal(missing(),missing(),missing());

    %% plotting
    nExtr=size(ProfsToCrunch,4);
    ffs=[ figure() figure() ];
    statLabels=strings(nExtr,1);
    for iExtr=1:nExtr
        pause();
        % - statistics
        noiseLevel=0.0;
        INTlevel=0;
        [tmpBARsProf,tmpFWHMsProf,tmpINTsProf]=StatDistributionsBDProcedure(ProfsToCrunch(:,:,:,iExtr),noiseLevel,INTlevel);
        BARsProf=ExpandMat(BARsProf,tmpBARsProf);
        FWHMsProf=ExpandMat(FWHMsProf,tmpFWHMsProf);
        INTsProf=ExpandMat(INTsProf,tmpINTsProf);
        % - actually plot
        for iPlane=1:2
            set(0, 'currentfigure', ffs(iPlane));  % for figures
            % - contours, i.e. BARs and SIGs
            if (lSuperImposeStats)
                myConts=zeros(size(tmpBARsProf,1),2,3);
                myConts(:,1,1)=tmpBARsProf(:,iPlane); myConts(:,2,1)=tmpTimes(:,1);  % BARs
                myConts(:,1,2)=tmpBARsProf(:,iPlane)+tmpFWHMsProf(:,iPlane)/FWHM2sig; myConts(:,2,2)=tmpTimes(:,1);  % BARs+1sig
                myConts(:,1,3)=tmpBARsProf(:,iPlane)-tmpFWHMsProf(:,iPlane)/FWHM2sig; myConts(:,2,3)=tmpTimes(:,1);  % BARs-1sig
            end
            Plot2DHistograms(ProfsToCrunch(:,2:end,iPlane,iExtr),integratedProfiles(:,1+iExtr,iPlane),intensityEvolutions(:,1+iExtr,iPlane),...
                integratedProfiles(:,1,iPlane)',intensityEvolutions(:,1,iPlane)',xLabs(iPlane),yLab,myConts,lHist,lSquared,lBinEdges);
            if (lConcatenate)
                sgtitle(sprintf("plane: %s - %s - %s \n cyProgs: [%s:%s] - cyCodes: [%s:%s]",...
                    planes(iPlane),myLabels(iDataAcq),myTit,tmpCyProgs(1),tmpCyProgs(end),tmpCyCodes(1),tmpCyCodes(end)));
                myFigSave=strcat(myFigPath,"/",myFigName,"_",figNameCase,"_",planes(iPlane),"plane_ALL",".fig"); 
            else
                sgtitle(sprintf("plane: %s - %s - %s \n cyProg: %s - cyCode: %s",planes(iPlane),myLabels(iDataAcq),myTit,tmpCyProgs(iExtr),tmpCyCodes(iExtr)));
                myFigSave=strcat(myFigPath,"/",myFigName,"_",figNameCase,"_",planes(iPlane),"plane_cyProg",tmpCyProgs(iExtr),"_cyCode",tmpCyCodes(iExtr),".fig"); 
            end
            if (exist("myFigPath","var"))
                fprintf("...saving to file %s ...\n",myFigSave);
                savefig(myFigSave);
            end
        end
        % for summary plot
        if (lConcatenate)
            statLabels(iExtr)=sprintf("cyProgs: [%s:%s] - cyCodes: [%s:%s]",...
                tmpCyProgs(1),tmpCyProgs(end),tmpCyCodes(1),tmpCyCodes(end));
        else
            statLabels(iExtr)=sprintf("cyProg: %s - cyCode: %s",tmpCyProgs(iExtr),tmpCyCodes(iExtr));
        end
    end
    % - evolution of statistics
    if (nExtr==1)
        mySumTitle=strcat(myTit," - ",myLabels(iDataAcq)," - ",statLabels);
        mySumLabs=missing();
    else
        mySumTitle=strcat(myTit," - ",myLabels(iDataAcq));
        mySumLabs=statLabels;
    end
    if (exist("myFigPath","var"))
        myFigSave=strcat(myFigPath,"/",myFigName,"_",figNameCase,"_stats_ALL.fig"); 
    else
        myFigSave=missing();
    end
    ShowBeamProfilesSummaryData(BARsProf,FWHMsProf,INTsProf,missing(),tmpTimes,yLab,mySumLabs,missing(),mySumTitle,myFigSave);
    
end


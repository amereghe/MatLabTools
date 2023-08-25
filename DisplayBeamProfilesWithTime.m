% {}~

%% description
% this is a script which parses beam profiles files with time and plots them
%     as 2D histograms (profiles vs time), giving also 1D histograms
%     showing:
%     - sum distributions;
%     - evolution with time of integral;
%
% NOTA BENE: given the large amount of data, the script can crunch (for the
%            time being) only a single series of extractions;
%
% TO-DO LIST:
% - concatenate as many paths as desired;
% - save figures;

%% default stuff
% -------------------------------------------------------------------------
% - include Matlab libraries
% pathToLibrary=".\";
% addpath(genpath(pathToLibrary));

%% USER's input data
% -------------------------------------------------------------------------
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2213\";
MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2219\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2222\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2225\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2227\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2229\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2231\";
% MonPaths="P:\Accelerating-System\Accelerator-data\scambio\Alessio\2023-08-21_testsOcchiConiglio\DumpProtSO1_LineT_Size10_22-08-2023_2233\";
monTypes="CAMdumps";
% skip fibers/channels?
iNotCons=false(127,2); 
iNotCons(1:2,1)=true;  % do not consider left-most fibers on hor plane (broken)

%% acquire profiles
[tmpDiffProfiles,tmpCyCodesProf,tmpCyProgsProf,tmpTimes]=ParseBeamProfiles(MonPaths,monTypes);

%% set to 0.0 channels to be ignored and get integrals
profsToCrunch=tmpDiffProfiles;
if (exist("iNotCons","var"))
    for iPlane=1:2
        profsToCrunch(iNotCons(:,iPlane),2:end,iPlane,:)=0.0;
    end
end
integratedProfiles=SumSpectra(profsToCrunch); 
intensityEvolutions=SumSpectra(profsToCrunch,tmpTimes); 

%% show stuff
nExtr=size(profsToCrunch,4);
myConts=missing(); lHist=true; lSquared=false; lBinEdges=false;
yLab="t [ms]";
planes=["HOR" "VER"];
xLabs=[ "x [mm]" "y [mm]" ];
ffs=[ figure() figure() ];
for iExtr=1:nExtr
    pause();
    for iPlane=1:2
        set(0, 'currentfigure', ffs(iPlane));  %# for figures
        Plot2DHistograms(profsToCrunch(:,2:end,iPlane,iExtr),integratedProfiles(:,1+iExtr,iPlane),intensityEvolutions(:,1+iExtr,iPlane),...
            integratedProfiles(:,1,iPlane)',intensityEvolutions(:,1,iPlane)',xLabs(iPlane),yLab,myConts,lHist,lSquared,lBinEdges);
        sgtitle(sprintf("plane: %s - cyProg: %s - cyCode: %s",planes(iPlane),tmpCyProgsProf(iExtr),tmpCyCodesProf(iExtr)));
    end
end

% {}~

%% description
% this is a script which displays basic beam properties which depend on beam energy;

%% include libraries
% - include Matlab libraries
pathToLibrary="./";
addpath(genpath(pathToLibrary));
pathToLibrary="../MachineRefs";
addpath(genpath(pathToLibrary));

%% settings

% -------------------------------------------------------------------------
% USER's input data
% what to load
machine="ISO1";
beamPart=["PROTON" "CARBON"];
% what to show
showX="range";
showXlabel="R [mm]";
showY=[ "beta" "gamma" "betagamma" "pc" "Brho" "Ek" ];
showYlabel=["\beta_{rel} []" "\gamma_{rel} []" "\beta_{rel}\gamma_{rel} []" "pc [MeV/c/u]" "B\rho [Tm]" "E_k [MeV/u]"];
nCoupled=3;
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% check of user input data
nSets=max([length(beamPart) length(machine)]);
beamPart=ConfigCheck(beamPart,nSets,"beamPart");
machine=ConfigCheck(machine,nSets,"machine");
mSets=max([length(showX) length(showXlabel) length(showY) length(showYlabel)]);
showX=ConfigCheck(showX,mSets,"showX");
showXlabel=ConfigCheck(showXlabel,mSets,"showXlabel");
showY=ConfigCheck(showY,mSets,"showY");
showYlabel=ConfigCheck(showYlabel,mSets,"showYlabel");

%% clear variables
xVals=missing();
yVals=missing();

%% parse DBs

% - get values
myLeg=strings(nSets,1);
for iSet=1:nSets
    clear EnData tmpDataX tmpDataY;
    myConfig=sprintf("%s,%s",machine(iSet),beamPart(iSet));
    FullFileName=ReturnDefFile("BRHO",myConfig); EnData=readtable(FullFileName);
    myLeg(iSet)=myConfig;
    % - store data
    [tmpDataX,tmpDataY]=ExtractData(EnData,showX,showY);
    xVals=ExpandMat(xVals,tmpDataX);
    yVals=ExpandMat(yVals,tmpDataY);
end
xVals=permute(xVals,[1 3 2]); % what to show is the outermost dimension
yVals=permute(yVals,[1 3 2]);

%% show stuff
ShowStuff(xVals,yVals,showXlabel,showYlabel,myLeg,nCoupled);

%% local functions
function ShowStuff(xVals,yVals,showXlabel,showYlabel,myLeg,nCoupled,myTitle)
    if (~exist("nCoupled","var")), nCoupled=1; end
    if (~exist("myTitle","var")), myTitle=missing(); end
    nShows=size(xVals,3);
    nSets=size(xVals,2);

    figure();
    cm=colormap(parula(nSets+1));
    % - set grid of plots
    nPlots=nShows;
    if (~ismissing(myLeg)), nPlots=nPlots+1; end
    [nRows,nCols]=GetNrowsNcols(nPlots,nCoupled);
    % - set markers
    if ( nSets==2 )
        markers=[ "o" "*" ];
    else
        markers=strings(nSets,1);
        markers(:)=".";
    end
    % - actually plot
    for iPlot=1:nShows
        subplot(nRows,nCols,iPlot);
        lFirst=true;
        for iSet=1:nSets
            if (lFirst), lFirst=false; else, hold on; end
            plot(xVals(:,iSet,iPlot),yVals(:,iSet,iPlot),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        xlabel(showXlabel(iPlot)); ylabel(showYlabel(iPlot)); grid on;
    end
    % - legend plot
    if (~ismissing(myLeg))
        subplot(nRows,nCols,nPlots);
        lFirst=true;
        for iSet=1:nSets
            if (lFirst), lFirst=false; else, hold on; end
            plot(NaN(),NaN(),"-","Marker",markers(iSet),"Color",cm(iSet,:));
        end
        legend(myLeg);
    end
    % - general stuff
    if (~ismissing(myTitle)), sgtitle(myTitle); end
end

function [DataX,DataY]=ExtractData(EnData,showX,showY)
    names=fieldnames(EnData);
    DataX=missing(); DataY=missing();
    for ii=1:length(showX)
        isField=strcmpi(showX(ii),names);
        if any(isField)
            DataX=ExpandMat(DataX,EnData.(names{isField}));
        else
            error("no field %s in table!",showX(ii));
        end
    end
    for ii=1:length(showY)
        isField=strcmpi(showY(ii),names);
        if any(isField)
            DataY=ExpandMat(DataY,EnData.(names{isField}));
        else
            error("no field %s in table!",showY(ii));
        end
    end
    
end

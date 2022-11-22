% {}~

%% description
% this is a script which displays LGEN currents;

%% include libraries
% - include Matlab libraries
pathToLibrary="./";
addpath(genpath(pathToLibrary));
pathToLibrary="../MachineRefs";
addpath(genpath(pathToLibrary));

%% settings

% -------------------------------------------------------------------------
% USER's input data
machine=["ISO1" "ISO2" "ISO3" "ISO4" "ISO1" "ISO2" "ISO3" "ISO4"]';
beamPart=["PROTON" "PROTON" "PROTON" "PROTON" "CARBON" "CARBON" "CARBON" "CARBON" ];
% machine="ISO2";
% beamPart=["PROTON" "CARBON" ];
config="TM"; % select configuration: TM, RFKO
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% check of user input data
nSets=max([length(beamPart) length(machine) length(config)]);
beamPart=MyCheck(beamPart,nSets,"beamPart");
machine=MyCheck(machine,nSets,"machine");
config=MyCheck(config,nSets,"config");

%% clear variables
[cyCodes,ranges,Eks,Brhos,currents,fields,kicks,psNames,FileNameCurrents,magNames]=...
    deal(missing(),missing(),missing(),missing(),missing(),missing(),missing(),missing(),missing(),missing());
clear PSmapping;
myLeg=strings(nSets,1);

%% parse DBs

% - get PS mapping
FullFileName=ReturnDefFile("PSmapping"); PSmapping=readtable(FullFileName);

% - get values
for iSet=1:nSets
    clear tmpCyCodes tmpRanges tmpEks tmpBrhos tmpCurrents tmpFields tmpKicks tmpPsNames tmpFileNameCurrents tmpMagNames ;
    myConfig=sprintf("%s,%s,%s",machine(iSet),beamPart(iSet),config(iSet));
    [tmpCyCodes,tmpRanges,tmpEks,tmpBrhos,tmpCurrents,tmpFields,tmpKicks,tmpPsNames,tmpFileNameCurrents]=AcquireLGENValues(myConfig);
    tmpPsNames=string(tmpPsNames);
    tmpCyCodes=upper(string(tmpCyCodes));
    tmpMagNames=MagNames2LGENnames(tmpPsNames,true,PSmapping);
    myLeg(iSet)=myConfig; % comment me, if single data set
    % - store data
    cyCodes=ExpandMat(cyCodes,tmpCyCodes);
    ranges=ExpandMat(ranges,tmpRanges);
    Eks=ExpandMat(Eks,tmpEks);
    Brhos=ExpandMat(Brhos,tmpBrhos);
    currents=ExpandMat(currents,tmpCurrents);
    fields=ExpandMat(fields,tmpFields);
    kicks=ExpandMat(kicks,tmpKicks);
    psNames=ExpandMat(psNames,tmpPsNames);
    FileNameCurrents=ExpandMat(FileNameCurrents,tmpFileNameCurrents);
    magNames=ExpandMat(magNames,tmpMagNames);
end

% - normalise currents to Brho
clear normCurrents; normCurrents=NaN(size(currents));
for iSet=1:nSets
    normCurrents(:,:,iSet)=currents(:,:,iSet)./Brhos(:,iSet);
end

%% visual checks
LGENvisualCheck(psNames,Eks   ,"Ek [MeV/u]",currents,"I [A]",magNames,"",myLeg);
LGENvisualCheck(psNames,Eks   ,"Ek [MeV/u]",normCurrents,"I/B\rho [A/Tm]",magNames,"",myLeg);
LGENvisualCheck(psNames,ranges,"range [mm]",currents,"I [A]",magNames,"",myLeg);
LGENvisualCheck(psNames,ranges,"range [mm]",normCurrents,"I/B\rho [A/Tm]",magNames,"",myLeg);
LGENvisualCheck(psNames,Brhos ,"B\rho [Tm]",currents,"I [A]",magNames,"",myLeg);
LGENvisualCheck(psNames,Brhos ,"B\rho [Tm]",normCurrents,"I/B\rho [A/Tm]",magNames,"",myLeg);

%% local functions
function OutVar=MyCheck(InVar,nSets,myName)
    OutVar=InVar;
    nIn=length(OutVar);
    if (nIn<nSets)
        if (nIn==1)
            OutVar=strings(nSets,1);
            OutVar(:)=InVar;
        else
            error("multiple values of %s!",myName);
        end
    end
end

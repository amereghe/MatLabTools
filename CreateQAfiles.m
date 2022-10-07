% {}~

%% description
% this is a script which creates current files for QA scans;
% TO-DO:
% * .xlsx file with user input data.
%   NB: the file could be composed of different spreadsheets, named:
%       "machine,beamPart,config", which only "machine" being mandatory and
%       the other two optional (defaulting to "PROTON" and "TM");

%% include libraries
% - include Matlab libraries
pathToLibrary=".\";
addpath(genpath(pathToLibrary));

%% settings

% -------------------------------------------------------------------------
% USER's input data
kPath="S:\Accelerating-System\Accelerator-data";
% kPath="K:";

beamPart="PROTON";
machine="ISO3";
config="TM"; % select configuration: TM, RFKO
% -------------------------------------------------------------------------

%% parse DBs

% - get PS mapping
clear PSmapping; PSmapping=readtable("PSmapping.xlsx");

% - get TM values
clear cyCodesTM rangesTM EksTM BrhosTM currentsTM fieldsTM kicksTM psNamesTM FileNameCurrentsTM ;
[cyCodesTM,rangesTM,EksTM,BrhosTM,currentsTM,fieldsTM,kicksTM,psNamesTM,FileNameCurrentsTM]=AcquireLGENValues(beamPart,machine,config);
psNamesTM=string(psNamesTM);
cyCodesTM=upper(string(cyCodesTM));

%% processing

% -------------------------------------------------------------------------
% USER's input data
wrMagnetNames=[ "HE-H07A-CEB" "HE-018A-QUE" "HE-H27A-CEB" ];
wrRange=[191   265    167]; % [mm]
wrScan=["scanTM" "scan" "scanTM"];
wrDImin=[40   0 20]; % [A]
wrDImax=[40 350 20]; % [A]
wrDIdel=[5   50 40];  % [A]
wrNtimes=[ 1 1 10 ];
wrIbef=[5  0 5 ];   % [A]
wrNIbef=[5  3 5];
wrIaft=[350 350 350 ]; % [A]
wrNIaft=[2  5 5 ];
wrImin=[ 0 0 0];
wrImax=[ 350 350 350];
oFileName="test.xlsx";

% -------------------------------------------------------------------------

% actually build array/matrix of values
scans=missing(); wrPSnames=strings(length(wrMagnetNames),1);
for ii=1:length(wrMagnetNames)
    % find LGEN name
    jj=find(strcmpi(string(PSmapping.Magnet_NAME),wrMagnetNames(ii)));
    if ( isempty(jj) ), error("Magnet name %s not found in LGEN mapping table!",wrMagnetNames(ii)); end
    wrPSnames(ii)=string(PSmapping.LGEN(jj));
    % array characteristics
    switch upper(wrScan(ii))
        case "SCAN"
            % scan on a range given by user
            Imin=wrDImin(ii);
            Imax=wrDImax(ii);
            Idel=wrDIdel(ii);
        case "SCANTM"
            % scan around TM value
            rTM=find(rangesTM==wrRange(ii));
            if ( isempty(rTM) ), error("Range %d mm not available in TM table!",wrRange(ii)); end
            pTM=find(strcmpi(psNamesTM,string(PSmapping.LGEN(jj))));
            if ( isempty(pTM) ), error("LGEN name %s not found in TM table!",PSmapping.LGEN(jj)); end
            Imin=currentsTM(rTM,pTM)-wrDImin(ii);
            Imax=currentsTM(rTM,pTM)+wrDImax(ii);
            Idel=wrDIdel(ii);
            warning("...TM value of %s (aka %s) at %d mm: %f A;",wrPSnames(ii),wrMagnetNames(ii),wrRange(ii),currentsTM(rTM,pTM));
    end
    tmpScan=(Imin:Idel:Imax)';
    tmpScan=CorrectRange(tmpScan,wrImin(ii),wrImax(ii));
    tmpScan=RepeatScan(tmpScan,wrNtimes(ii));
    tmpScan=DecorateScan(tmpScan,wrIbef(ii),wrIaft(ii),wrNIbef(ii),wrNIaft(ii));
    scans=ExpandMat(scans,tmpScan);
end

% fill in last cells, to avoid NaNs or missing values
scans=AlignDataSets(scans);

% write to file
WriteQAFile(oFileName,scans,wrPSnames);

% -------------------------------------------------------------------------

%% local functions

function scanOut=CorrectRange(scanIn,Imin,Imax)
    scanOut=scanIn;
    scanOut(scanOut<Imin)=Imin;
    scanOut(scanOut>Imax)=Imax;
end

function scanOut=RepeatScan(scanIn,nTimes)
    if (nTimes>1)
        nPoints=length(scanIn);
        scanOut=NaN(nPoints*nTimes,1);
        for jj=1:nTimes
            scanOut((jj-1)*nPoints+1:jj*nPoints)=scanIn;
        end
    else
        scanOut=scanIn;
    end
end

function scanOut=DecorateScan(scanIn,Imin,Imax,nImin,nImax)
    scanOut=zeros(nImin+length(scanIn)+2*nImax,1);
    scanOut(1:nImin)=Imin;
    scanOut(  nImin+1:nImin+length(scanIn))=scanIn;
    scanOut(          nImin+length(scanIn)+1:nImin+length(scanIn)+nImax)=Imax;
    scanOut(                                 nImin+length(scanIn)+nImin+1:end)=Imin;
end

function ScansOut=AlignDataSets(ScansIn)
    ScansOut=ScansIn;
    for ii=1:size(ScansOut,2)
        indices=isnan(ScansOut(:,ii));
        if (any(indices))
            iLast=find(~indices,1,"last");
            ScansOut(indices,ii)=ScansOut(iLast,ii);
        end
    end
end

function WriteQAFile(oFileName,Scans,PSnames)
    fprintf("saving data to file %s ...\n",oFileName);
    C=cell(size(Scans,2)+1,size(Scans,1)+2);
    % header
    C(1,2)=cellstr("Property"); C(1,3:end)=num2cell(1:size(Scans,1));
    % data
    for ii=1:length(PSnames)
        C(ii+1,1)=cellstr(PSnames(ii)); C(ii+1,2)=cellstr("CCV");
        C(ii+1,3:end)=num2cell(Scans(:,ii));
    end
    writecell(C,oFileName);
    fprintf("...done.\n");
end

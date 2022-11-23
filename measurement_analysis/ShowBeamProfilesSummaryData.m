function ShowBeamProfilesSummaryData(BARs,SIGs,INTs,ASYMs,xVals,xLab,labels,whatNames,myTitle)
% ShowBeamProfilesSummaryData      to create a figure showing Baricentres, SIGmas/FWHMs,
%                                   INTegrals and ASYMmetries of beam profiles;
% 
% in case of multiple data sets, they are compared.
% 
% the function creates a stand-alone figure with 2x3(4) plots (hor/ver x
% SIG/BAR/INT(/ASYM)), comparing the various quantities;
% 
% input:
% - BARs (float(nScanPoints,nPlanes,nSets)): baricentres of distributions [mm];
% - SIGs (float(nScanPoints,nPlanes,nSets)): sigmas of distributions [mm];
% - INTs (float(nScanPoints,nPlanes,nSets)): integrals of distributions [mm];
% - ASYMs (float(nScanPoints,nPlanes,nSets), can be missing): asymmetry [mm];
% - xVals (float(nScanPoints,nSets), optional): independent variable;
%   if not given, the measurement ID is reported;
% - xLab (string, optional): name and unit of the independent variable;
%   if not given, "ID []" is reported;
% - labels (strings(nSets)): a label for each scan;
% - whatNames (strings(nCols)): a label for each quantity;
% - myTitle (string): figure title;
% 

    if ( ~exist("xVals","var") ), xVals=missing(); end
    if ( ~exist("xLab","var") ), xLab=missing(); end
    if ( ~exist('labels','var') ), labels=missing(); end
    if ( ~exist('whatNames','var') ), whatNames=missing(); end
    if ( ~exist('myTitle','var') ), myTitle=missing(); end
    
    nCols=3; % SIGs, BARs, INTs
    if ( ~ismissing(ASYMs) ), nCols=4; end
    planes=["Hor" "Ver"];
    nRows=length(planes); % Hor, Ver
    nSets=size(INTs,3);
    nVals=size(INTs,1);

    if ( ismissing(xVals) )
        xVals=NaN(nVals,nSets);
        for iSet=1:nSets
            xVals(:,iSet)=1:nVals;
        end
    end
    if ( ismissing(xLab) ), xLab="ID []"; end
    if ( ismissing(labels) )
        labels=compose("Series %02i",(1:nSets)');
    end
    if ( ismissing(whatNames) )
        whatNames=["FWHM" "BAR" "INT" "ASYM"];
    end
    
    % actually generate figure
    if (~ismissing(myTitle))
        figure("Name",LabelMe(myTitle));
    else
        figure();
    end
    iPlot=0;
    if ( nSets==2 )
        markers=[ "o" "*" ];
    else
        markers=strings(nSets,1);
        markers(:)=".";
    end
    for iRow=1:nRows
        for iCol=1:nCols
            iPlot=iPlot+1;
            subplot(nRows,nCols,iPlot);
            switch iCol
                case 1
                    what=SIGs; myYLab="[mm]"; lLog=false;
                case 2
                    what=BARs; myYLab="[mm]"; lLog=false;
                case 3
                    what=INTs; myYLab="[]"; lLog=true;
                case 4
                    what=ASYMs; myYLab="[mm]"; lLog=false;
            end
            for iSet=1:nSets
                if ( iSet>1 ), hold on; end
                plot(xVals(:,iSet),what(:,iRow,iSet),"-","Marker",markers(iSet));
            end
            if (lLog), set(gca,'YScale','log'); end
            xlabel(xLab); ylabel(myYLab); grid on; title(sprintf("%s - %s",planes(iRow),whatNames(iCol)));
            legend(labels,"location","best");
        end
    end
    
    if (~ismissing(myTitle))
        sgtitle(LabelMe(myTitle));
    end
    
end

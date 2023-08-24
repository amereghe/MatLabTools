function ShowSpectra(dataSets,tmpTitleFig,addIndex,addLabel,myLabels,myFigSave,iMod)
% ShowSpectra     shows distributions recorded by SFM, QBM and GIM;
%                 it shows a 1x2 3D figure, with the distributions on the
%                   horizontal plane on the left and those on the vertical
%                   plane on the right;
%                 both raw data from monitors and total distributions can
%                   be plotted.
%                 NB: if you need to plot a subset... please give a proper
%                   subset of data as input!
%
% eg:
%      ShowSpectra(sumSFMData,"Run2-Carbonio",cyProgs,"cyProgs");
%
% input:
% - dataSets [float(Nfibers,nColumns,2)]: array of data. See also
%   ParseSFMData and SumSpectra for more info;
% - tmpTitleFig [string]: title of plot. It will be used for both the
%   window and the plot title;
% - addIndex [float(nColumns-1), optional]: list of IDs to be shown;
%   it can be used to separate distribution by cyProg or cyCode;
% - addLabel [string, optional]: name of the y-axis;
% - myLabels [strings(nSets), optional]: a label for each scan;
% - myFigSave (string, optional): file name where to save the plot;
% - iMod [integer, optional]: type of plot:
%   . 1: colored histograms in a 3D view;
%   . 2: sinogram-like view;
%   . 3: 3D sinogram-like;
%
% see also ParseSFMData, PlotSpectra and SumSpectra.

    fprintf("plotting data...\n");

    %% pre-processing
    if (~exist("addIndex","var") | all(ismissing(addIndex))), addIndex=missing(); end
    if (~exist("addLabel","var") | all(ismissing(addLabel))), addLabel=missing(); end
    if (~exist("myLabels","var") | all(ismissing(addLabel))), myLabels=missing(); end
    if (~exist("myFigSave","var")), myFigSave=missing(); end
    if (~exist('iMod','var') | ismissing(iMod)), iMod=1; end
    
    %% actually plotting
    ff=figure('Name',LabelMe(tmpTitleFig),'NumberTitle','off');
    BaW=false; % always use colored plots
    nDataSets=size(dataSets,4);
    planes=["horizontal plane" "vertical plane"];
    nPlanes=length(planes);
    [nRows,nCols,lDispHor]=GetNrowsNcols(nPlanes*nDataSets,nPlanes);
    
    if (lDispHor)
        % show planes side by side
        tiledlayout(nRows,nCols,'TileSpacing','Compact','Padding','Compact'); % minimise whitespace around plots
    else
        % show planes on consecutive rows
        iPlot=0;
    end
    for iDataSet=1:nDataSets
        for iPlane=1:nPlanes
            if (lDispHor)
                % show planes side by side
                nexttile;
            else
                % show planes on consecutive rows
                iPlot=iPlot+1;
                jPlot=(iPlane-1)*nCols+(nCols*nPlanes)*(ceil(iPlot/(nCols*nPlanes))-1)+mod(iDataSet-1,nCols)+1;
                subplot(nRows,nCols,jPlot);
            end
            if ( ismissing(addIndex) & ismissing(addLabel) )
                PlotSpectra(dataSets(:,:,iPlane,iDataSet),BaW,missing(),missing(),iMod);
            else
                PlotSpectra(dataSets(:,:,iPlane,iDataSet),BaW,addIndex(:,iDataSet),addLabel,iMod);
            end
            if (ismissing(myLabels))
                title(planes(iPlane));
            else
                title(sprintf("%s - %s",myLabels(iDataSet),planes(iPlane)));
            end
            switch iMod
                case 1
                    xlabel("position [mm]");
                    zlabel("Counts []");
                otherwise
                    ylabel("position [mm]");
                    zlabel("Counts []");
            end
        end
    end
    
    % global
    sgtitle(LabelMe(tmpTitleFig));
    if (~ismissing(myFigSave))
        fprintf("...saving to file %s ...\n",myFigSave);
        savefig(myFigSave);
    end
end



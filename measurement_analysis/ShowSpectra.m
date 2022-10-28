function ShowSpectra(dataSets,tmpTitleFig,addIndex,addLabel,myLabels)
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
%
% see also ParseSFMData, PlotSpectra and SumSpectra.

    fprintf("plotting data...\n");
    ff=figure('Name',LabelMe(tmpTitleFig),'NumberTitle','off');
    BaW=false; % always use colored plots
    nDataSets=size(dataSets,4);
    planes=["horizontal plane" "vertical plane"];
    nPlanes=length(planes);
    [nRows,nCols,lDispHor]=GetNrowsNcols(nPlanes*nDataSets,nPlanes);
    
    iPlot=0;
    for iDataSet=1:nDataSets
        for iPlane=1:nPlanes
            iPlot=iPlot+1;
            if (lDispHor)
                % show planes side by side
                jPlot=iPlot;
            else
                % show planes on consecutive rows
                jPlot=(iPlane-1)*nCols+(nCols*nPlanes)*(ceil(iPlot/(nCols*nPlanes))-1)+iDataSet;
            end
            subplot(nRows,nCols,jPlot);
            if ( ~exist('addIndex','var') & ~exist('addLabel','var') )
                PlotSpectra(dataSets(:,:,iPlane,iDataSet),BaW);
            else
                PlotSpectra(dataSets(:,:,iPlane,iDataSet),BaW,addIndex(:,iDataSet),addLabel);
            end
            if (exist('myLabels','var'))
                title(sprintf("%s - %s",myLabels(iDataSet),planes(iPlane)));
            else
                title(planes(iPlane));
            end
            xlabel("position [mm]");
            zlabel("Counts []");
        end
    end
    
    % global
    sgtitle(LabelMe(tmpTitleFig));
end



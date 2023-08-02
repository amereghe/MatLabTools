function ShowSpectraCompare(profiles,manipulate,xLab,yLab,myLeg,myProfLabels)
% profiles=float(nBinCentres,1+nProfiles,nSeries)

    %% interface vars
    if ( ~exist("manipulate","var") | all(ismissing(manipulate)) ), manipulate=missing(); end
    if ( ~exist("yLab","var") | ismissing(yLab) ), yLab=missing(); end
    if ( ~exist("xLab","var") | ismissing(xLab) ), xLab=missing(); end
    if ( ~exist("myLeg","var") | ismissing(myLeg) ), myLeg=missing(); end
    if ( ~exist("myProfLabels","var") | all(ismissing(myProfLabels)) ), myProfLabels=missing(); end
    if (~ismissing(manipulate))
        for iMan=1:length(manipulate)
            switch upper(manipulate(iMan))
                case {"CENTRE","CENTER"}
                    if ( ismissing(xLab) ), xLab="[mm]"; end
                case {"AREA","ONE"}
                    if ( ismissing(yLab) ), yLab="pdf (Area=1) []"; end
                case {"PEAK","MAX"}
                    if ( ismissing(yLab) ), yLab="pdf (norm to peaks) []"; end
                otherwise
                    error("unknown manipulation: %s!",manipulate(iMan));
            end
        end
    end
    if ( ismissing(yLab) ), yLab="counts []"; end
    if ( ismissing(xLab) ), xLab="[mm]"; end

    %% set up
    nProfiles=size(profiles,2)-1;
    nDataSets=size(profiles,3);
    if (nProfiles>6)
        [nRows,nCols]=GetNrowsNcols(nProfiles+1);
    else
        [nRows,nCols]=GetNrowsNcols(nProfiles);
    end
    ff=figure();
    ff.Position(1:2)=[0 0]; % figure at lower-left corner of screen
    ff.Position(3)=ff.Position(3)*nCols/2; % larger figure
    ff.Position(4)=ff.Position(4)*nRows/2; % larger figure
    cm=colormap(jet(nDataSets));
    tiledlayout(nRows,nCols,'TileSpacing','Compact','Padding','Compact'); % minimise whitespace around plots
    
    %% actually plot
    % - profiles
    for iProfile=1:nProfiles
        nexttile;
        myRange=NaN(nDataSets,2);
        for iDataSet=1:nDataSets
            if (iDataSet>1), hold on; end
            showX=profiles(:,1,iDataSet);
            showY=profiles(:,1+iProfile,iDataSet);
            if (~ismissing(manipulate))
                for iMan=1:length(manipulate)
                    switch upper(manipulate(iMan))
                        case {"CENTRE","CENTER"}
                            showX=showX-mean(showX);
                        case {"AREA","ONE"}
                            showY=showY/sum(showY);
                        case {"PEAK","MAX"}
                            showY=showY/max(showY);
                    end
                end
            end
            bar(showX,showY,1,"FaceColor","none","EdgeColor",cm(iDataSet,:),"LineWidth",1/iDataSet);
            myRange(iDataSet,1)=showX(find(showY>0,1,"first")); % min xVal with a non-zero yVal
            myRange(iDataSet,2)=showX(find(showY>0,1,"last"));  % max xVal with a non-zero yVal
        end
        xlabel(xLab); ylabel(yLab); grid on;
        if (any(~ismissing(myProfLabels)))
            title(myProfLabels(iProfile));
        else
            title(sprintf("profile %d",iProfile));
        end
        xlim([min(myRange(:,1)) max(myRange(:,2))]);
        if (nProfiles<=6), legend(myLeg,"Location","best"); end
    end
    % - legend plot
    if (nProfiles>6)
        nexttile;
        for iDataSet=1:nDataSets
            if (iDataSet>1), hold on; end
            plot(NaN(),NaN(),".-","Color",cm(iDataSet,:)); hold on;
        end
        legend(myLeg,"Location","best");
    end
end

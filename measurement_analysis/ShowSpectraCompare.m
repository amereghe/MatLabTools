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
    nDataSets=size(profiles,3)-1; % first profile taken as "reference"
    if (nDataSets>3)
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
            if (iDataSet==1)
                bar(showX,showY,1,"FaceColor","black","EdgeColor","black");
            else
                bar(showX,showY,1,"FaceColor","none","EdgeColor",cm(iDataSet-1,:),"LineWidth",1/iDataSet);
            end
            myMin=find(showY>0,1,"first"); % min xVal with a non-zero yVal
            if (isempty(myMin)), myRange(iDataSet,1)=min(showX); else, myRange(iDataSet,1)=showX(myMin); end
            myMax=find(showY>0,1,"last"); % max xVal with a non-zero yVal
            if (isempty(myMax)), myRange(iDataSet,2)=max(showX); else, myRange(iDataSet,2)=showX(myMax); end
        end
        xlabel(xLab); ylabel(yLab); grid on;
        if (any(~ismissing(myProfLabels)))
            title(myProfLabels(iProfile));
        else
            title(sprintf("profile %d",iProfile));
        end
        xlim([min(myRange(:,1)) max(myRange(:,2))]);
        if (nDataSets<=3 & ~ismissing(myLeg) & iProfile==1), legend(myLeg,"Location","best"); end
    end
    % - legend plot
    if (nDataSets>3 & ~ismissing(myLeg))
        nexttile;
        bar(NaN(),NaN(),1,"FaceColor","black");
        for iDataSet=1:nDataSets
            hold on; bar(NaN(),NaN(),1,"FaceColor","none","EdgeColor",cm(iDataSet,:));
        end
        legend(myLeg,"Location","best");
    end
end

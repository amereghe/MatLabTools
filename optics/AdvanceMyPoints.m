function TransfPoints=AdvanceMyPoints(OrigPoints,RM,lNorm,lDebug,alpha,beta,emiG)
    if (~exist("lNorm","var")), lNorm=true; end
    if (~exist("lDebug","var")), lDebug=true; end

    if ( lDebug | lNorm )
        if ( ~exist("emiG","var") )
            [alpha,beta,emiG,sigM]=GetOpticsFromSigmaMatrix(OrigPoints);   % ellypse orientation
            emiG=max(GetSinglePartEmittance(OrigPoints,alpha,beta));  % max 
        end
    end
    if ( lDebug )
        % - physical ellypse
        clear MyContours; MyContours=missing();
        MyContours=ExpandMat(MyContours,GenPointsAlongEllypse(alpha,beta,emiG));
        if ( lNorm )
            % - normalised ellypse (aka circumference)
            clear MyContoursNorm; MyContoursNorm=missing();
            MyContoursNorm=ExpandMat(MyContoursNorm,GenPointsAlongEllypse(0,1,1));
        end
    end
    
    if ( lDebug )
        % - show rotated physical coordinates
        ShowCoords(OrigPoints,["z [m]" "zp [rad]"],MyContours,"physical phase space (original coordinates)");
    end
    
    if ( lNorm )
        % rotate in normalised phase space
        % - get normalise coordinates
        [OrigPointsNorm]=Phys2Norm(OrigPoints,beta,alpha,emiG);
        sigMnorm=cov(OrigPointsNorm);
        % - rotate coordinates
        [OrigPointsNormTransported(:,1),OrigPointsNormTransported(:,2)]=TransportOrbit(RM,OrigPointsNorm(:,1),OrigPointsNorm(:,2));
        sigMnormRot=cov(OrigPointsNormTransported);
        % - phyisical coordinates
        [TransfPoints]=Norm2Phys(OrigPointsNormTransported,beta,alpha,emiG);
        if ( lDebug )
            % - show normalised coordinates
            ShowCoords(OrigPointsNorm,["z []" "zp []"],MyContoursNorm,"normalised phase space (original coordinates)");
            % - show rotated normalised coordinates
            ShowCoords(OrigPointsNormTransported,["z []" "zp []"],MyContoursNorm,"normalised phase space (modified coordinates)");
        end
    else
        [TransfPoints(:,1),TransfPoints(:,2)]=TransportOrbit(RM,OrigPoints(:,1),OrigPoints(:,2));
    end
    if ( lDebug )
        % - show rotated physical coordinates
        [alphaRot,betaRot,emiGrot,sigMrot]=GetOpticsFromSigmaMatrix(TransfPoints);   % ellypse orientation
        emiGrot=max(GetSinglePartEmittance(TransfPoints,alphaRot,betaRot));  % max 
        MyContours=ExpandMat(MyContours,GenPointsAlongEllypse(alphaRot,betaRot,emiGrot));
        ShowCoords(TransfPoints,["z [m]" "zp [rad]"],MyContours,"physical phase space (modified coordinates)");
    end
end

function ShowCoords(MyPoints,axLabels,MyContours,myTitle)
    ff=figure();
    ff.Position(3)=ff.Position(4);
    clear nCounts nCountsX nCountsY xb yb
    [nCounts,nCountsX,nCountsY,xb,yb]=Get2dHistograms(MyPoints(:,1),MyPoints(:,2));
    Plot2DHistograms(MyPoints,nCountsX,nCountsY,xb,yb,axLabels(1),axLabels(2),MyContours,false,true);
    sgtitle(myTitle);
end

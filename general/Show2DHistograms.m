function Show2DHistograms(showMe,showMe1DX,showMe1DY,xShow,yShow,xShowLabel,yShowLabel,actualTitle)
    figure('Name',actualTitle,'NumberTitle','off');
    
    Plot2DHistograms(showMe,showMe1DX,showMe1DY,xShow,yShow,xShowLabel,yShowLabel);
    
    sgtitle(actualTitle);
    
end

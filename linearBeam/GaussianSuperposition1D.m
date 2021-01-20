% {}~
% Script to superimpose 1D Distributions and see the final profile.
% For the moment, only Gaussian distributions. If desired, a random
%    error on amplitude, sigma and centre of peaks can be introduced.

sig2FWHM=2*sqrt(2*log(2));

% nominal values
FWHM=4;              % [mm]
sigma=FWHM/sig2FWHM; % [mm]
dMeans=FWHM/3;       % [mm]
nCurves=7;           % number of curves
nPointsXSigma=50;    % number of points per sigma
% perturbations
errA=0.;             % amplitude error wrt 1 [0:1]
errSig=0.;           % sigma error (relative to value of sigma) [0:1]
errMeans=0.;         % error on position (relative to value of dMeans) [0:1]
lSingleError=1;      % apply error only on central Gaussian
lAverage=0;          % compute wigglering of peak value based on max,min,average
lTolerance=1;        % mark extension of profile between max and max-tolerance
lPenumbra=1;         % mark region of penumbra
% parameters for identifying region withing 2.5% tolerance 
precTol=1.0E-3;
tol=2.5E-2;
% parameters for identifying region of penumbra
precPen=5.0E-2;
penMax=0.8;
penMin=0.2;

if ( lSingleError )
    if ( mod(nCurves,2)==0 )
        fprintf("...even number of curves when lSingleError is on: adding 1...\n");
        nCurves=nCurves+1;
    end
    iCentralCurve=ceil(nCurves/2);
end

% generate (Gaussian) curves
As=ones(nCurves,1);
means=0:dMeans:(nCurves-1)*dMeans;
means=means'-mean(means);
sigmas=sigma*ones(nCurves,1);
% apply errors:
% - rand: uniformly distributed random numbers
% - randn: Gaussian-distributed random numbers
if ( errA ~= 0 )
    if ( lSingleError )
        As(iCentralCurve)=As(iCentralCurve)+errA;
    else
        As=As+(2*rand(nCurves,1)-1)*errA;
    end
end
if ( errMeans ~= 0 )
    if ( lSingleError )
        means(iCentralCurve)=means(iCentralCurve)+errMeans*dMeans;
    else
        means=means+(2.*rand(nCurves,1)-1)*errMeans*dMeans;
    end
end
if ( errSig ~= 0 )
    if ( lSingleError )
        sigmas(iCentralCurve)=sigmas(iCentralCurve)+sigma*errSig;
    else
        sigmas=sigmas+sigma*((2*rand(nCurves,1)-1)*errSig);
    end
end

% generate mesh on x-axis
xMin=-4*sigma+min(means);
xMax=4*sigma+max(means);
Xs=xMin:sigma/nPointsXSigma:xMax;
fprintf("using %d points for the domain mesh...\n",length(Xs));

% compute curves
Ys=zeros(length(Xs),nCurves);
for ii=1:nCurves
    Ys(:,ii)=normalDist1D(Xs,As(ii),means(ii),sigmas(ii));
end
totalYs=sum(Ys,2);

% evaluate how flat is the overall distribution
if ( lAverage )
    % region between centres of distributions at borders
    % - define range of flat part
    indicesFlat=( min(means)<=Xs & Xs<=max(means) );
    totYsFlat=totalYs(indicesFlat);
    XsFlat=Xs(indicesFlat);
    % - average
    averageFlat=mean(totYsFlat);
    % - Max-Min
    [yMaxFlat,iMaxFlat]=max(totYsFlat);
    [yMinFlat,iMinFlat]=min(totYsFlat);
    maxMminFlat=yMaxFlat-yMinFlat;
    % - theoretical value:
    theoryValFlat=1/sqrt(2*pi)/sigma;
    fprintf("...average method:\n");
    fprintf("   * average of flat part (averageFlat): %g;\n",averageFlat);
    fprintf("   * max of nominal Gaussian (theoryValFlat): %g;\n",theoryValFlat);
    fprintf("   * maximum (yMaxFlat, XsFlat(iMaxFlat)): %g, %g mm \n",yMaxFlat, XsFlat(iMaxFlat));
    fprintf("   * minimum (yMinFlat, XsFlat(iMinFlat)): %g, %g mm \n",yMinFlat, XsFlat(iMinFlat));
    fprintf("   * extension (XsFlat(end)-XsFlat(1)): %g mm, %g FWHM, %g sigma \n",XsFlat(end)-XsFlat(1),(XsFlat(end)-XsFlat(1))/FWHM,(XsFlat(end)-XsFlat(1))/sigma);
end
if ( lTolerance )
    % 2.5% tolerance
    [yMax,iMax]=max(totalYs);
    yRef=yMax*(1-tol);
    indicesRef=equal(yRef,totalYs,precTol);
    XsRef=Xs(indicesRef);
    YsRef=totalYs(indicesRef);
    [xRefLeft,iRefLeft]=min(XsRef);
    [xRefRight,iRefRight]=max(XsRef);
    fprintf("...tolerance analysis:\n");
    fprintf("   * tolerance level (tol): %g %%;\n",tol*100);
    fprintf("   * maximum (yMax, Xs(iMax)): %g, %g mm \n",yMax, Xs(iMax));
    fprintf("   * left extreme (YsRef(iRefLeft), xRefLeft): %g, %g mm \n",YsRef(iRefLeft), xRefLeft);
    fprintf("   * right extreme (YsRef(iRefRight), xRefRight): %g, %g mm \n",YsRef(iRefRight), xRefRight);
    fprintf("   * extension (xRefRight-xRefLeft): %g mm, %g FWHM, %g sigma \n",xRefRight-xRefLeft,(xRefRight-xRefLeft)/FWHM,(xRefRight-xRefLeft)/sigma);
end
if ( lPenumbra )
    % 20-80% penumbra
    [yMax,iMax]=max(totalYs);
    vPenMax=yMax*penMax;
    indicesPenMax=equal(vPenMax,totalYs,precPen);
    XsPenMax=Xs(indicesPenMax);
    YsPenMax=totalYs(indicesPenMax);
    [xPenMaxLeft,iPenMaxLeft]=min(XsPenMax);
    [xPenMaxRight,iPenMaxRight]=max(XsPenMax);
    vPenMin=yMax*penMin;
    indicesPenMin=equal(vPenMin,totalYs,precPen);
    XsPenMin=Xs(indicesPenMin);
    YsPenMin=totalYs(indicesPenMin);
    [xPenMinLeft,iPenMinLeft]=min(XsPenMin);
    [xPenMinRight,iPenMinRight]=max(XsPenMin);
    fprintf("...penumbra analysis:\n");
    fprintf("   * min and max levels (penMin and penMax): %g and %g %%;\n",penMin*100,penMax*100);
    fprintf("   * maximum (yMax, Xs(iMax)): %g, %g mm \n",yMax, Xs(iMax));
    fprintf("   * left penumbra:\n");
    fprintf("     * left extreme (YsPenMin(iPenMinLeft), xPenMinLeft): %g, %g mm \n",YsPenMin(iPenMinLeft), xPenMinLeft);
    fprintf("     * right extreme (YsPenMax(iPenMaxLeft), xPenMaxLeft): %g, %g mm \n",YsPenMax(iPenMaxLeft), xPenMaxLeft);
    fprintf("     * extension (xPenMaxLeft-xPenMinLeft): %g mm, %g FWHM, %g sigma \n",xPenMaxLeft-xPenMinLeft,(xPenMaxLeft-xPenMinLeft)/FWHM,(xPenMaxLeft-xPenMinLeft)/sigma);
    fprintf("   * right penumbra:\n");
    fprintf("     * left extreme (YsPenMax(iPenMaxRight), xPenMaxRight): %g, %g mm \n",YsPenMax(iPenMaxRight), xPenMaxRight);
    fprintf("     * right extreme (YsPenMin(iPenMinRight), xPenMinRight): %g, %g mm \n",YsPenMin(iPenMinRight), xPenMinRight);
    fprintf("     * extension (xPenMinRight-xPenMaxRight): %g mm, %g FWHM, %g sigma \n",xPenMinRight-xPenMaxRight,(xPenMinRight-xPenMaxRight)/FWHM,(xPenMinRight-xPenMaxRight)/sigma);
end

% do the plot
ff=figure();
plot(Xs,totalYs,'k*-');
for ii=1:nCurves
    hold on;
    plot(Xs,Ys(:,ii),'b-');
end
if ( lAverage )
    hold on;
    plot([min(Xs(indicesFlat)) max(Xs(indicesFlat))],[averageFlat averageFlat],'r-');
    text(max(Xs(indicesFlat)),averageFlat,sprintf("average: %g",averageFlat),'Color','red');
end
if ( lTolerance )
    thickNess=0.025;
    % - flat part
    hold on;
    plot([xRefLeft xRefLeft],[yMax*(1-thickNess) yMax*(1+thickNess)],'g-', ...
         [xRefRight xRefRight],[yMax*(1-thickNess) yMax*(1+thickNess)],'g-', ...
         [xRefLeft xRefRight],[yMax yMax],'g-');
    text(0.5*(xRefRight+xRefLeft),yMax*(1-thickNess),...
        sprintf("tolerance at %g %%",tol*100),'Color','green');
end
if ( lPenumbra )
    hold on;
    plot([xPenMinLeft xPenMinLeft],[vPenMin*(1-thickNess) vPenMax*(1+thickNess)],'m-', ...
         [xPenMaxLeft xPenMaxLeft],[vPenMin*(1-thickNess) vPenMax*(1+thickNess)],'m-', ...
         [xPenMinLeft xPenMaxLeft],[vPenMax vPenMax],'m-');
    text(0.5*(xPenMinLeft+xPenMaxLeft),vPenMax*(1+thickNess),...
        sprintf("%g-%g %%", penMax*100,penMin*100),'Color','magenta');
    hold on;
    plot([xPenMinRight xPenMinRight],[vPenMin*(1-thickNess) vPenMax*(1+thickNess)],'m-', ...
         [xPenMaxRight xPenMaxRight],[vPenMin*(1-thickNess) vPenMax*(1+thickNess)],'m-', ...
         [xPenMinRight xPenMaxRight],[vPenMax vPenMax],'m-');
    text(0.5*(xPenMinRight+xPenMaxRight),vPenMax*(1+thickNess),...
        sprintf("%g-%g %%", penMax*100,penMin*100),'Color','magenta');
end
grid on;
xlabel("x [mm]");
titleGeo=sprintf("FWHM=%g mm; \\sigma=%g mm; \\Delta\\mu=%g mm",FWHM,sigma,dMeans);
if ( errA~=0.0 | errSig~=0.0 | errMeans~=0.0 )
    titleErr=sprintf("errA=%g [0:1]; errSig=%g [0:1]; errMeans=%g [0:1]",errA,errSig,errMeans);
    title(sprintf("%s\n%s",titleGeo,titleErr));
else
    title(sprintf("%s",titleGeo));
end

function Ys=normalDist1D(Xs,A,mean,sigma)
% input parameters
% - Xs: array of x values [mm];
% - A: amplitude of Gaussian distribution [];
% - mean,sigma: mean and sigma of Gaussian distribution [mm];
    Ys=A*exp(-0.5*((Xs-mean)/sigma).^2)/(sqrt(2*pi)*sigma);
end

function isEqual=equal(x,y,prec)
% get equality within a given precision
    isEqual=0;
    if ( x ~= 0 )
        isEqual=abs(y./x-1)<prec;
    else
        isEqual=abs(y-x)<prec;
    end
end

% {}~
% Script to superimpose 2D Distributions and see the final profile.
% For the moment, only Gaussian distributions. If desired, a random
%    error on amplitude, sigma and centre of peaks can be introduced.
% Being 2D, every geometrical parameter is an array of two places, the
%    first one refers to the horizontal plane, whereas the second one to
%    the vertical plane.

sig2FWHM=2*sqrt(2*log(2)); % []

% nominal values
sigma=[ 1.0 1.0 ];         % [mm]
FWHM=sigma*sig2FWHM;       % [mm]
dMeans=3*sigma;            % [mm]
nCurves=[ 3 2 ];           % number of curves
nPointsXSigma=[ 10 10 ];   % number of points per sigma
% perturbations
errA=0.;                   % amplitude error wrt 1 [0:1]
errSig=[0. 0. ];           % sigma error (relative to value of sigma) [0:1] 
errMeans=[0. 0.];          % error on position (relative to value of dMeans) [0:1]
% plotting
lSingle=0; % show also plots of single Gaussian distributions
% show 1D profile at (not operational yet):
xSlc=[2]; % constant x [mm]
ySlc=[3]; % constant y [mm]
% along a line: y=mx+q
mSlc=[1]; % []
qSlc=[0]; % []

% generate (Gaussian) curves
% - rand: uniformly distributed random numbers
% - randn: Gaussian-distributed random numbers
As=ones(nCurves(1),nCurves(2));
means=zeros(nCurves(1),nCurves(2),2);
sigmas=ones(nCurves(1),nCurves(2),2);
for jj=1:nCurves(2)
    means(1:end,jj,1)=0:dMeans(1):(nCurves(1)-1)*dMeans(1);
end
for ii=1:nCurves(1)
    means(ii,1:end,2)=0:dMeans(2):(nCurves(2)-1)*dMeans(2);
end
for kk=1:2
    sigmas(:,:,kk)=sigmas(:,:,kk).*sigma(kk);
    means(:,:,kk)=means(:,:,kk)-mean(means(:,:,kk),'all');
end
% apply errors
if ( errA ~= 0.0 )
    As=As+(2*rand(nCurves(1),nCurves(2))-1)*errA;
end
for kk=1:2
    if ( errMeans(kk) ~= 0.0 )
        means(:,:,kk)=means(:,:,kk)+(2.*rand(nCurves(1),nCurves(2))-1)*errMeans(kk)*dMeans(kk);
    end
    if ( errSig(kk) ~= 0.0 )
        sigmas(:,:,kk)=sigmas(:,:,kk)+(2*rand(nCurves(1),nCurves(2))-1)*errSig(kk);
    end
end

% generate meshes
xMeanMin=min(means(:,:,1),[],'all');
xMeanMax=max(means(:,:,1),[],'all');
yMeanMin=min(means(:,:,2),[],'all');
yMeanMax=max(means(:,:,2),[],'all');
Xs=-4*sigma(1)+xMeanMin:sigma(1)/nPointsXSigma(1):4*sigma(1)+xMeanMax;
Ys=-4*sigma(2)+yMeanMin:sigma(2)/nPointsXSigma(2):4*sigma(2)+yMeanMax;
fprintf("using %d points for the domain mesh on X axis...\n",length(Xs));
fprintf("using %d points for the domain mesh on Y axis...\n",length(Ys));
[X,Y] = meshgrid(Xs,Ys);

% compute curves
Zs=zeros(length(Xs),length(Ys),nCurves(1),nCurves(2));
for ii=1:nCurves(1)
    for jj=1:nCurves(2)
        Zs(:,:,ii,jj)=normalDist2D(Xs,Ys,As(ii,jj),means(ii,jj,:),sigmas(ii,jj,:));
    end
end
totalZs=sum(Zs,[3,4]);

% evaluate dispersion of points in the "flat part"
% - define range of flat part
indices=( xMeanMin<=X & X<=xMeanMax & yMeanMin<=Y & Y<=yMeanMax);
% - average
average=mean(totalZs(indices),'all');
% - Max-Min
zMax=max(totalZs(indices),[],'all');
zMin=min(totalZs(indices),[],'all');
% - theoretical value:
theoryVal=1/(2*pi*sigma(1)*sigma(2));
fprintf("...average: %g - theoryVal: %g - max: %g - min: %g \n",average,theoryVal,zMax,zMin);

% do the plots
if ( lSingle )
    ff=figure();
    kk=0;
    for ii=1:nCurves(1)
        for jj=1:nCurves(2)
            kk=kk+1;
            subplot(nCurves(1),nCurves(2),kk);
            surf(X',Y',Zs(:,:,ii,jj),'LineStyle','none');
            xlabel("x [mm]");
            ylabel("y [mm]");
        end
    end
end
% envelop
ff=figure();
surf(X',Y',totalZs,'LineStyle','none');
xlabel("x [mm]");
ylabel("y [mm]");

function Zs=normalDist2D(Xs,Ys,A,means,sigmas)
% input parameters
% - Xs,Ys: array of x and y values [mm];
% - A: amplitude of Gaussian distribution [];
% - mean: mean of Gaussian distribution [mm];
% - mean,sigma: array (2 values each) of mean and sigma of Gaussian distribution [mm];
    Zs=A*exp(-0.5*((Xs-means(1))/sigmas(1)).^2)'*exp(-0.5*((Ys-means(2))/sigmas(2)).^2)/(2*pi*sigmas(1)*sigmas(2));
end


% {}~
sigma=1.0; % [mm]
sig2FWHM=2*sqrt(2*log(2));
dMeans=sig2FWHM*sigma;  % [sig]
nCurves=10;
nPointsXSigma=50;
errA=0.; % [0:1]
errSig=0.; % [0:1]
errMeans=0.; % [0:1]

% generate Gaussian curves
% - rand: uniformly distributed random numbers
% - randn: Gaussian-distributed random numbers
As=ones(nCurves,1)+(2*rand(nCurves,1)-1)*errA;
means=0:dMeans:(nCurves-1)*dMeans;
means=means'-mean(means)+(2.*rand(nCurves,1)-1)*errMeans*dMeans;
sigmas=sigma*(ones(nCurves,1)+(2*rand(nCurves,1)-1)*errSig);

% generate mesh on x-axis
xMin=-5*sigma+min(means);
xMax=5*sigma+max(means);
Xs=xMin:sigma/nPointsXSigma:xMax;
fprintf("using %d points for the domain mesh...\n",length(Xs));

% compute curves
Ys=zeros(length(Xs),nCurves);
for ii=1:nCurves
    Ys(:,ii)=normalDist(Xs,As(ii),means(ii),sigmas(ii));
end

% do the plot
ff=figure();
plot(Xs,sum(Ys,2),'k*-');
for ii=1:nCurves
    hold on;
    plot(Xs,Ys(:,ii),'r-');
end
grid on;
xlabel("x [mm]");

function Ys=normalDist(Xs,A,mean,sigma)
    Ys=A*exp(-0.5*((Xs-mean)/sigma).^2)/(sqrt(2*pi)*sigma);
end
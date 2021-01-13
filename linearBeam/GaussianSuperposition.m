% {}~
sigma=1.0; % [mm]
sig2FWHM=2*sqrt(2*log(2));
dMeans=sig2FWHM*sigma;  % [sig]
nCurves=10;
nPointsXSigma=50;
errA=0.; % [0:1]
errSig=0.; % [0:1]
errMeans=0.; % [0:1]

SuperImpose1D(nCurves,dMeans,sigma,nPointsXSigma,errA,errSig,errMeans);

function SuperImpose1D(nCurves,dMeans,sigma,nPointsXSigma,errA,errSig,errMeans)
% SuperImpose1D    to superimpose 1D Distributions and see the final
% profile. For the moment, only Gaussian distributions. If desired, a
% random error on amplitude, sigma and centre of peaks can be introduced.
%
% input parameters:
% - nCurves: number of cruves;
% - dMeans: nominal separation among peaks [mm];
% - sigma: nominal sigma of the beam distribution [mm];
% - nPointsXSigma: number of points for each sigma;
% - errA: half-range of amplitude error [];
% - errSig: half-range of sigma error [];
% - errMeans: half-range of error on positions [];

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
        Ys(:,ii)=normalDist1D(Xs,As(ii),means(ii),sigmas(ii));
    end
    totalYs=sum(Ys,2);

    % evaluate dispersion of points in the "flat part"
    % - define range of flat part
    indices=( min(means)<=Xs & Xs<=max(means) );
    % - average
    average=mean(totalYs(indices));
    % - Max-Min
    maxMmin=max(totalYs(indices))-min(totalYs(indices));

    % do the plot
    ff=figure();
    plot(Xs,totalYs,'k*-');
    for ii=1:nCurves
        hold on;
        plot(Xs,Ys(:,ii),'b-');
    end
    hold on;
    plot([min(Xs(indices)) max(Xs(indices))],[average average],'r-');
    text(max(Xs(indices)),average,sprintf("Max-Min: %g %%",maxMmin/average*100),'Color','red');
    grid on;
    xlabel("x [mm]");
    % title(sprintf("Max-Min: %g %%",maxMmin/average*100));
end

function Ys=normalDist1D(Xs,A,mean,sigma)
% input parameters
% - Xs: array of x values [mm];
% - A: amplitude of Gaussian distribution [];
% - mean: mean of Gaussian distribution [mm];
% - sigma: sigma of Gaussian distribution [mm];
    Ys=A*exp(-0.5*((Xs-mean)/sigma).^2)/(sqrt(2*pi)*sigma);
end

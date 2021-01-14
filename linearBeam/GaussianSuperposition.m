% {}~
sig2FWHM=2*sqrt(2*log(2)); % []

FWHM=4; % [mm]
sigma=FWHM/sig2FWHM;
dMeans=FWHM/3; % [mm]
nCurves=20;
nPointsXSigma=50;
errA=0.; % [0:1]
errSig=0.; % [0:1]
errMeans=0.; % [0:1]
SuperImpose1D(nCurves,dMeans,sigma,nPointsXSigma,errA,errSig,errMeans);

% sigma=[ 1.0 1.0 ]; % [mm]
% dMeans=3*sigma; % [mm]
% nCurves=[ 3 2 ];
% nPointsXSigma=[ 10 10 ];
% errA=0.; % [0:1]
% errSig=[0. 0. ]; % [0:1]
% errMeans=[0. 0.]; % [0:1]
% SuperImpose2D(nCurves,dMeans,sigma,nPointsXSigma,errA,errSig,errMeans);

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

    % generate (Gaussian) curves
    % - rand: uniformly distributed random numbers
    % - randn: Gaussian-distributed random numbers
    As=ones(nCurves,1)+(2*rand(nCurves,1)-1)*errA;
    means=0:dMeans:(nCurves-1)*dMeans;
    means=means'-mean(means)+(2.*rand(nCurves,1)-1)*errMeans*dMeans;
    sigmas=sigma*(ones(nCurves,1)+(2*rand(nCurves,1)-1)*errSig);

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

    % evaluate dispersion of points in the "flat part"
    % - define range of flat part
    indices=( min(means)<=Xs & Xs<=max(means) );
    % - average
    average=mean(totalYs(indices));
    % - Max-Min
    yMax=max(totalYs(indices));
    yMin=min(totalYs(indices));
    maxMmin=yMax-yMin;
    % - theoretical value:
    theoryVal=1/sqrt(2*pi)/sigma;
    fprintf("...average: %g - theoryVal: %g - max: %g - min: %g \n",average,theoryVal,yMax,yMin);

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

function SuperImpose2D(nCurves,dMeans,sigma,nPointsXSigma,errA,errSig,errMeans)
% SuperImpose1D    to superimpose 1D Distributions and see the final
% profile. For the moment, only Gaussian distributions. If desired, a
% random error on amplitude, sigma and centre of peaks can be introduced.
%
% input parameters:
% - nCurves: number of cruves (array 2 places);
% - dMeans: nominal separation among peaks (array 2 places) [mm];
% - sigma: nominal sigma of the beam distribution (array 2 places) [mm];
% - nPointsXSigma: number of points for each sigma (array 2 places);
% - errA: half-range of amplitude error [];
% - errSig: half-range of sigma error (array 2 places) [];
% - errMeans: half-range of error on positions (array 2 places) [];

    lSingle=0; % show also plots of single Gaussian distributions
    xSlc=[2]; % [mm]
    ySlc=[3]; % [mm]
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
    % slices
    % - slices at selected X values
    ff=figure();
end

function Ys=normalDist1D(Xs,A,mean,sigma)
% input parameters
% - Xs: array of x values [mm];
% - A: amplitude of Gaussian distribution [];
% - mean,sigma: mean and sigma of Gaussian distribution [mm];
    Ys=A*exp(-0.5*((Xs-mean)/sigma).^2)/(sqrt(2*pi)*sigma);
end

function Zs=normalDist2D(Xs,Ys,A,means,sigmas)
% input parameters
% - Xs,Ys: array of x and y values [mm];
% - A: amplitude of Gaussian distribution [];
% - mean: mean of Gaussian distribution [mm];
% - mean,sigma: array (2 values each) of mean and sigma of Gaussian distribution [mm];
    Zs=A*exp(-0.5*((Xs-means(1))/sigmas(1)).^2)'*exp(-0.5*((Ys-means(2))/sigmas(2)).^2)/(2*pi*sigmas(1)*sigmas(2));
end

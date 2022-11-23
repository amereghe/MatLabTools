% {}~
% 
% an educational (work-in-progress) script to visualize the Kobayashi
%    Hamiltonian and play around with it
% the script is stand-alone, i.e. it does not use any function from MatLabTools
% 
% TO-DO:
% - find zeros;
% - find appropriate XP limits;
% - report area in title of figure;
% - report alpha and beta in title of subplot;

%% user vars
dQ=1E-4;
Brho=6.64; % [Tm]
d2Bodx2=0.0; % [T/m2]
Lmag=0.3; % [m]
betax=8; % [m]
alphax=-2; % []

%% crunch user vars
kp=d2Bodx2/Brho;
EPS=6*pi*dQ;
SS=5E-3;%0.5*sqrt(betax)^3*Lmag*kp;

%% scan
Xscan=(-1:0.001:1)';
HH=0:1E-5:1E-4;
nCurves=length(HH);

%% get normalised phase space
[XX,XP]=Kobayashi_XP(Xscan,SS,EPS,HH);
[XX_SEP,XP_SEP]=Kobayashi_separatrices(Xscan,EPS,SS);

%% get physical phase space
MM=NormMatrix(betax,alphax);
XXr=zeros(size(XX)); XPr=zeros(size(XP));
XXr_SEP=zeros(size(XX_SEP)); XPr_SEP=zeros(size(XP_SEP));
for iH=1:nCurves
    XXr(:,iH)=[XX(:,iH) XP(:,iH)]*MM(1,:)';
    XPr(:,iH)=[XX(:,iH) XP(:,iH)]*MM(2,:)';
end
for iSep=1:size(XX_SEP,2)
    XXr_SEP(:,iSep)=[XX_SEP(:,iSep) XP_SEP(:,iSep)]*MM(1,:)';
    XPr_SEP(:,iSep)=[XX_SEP(:,iSep) XP_SEP(:,iSep)]*MM(2,:)';
end

%% plot
figure();
cm=colormap(parula(nCurves));
legends=compose("H=%.2E",HH);
% - normalised phase space
subplot(1,2,1);
for iH=1:nCurves
    if ( iH>1 ), hold on; end
    plot(XX(:,iH),XP(:,iH),".-","Color",cm(iH,:));
end
plot(XX_SEP,XP_SEP,"r-");
xlabel("x [(m rad)^{1/2}]"); ylabel("xp [(m rad)^{1/2}]"); grid();
% [minX,iMin]=min(XX,[],"all","linear"); [maxX,iMax]=max(XX,[],"all","linear");
% xlim([minX maxX]); ylim(sort([XP(iMin) XP(iMax)]));
legend(legends,"Location","best"); title("Normalised phase space");
% - real phase space
subplot(1,2,2);
for iH=1:nCurves
    if ( iH>1 ), hold on; end
    plot(XXr(:,iH),XPr(:,iH),".-","Color",cm(iH,:));
end
plot(XXr_SEP,XPr_SEP,"r-");
xlabel("x [m]"); ylabel("xp [rad]"); grid();
% [minX,iMin]=min(XXr,[],"all","linear"); [maxX,iMax]=max(XXr,[],"all","linear");
% xlim([minX maxX]); ylim([XPr(iMin) XPr(iMax)]);
legend(legends,"Location","best"); title("Physical phase space");
% global
sgtitle(sprintf("S=%.2E; \\epsilon=%.2E; H_{sep}=%.2E",SS,EPS,(2*EPS/3)^3/SS^2));

%% functions
function [XX,XP]=Kobayashi_XP(XIN,SS,EPS,HH)
    sizeGrid=length(XIN);
    sizeScanH=length(HH);
    XP=NaN(2*sizeGrid+1,sizeScanH);
    XX=NaN(2*sizeGrid+1,sizeScanH);
    for ii=1:sizeScanH
        XX(1:sizeGrid,ii)=XIN;
        XX(sizeGrid+1)=0.0;
        XX(sizeGrid+2:end,ii)=XIN;
        XP(1:sizeGrid,ii)=real(sqrt((HH(ii)-XIN.^2.*(EPS/2-SS/4*XIN))./(EPS/2+3*SS/4*XIN)));
        XP(sizeGrid+1)=NaN();
        XP(sizeGrid+2:end,ii)=-XP(1:sizeGrid,ii);
    end
    XP(XP==0.0)=NaN();
end

function [XX,XP]=Kobayashi_separatrices(XIN,EPS,SS)
    nSeps=3;
    XX=zeros(2,nSeps); XP=zeros(2,nSeps);
    % X
    for iSep=2:nSeps
        XX(:,iSep)=[min(XIN) max(XIN)];
    end
    XX(:,1)=-EPS/SS*2/3;
    % XP
    XP(:,2)=(EPS/SS*4/3-XX(:,2))/sqrt(3);
    XP(:,3)=-XP(:,2);
    XP(:,1)=[min(XIN) max(XIN)];
end

function MM=NormMatrix(beta,alpha,lInv)
    if (~exist("lInv","var")), lInv=false; end
    MM=zeros(2);
    MM(1,1)=1/sqrt(beta);
    MM(2,1)=alpha/sqrt(beta);
    MM(2,2)=sqrt(beta);
    if (lInv)
        MM=inv(MM);
    end
end

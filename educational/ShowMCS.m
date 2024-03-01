% {}~

%% description
% this is a script which shows the Bethe-Bloch for the accelerated particles
% Refs:
% - main formula: PDG, 2018, Chap. 33, pag. 451 (eq. 33.15)
% - material parameters:
%   . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html

% %% include libraries
% % - include Matlab libraries
% pathToLibrary="..\";
% addpath(genpath(pathToLibrary));

%% settings

% - particle
myPart="CARBON"; % available: "PROTON", "CARBON", "HELIUM"

% NOTA BENE: please choose either an array of values of Ek and a single value
%            for the range traversed or the other way around;
% - kinetic energies
% Ek=1:1:250; % [MeV] % proton energies
Ek=100:1:400; % [MeV/A] % carbon energies
% Ek=115.23; % single energy
% - range traversed
mmEquiv=0.75; % [mm]
% mmEquiv=0.1:0.1:10.1; % [mm]

% - material
myMaterial="WATER";

%% Load particle data
% returns: myM [MeV/c2], myEk [MeV], myZ [], unitEk ("MeV" for protons, "MeV/u" for others);
[myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);

%% Load material data
% returns: ZoA [], I [eV], rho [g/cm3], densEff_plasmaFreq [eV], densEff_C [], 
%      densEff_x0 [], densEff_x1 [], densEff_a [], densEff_m [], densEff_d0 [], X0l [cm]
[ZoA,I,rho,densEff_plasmaFreq,densEff_C,densEff_x0,densEff_x1,densEff_a,densEff_m,densEff_d0,X0l]=...
    setMaterial(myMaterial);

%% compute MCS scattering tables
% - relativistic quantities
[myBeta,myGamma,myBetaGamma]=ComputeRelativisticQuantities(myEk,myM);    % [], [], []
% - MCS theta0 (Moliere's theory)
% theta0=ComputeTheta0(myBeta,myBetaGamma*myM,myZ,mmEquiv,X0l);
theta0=ComputeMCSthetaRMS(myBeta,myBetaGamma*myM,myZ,mmEquiv,X0l);
% - show theta0
if (length(mmEquiv)==1 && length(Ek)>1)
    % as a function of energy
    ShowMe(theta0*1000,Ek,"\theta [mrad]",sprintf("E_k [%s]",unitEk),sprintf("MCS for %s after traversing %g mm of %s equivalent",myPart,mmEquiv,myMaterial)); set(gca, 'YScale', 'log');
else
    % as a function of material thickness
    ShowMe(theta0*1000,mmEquiv,"\theta [mrad]","thickness [mm]",sprintf("MCS for %s of %g %s",myPart,myEk,unitEk)); set(gca, 'YScale', 'log');
end

%% save data
% save("MCS_CARBON_0.75mmH2O_AnalModel.mat","theta0","Ek");

%% show effect of scattering
L=0.15; % distance in vacuum travelled by scattered beam [m]
if (length(mmEquiv)==1 && length(Ek)>1)
    % as a function of energy
    ShowMe(theta0*L*1000,Ek,"\theta\timesL [mm]",sprintf("E_k [%s]",unitEk),sprintf("MCS for %s after traversing %g mm of %s equivalent",myPart,mmEquiv,myMaterial)); set(gca, 'YScale', 'log');
else
    % as a function of material thickness
    ShowMe(theta0*1000,mmEquiv,"\theta\timesL [mm]","thickness [mm]",sprintf("MCS for %s of %g %s",myPart,Ek,unitEk)); set(gca, 'YScale', 'log');
end


%% local functions

function theta0=ComputeTheta0(beta,pp,z,x,X0)
    % theta0 in [rad];
    % pp in [MeV/c];
    % x in [mm];
    % X0 in [cm];
    theta0=13.6./(beta.*pp)*z*sqrt(x*0.1./X0).*(1+0.038*log((x*0.1./X0)*(z./beta).^2));
end

function ShowMe(yData,xData,yLab,xLab,myTitle)
    figure();
    plot(xData,yData,".-");
    xlabel(xLab); ylabel(yLab);
    grid(); title(myTitle);
end

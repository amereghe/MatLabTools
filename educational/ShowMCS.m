% {}~

%% description
% this is a script which shows the Bethe-Bloch for the accelerated particles
% Refs:
% - main formula: PDG, 2018, Chap. 33, pag. 451 (eq. 33.15)
% - material parameters:
%   . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html

%% include libraries
% - include Matlab libraries
pathToLibrary="..\";
addpath(genpath(pathToLibrary));

%% settings
% - proton energies
EkMin_p=1; EkMax_p=230; EkStep_p=1; Ek_p=EkMin_p:EkStep_p:EkMax_p; % [MeV]
% - carbon energies
EkMin_C=1; EkMax_C=400; EkStep_C=1; Ek_C=EkMin_C:EkStep_C:EkMax_C; % [MeV/A]
% - range traversed
mmEquiv=1; % [mm]
% - water material parameters
X0_H2O=36.08; % [cm]

%% compute MCS scattering tables

% - load particle data
run(".\particleData.m");

% - relativistic quantities
[beta_p,gamma_p,betagamma_p]=ComputeRelativisticQuantities(Ek_p,mp);    % [], [], []
[beta_C,gamma_C,betagamma_C]=ComputeRelativisticQuantities(Ek_C*AC,mC); % [], [], []

% - MCS theta0 (Moliere's theory)
theta0_p=ComputeTheta0(beta_p,betagamma_p*mp,Zp,mmEquiv,X0_H2O);
theta0_C=ComputeTheta0(beta_C,betagamma_C*mC,ZC,mmEquiv,X0_H2O);
% - show theta0
ShowMe(theta0_p*1000,Ek_p,"\theta [mrad]","E_k [MeV]",sprintf("MCS for PROTONs after traversing %g mm of water equivalent",mmEquiv)); set(gca, 'YScale', 'log');
ShowMe(theta0_C*1000,Ek_C,"\theta [mrad]","E_k [MeV/u]",sprintf("MCS for CARBON ions after traversing %g mm of water equivalent",mmEquiv)); set(gca, 'YScale', 'log');

%% local functions

function theta0=ComputeTheta0(beta,pp,z,x,X0)
    % theta0 in [rad];
    % pp in [MeV/c];
    % x in [mm];
    % X0 in [cm];
    theta0=13.6./(beta.*pp)*z*sqrt(x*0.1/X0).*(1+0.038*log((x*0.1/X0)*(z./beta).^2));
end

function ShowMe(yData,xData,yLab,xLab,myTitle)
    figure();
    plot(xData,yData,".-");
    xlabel(xLab); ylabel(yLab);
    grid(); title(myTitle);
end

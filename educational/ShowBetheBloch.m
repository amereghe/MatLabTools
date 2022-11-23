% {}~

%% description
% this is a script which shows the Bethe-Bloch for the accelerated particles
% Refs:
% - main formula: PDG, 2018, Chap. 33, pag. 447 (eq. 33.5)
% - material parameters:
%   . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html
% - density effect: Sternheimer, Berger and Seltzer, ATOMIC DATA AND NUCLEAR DATA TABLES 30,26 l-27 1 (1984)

%% include libraries
% - include Matlab libraries
pathToLibrary="..\";
addpath(genpath(pathToLibrary));

%% settings
% - proton energies
EkMin_p=1; EkMax_p=230; EkStep_p=1; Ek_p=EkMin_p:EkStep_p:EkMax_p; % [MeV]
% - carbon energies
EkMin_C=1; EkMax_C=400; EkStep_C=1; Ek_C=EkMin_C:EkStep_C:EkMax_C; % [MeV/A]
% - water material parameters
ZoA_H2O=0.555087; % []
I_H2O=79.7; % [eV]
rho_H2O=1.0; % [g/cm3]
densEff_plasmaFreq_H20=21.469; % [eV]
densEff_C_H2O=3.5017; % actually, -C []
densEff_x0_H2O=0.2400; % []
densEff_x1_H2O=2.8004; % []
densEff_a_H2O=0.09116; % []
densEff_m_H2O=3.4773; % []
densEff_d0_H2O=0.0; % []

%% compute Bethe-Bloch tables

% - load particle data
run(".\particleData.m");

% - relativistic quantities
[beta_p,gamma_p,betagamma_p]=ComputeRelativisticQuantities(Ek_p,mp);    % [], [], []
[beta_C,gamma_C,betagamma_C]=ComputeRelativisticQuantities(Ek_C*AC,mC); % [], [], []

% - Wmax
Wmax_p=ComputeWmax(betagamma_p,gamma_p,mp); % [MeV]
Wmax_C=ComputeWmax(betagamma_C,gamma_C,mC); % [MeV]
% % - show Wmax
% ShowMe(Wmax_p,Ek_p,"W_{max} [MeV]","E_k [MeV]","W_{max} of PROTONs");
% ShowMe(Wmax_C,Ek_C,"W_{max} [MeV]","E_k [MeV/u]","W_{max} of CARBON ions");

% - density correction
densCorr_p_H2O=ComputeDensityCorrection(betagamma_p,densEff_x0_H2O,densEff_x1_H2O,densEff_a_H2O,densEff_m_H2O,densEff_C_H2O,densEff_d0_H2O); % []
densCorr_C_H2O=ComputeDensityCorrection(betagamma_C,densEff_x0_H2O,densEff_x1_H2O,densEff_a_H2O,densEff_m_H2O,densEff_C_H2O,densEff_d0_H2O); % []

% - Bethe-Bloch
dEodx_p=ComputeBetheBloch(Zp,beta_p,betagamma_p,Wmax_p,ZoA_H2O,I_H2O,densCorr_p_H2O); % [MeV/g cm2]
dEodx_C=ComputeBetheBloch(ZC,beta_C,betagamma_C,Wmax_C,ZoA_H2O,I_H2O,densCorr_C_H2O); % [MeV/g cm2]
% - show Bethe-Bloch
ShowMe(dEodx_p,betagamma_p,"<dE/dx> [MeV/g cm^2]","\beta\gamma []","Mean stopping power of PROTONs in WATER"); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
ShowMe(dEodx_C,betagamma_C,"<dE/dx> [MeV/g cm^2]","\beta\gamma []","Mean stopping power of CARBON ions in WATER"); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');

%% compute range
range_p=ComputeRange(Ek_p,dEodx_p*rho_H2O)*10; % [mm]
range_C=ComputeRange(Ek_C*AC,dEodx_C*rho_H2O)*10; % [mm]
% - show range
ShowMe(range_p,Ek_p,"R [mm]","E_k [MeV]","Range of PROTONs in WATER");
ShowMe(range_C,Ek_C,"R [mm]","E_k [MeV/u]","Range of CARBON ions in WATER");

%% compute delta_p/p for n-mm of water-equivalent material
% - range traversed
mmEquiv=1; % [mm]
% - actual calculation
dPoP_p=interp1(range_p,betagamma_p,range_p-mmEquiv)./betagamma_p-1;
dPoP_C=interp1(range_C,betagamma_C,range_C-mmEquiv)./betagamma_C-1;
% - show dPoP
ShowMe(dPoP_p,Ek_p,"\delta []","E_k [MeV]",sprintf("PROTON momentum variation after traversing %g mm of water equivalent",mmEquiv));
ShowMe(dPoP_C,Ek_C,"\delta []","E_k [MeV/u]",sprintf("CARBON ion momentum variation after traversing %g mm of water equivalent",mmEquiv));

%% local functions

function Wmax=ComputeWmax(betagamma,gamma,M)
    % Wmax in [MeV]
    elMass=0.5109989461; % [MeV/c2]
    Wmax=(2*elMass*betagamma.^2)./(1+2*gamma*elMass/M+(elMass/M)^2);
end

function meanSpower=ComputeBetheBloch(z,beta,betagamma,Wmax,ZoA,I,densCorr)
    % mean stopping power in MeV/g cm2
    % - Wmax in [MeV];
    % - I in [eV];
    K=0.307075; % [MeV cm2 /mol]
    elMass=0.5109989461; % [MeV/c2]
    if (~exist("densCorr","var")), densCorr=0.0; end
    meanSpower=K*z^2*ZoA./beta.^2.*(0.5*log(2*elMass*betagamma.^2.*Wmax*1E12/I^2)-beta.^2-densCorr/2);
end

function densCorr=ComputeDensityCorrection(betagamma,x0,x1,a,m,C,d0)
    if (~exist("d0","var")), d0=0.0; end
    densCorr=NaN(1,length(betagamma));
    x=log10(betagamma);
    indices=(x1<=x); densCorr(indices)=2*log(10)*x(indices)-C;
    indices=(x0<=x & x<x1); densCorr(indices)=2*log(10)*x(indices)-C+a*(x1-x(indices)).^m;
    indices=(x<x0); densCorr(indices)=d0*10.^(2*(x(indices)-x0)); % non-conductor
end

function range=ComputeRange(Ek,dEodx)
    % dEodx in [MeV/cm]
    % range in [cm]
    range=cumtrapz(Ek,1./(dEodx));
end

function ShowMe(yData,xData,yLab,xLab,myTitle)
    figure();
    plot(xData,yData,".-");
    xlabel(xLab); ylabel(yLab);
    grid(); title(myTitle);
end

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
Ek_p=1:1:230; % [MeV]
EkSel_p=228.57; % [MeV]
if (~exist("EkSel_p","var")),EkSel_p=max(Ek_p); end
% - carbon energies
Ek_C=1:1:400; % [MeV/A]
EkSel_C=398.84; % [MeV/A]
if (~exist("EkSel_C","var")),EkSel_C=max(Ek_C); end
% - range traversed
% mmEquiv=1; % [mm]
mmEquiv=0.1:0.01:4.1; % [mm]
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

%% Bethe-Bloch

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

% - actual calculation
dEodx_p=ComputeBetheBloch(Zp,beta_p,betagamma_p,Wmax_p,ZoA_H2O,I_H2O,densCorr_p_H2O); % [MeV/g cm2]
dEodx_C=ComputeBetheBloch(ZC,beta_C,betagamma_C,Wmax_C,ZoA_H2O,I_H2O,densCorr_C_H2O); % [MeV/g cm2]
% - show Bethe-Bloch
ShowMe(dEodx_p,betagamma_p,"<dE/dx> [MeV/g cm^2]","\beta\gamma []","Mean stopping power of PROTONs in WATER"); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
ShowMe(dEodx_C,betagamma_C,"<dE/dx> [MeV/g cm^2]","\beta\gamma []","Mean stopping power of CARBON ions in WATER"); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');

% - for selected energy:
%   . relativistic quantities
[betaSel_p,gammaSel_p,betagammaSel_p]=ComputeRelativisticQuantities(EkSel_p,mp);    % [], [], []
[betaSel_C,gammaSel_C,betagammaSel_C]=ComputeRelativisticQuantities(EkSel_C*AC,mC); % [], [], []
%   . Wmax
WmaxSel_p=ComputeWmax(betagammaSel_p,gammaSel_p,mp); % [MeV]
WmaxSel_C=ComputeWmax(betagammaSel_C,gammaSel_C,mC); % [MeV]
%   . density correction
densCorrSel_p_H2O=ComputeDensityCorrection(betagammaSel_p,densEff_x0_H2O,densEff_x1_H2O,densEff_a_H2O,densEff_m_H2O,densEff_C_H2O,densEff_d0_H2O); % []
densCorrSel_C_H2O=ComputeDensityCorrection(betagammaSel_C,densEff_x0_H2O,densEff_x1_H2O,densEff_a_H2O,densEff_m_H2O,densEff_C_H2O,densEff_d0_H2O); % []
%   . actual calculation
dEodxSel_p=ComputeBetheBloch(Zp,betaSel_p,betagammaSel_p,WmaxSel_p,ZoA_H2O,I_H2O,densCorrSel_p_H2O); % [MeV/g cm2]
dEodxSel_C=ComputeBetheBloch(ZC,betaSel_C,betagammaSel_C,WmaxSel_C,ZoA_H2O,I_H2O,densCorrSel_C_H2O); % [MeV/g cm2]

%% compute range (based on Bethe-Bloch)
range_p=ComputeRange(Ek_p,dEodx_p*rho_H2O)*10; % [mm]
range_C=ComputeRange(Ek_C*AC,dEodx_C*rho_H2O)*10; % [mm]
% - show range
ShowMe(range_p,Ek_p,"R [mm]","E_k [MeV]","Range of PROTONs in WATER");
ShowMe(range_C,Ek_C,"R [mm]","E_k [MeV/u]","Range of CARBON ions in WATER");
% - for selected energy:
rangeSel_p=interp1(betagamma_p,range_p,betagammaSel_p); % [mm]
rangeSel_C=interp1(betagamma_C,range_C,betagammaSel_C); % [mm]

%% compute delta_p/p for n-mm of water-equivalent material (based on Bethe-Bloch)
if (length(mmEquiv)==1)
    % vs beam energy for a specific thickness
    % - actual calculation
    dPoP_p=interp1(range_p,betagamma_p,range_p-mmEquiv)./betagamma_p-1;
    dPoP_C=interp1(range_C,betagamma_C,range_C-mmEquiv)./betagamma_C-1;
    % - show dPoP
    ShowMe(dPoP_p,Ek_p,"\delta []","E_k [MeV]",sprintf("PROTON momentum variation after traversing %g mm of water equivalent",mmEquiv));
    ShowMe(dPoP_C,Ek_C,"\delta []","E_k [MeV/u]",sprintf("CARBON ion momentum variation after traversing %g mm of water equivalent",mmEquiv));
else
    % vs thickness for a specific beam energy
    % - actual calculation
    dPoP_p=interp1(range_p,betagamma_p,rangeSel_p-mmEquiv)./betagammaSel_p-1;
    dPoP_C=interp1(range_C,betagamma_C,rangeSel_C-mmEquiv)./betagammaSel_C-1;
    % - show dPoP
    ShowMe(dPoP_p,mmEquiv,"\delta []","z_{H_2O} [mm]",sprintf("Momentum variation vs water equivalent thickness for %g MeV PROTONs",EkSel_p));
    ShowMe(dPoP_C,mmEquiv,"\delta []","z_{H_2O} [mm]",sprintf("Momentum variation vs water equivalent thickness for %g MeV/u CARBON IONs",EkSel_C));
end

%% Landau-Vavilov for n-mm of water-equivalent material
if (length(mmEquiv)==1)
    % vs beam energy for a specific thickness
    % - actual calculation
    mpEnLoss_p=ComputeLandauVavilov(Zp,beta_p,betagamma_p,mmEquiv/10*rho_H2O,ZoA_H2O,I_H2O,densCorr_p_H2O); % [MeV]
    mpEnLoss_C=ComputeLandauVavilov(ZC,beta_C,betagamma_C,mmEquiv/10*rho_H2O,ZoA_H2O,I_H2O,densCorr_C_H2O); % [MeV]
    % - show Landau-Vavilov
    ShowMe(mpEnLoss_p/(mmEquiv/10*rho_H2O),betagamma_p,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Most probable energy loss of PROTONs after traversing %g mm of water equivalent",mmEquiv)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
    ShowMe(mpEnLoss_C/(mmEquiv/10*rho_H2O),betagamma_C,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Most probable energy loss of CARBON IONs after traversing %g mm of water equivalent",mmEquiv)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
else
    % vs thickness for a specific beam energy
    % - actual calculation
    mpEnLoss_p=ComputeLandauVavilov(Zp,betaSel_p,betagammaSel_p,mmEquiv/10*rho_H2O,ZoA_H2O,I_H2O,densCorrSel_p_H2O); % [MeV]
    mpEnLoss_C=ComputeLandauVavilov(ZC,betaSel_C,betagammaSel_C,mmEquiv/10*rho_H2O,ZoA_H2O,I_H2O,densCorrSel_C_H2O); % [MeV]
    % - show Landau-Vavilov
    ShowMe(mpEnLoss_p,mmEquiv,"\DeltaE [MeV]","z_{H_2O} [mm]",sprintf("Most probable energy loss vs water equivalent thickness for %g MeV PROTONs",EkSel_p)); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
    ShowMe(mpEnLoss_C,mmEquiv,"\DeltaE [MeV]","z_{H_2O} [mm]",sprintf("Most probable energy loss vs water equivalent thickness for %g MeV/u CARBON IONs",EkSel_C)); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
end

%% compare Bethe-Bloch and Landau-Vavilov
if (length(mmEquiv)==1)
    ShowMyContent=NaN(2,size(dEodx_p,2)); ShowMyContent(1,:)=dEodx_p; ShowMyContent(2,:)=mpEnLoss_p/(mmEquiv/10*rho_H2O); myLegend=["<dE/dx> (Bethe-Bloch)" "most probable \DeltaE/x (Landau-Vavilov)"];
%     ShowMe(ShowMyContent,betagamma_p,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Bethe-Bloch vs Landau-Vavilov for PROTONs in %g mm of WATER",mmEquiv),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
    ShowMe(ShowMyContent,Ek_p,"\DeltaE [MeV/g cm^2]","E_k [MeV]",sprintf("Bethe-Bloch vs Landau-Vavilov for PROTONs in %g mm of WATER",mmEquiv),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
    ShowMyContent=NaN(2,size(dEodx_C,2)); ShowMyContent(1,:)=dEodx_C; ShowMyContent(2,:)=mpEnLoss_C/(mmEquiv/10*rho_H2O); myLegend=["<dE/dx> (Bethe-Bloch)" "most probable \DeltaE/x (Landau-Vavilov)"];
%     ShowMe(ShowMyContent,betagamma_C,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Bethe-Bloch vs Landau-Vavilov for CARBON ions in %g mm of WATER",mmEquiv),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
    ShowMe(ShowMyContent,Ek_C,"\DeltaE [MeV/g cm^2]","E_k [MeV/u]",sprintf("Bethe-Bloch vs Landau-Vavilov for CARBON ions in %g mm of WATER",mmEquiv),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
else
    dE_p=EkSel_p-interp1(range_p,Ek_p,rangeSel_p-mmEquiv);
    ShowMyContent=NaN(2,size(dE_p,2)); ShowMyContent(1,:)=dE_p; ShowMyContent(2,:)=mpEnLoss_p; myLegend=["<dE> (Bethe-Bloch)" "most probable \DeltaE (Landau-Vavilov)"];
    ShowMe(ShowMyContent,mmEquiv,"\DeltaE [MeV]","z_{H_2O} [mm]",sprintf("Bethe-Bloch vs Landau-Vavilov for %g MeV PROTONs in WATER",EkSel_p),myLegend); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
    dE_C=EkSel_C-interp1(range_C,Ek_C,rangeSel_C-mmEquiv); dE_C=dE_C*AC;
    ShowMyContent=NaN(2,size(dE_C,2)); ShowMyContent(1,:)=dE_C; ShowMyContent(2,:)=mpEnLoss_C; myLegend=["<dE> (Bethe-Bloch)" "most probable \DeltaE (Landau-Vavilov)"];
    ShowMe(ShowMyContent,mmEquiv,"\DeltaE [MeV]","z_{H_2O} [mm]",sprintf("Bethe-Bloch vs Landau-Vavilov for %g MeV/u CARBON ions in WATER",EkSel_C),myLegend); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
end

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

function mpEnLoss=ComputeLandauVavilov(z,beta,betagamma,x,ZoA,I,densCorr)
    % most probable energy loss according to Landau-Vavilov theory in MeV
    % - I in [eV];
    % - x in [g cm-2];
    K=0.307075; % [MeV cm2 /mol]
    elMass=0.5109989461; % [MeV/c2]
    csi=(K/2)*ZoA*z^2*(x./beta.^2);
    jj=0.20; % []
    if (~exist("densCorr","var")), densCorr=0.0; end
    mpEnLoss=csi.*(log(2*elMass*betagamma.^2.*1E6/I)+log(csi*1E6/I)+jj-beta.^2-densCorr);
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

function ShowMe(yData,xData,yLab,xLab,myTitle,myLegend)
    figure();
    for ii=1:size(yData,1)
        if (ii>1), hold on; end
        plot(xData,yData(ii,:),".-");
    end
    xlabel(xLab); ylabel(yLab);
    grid(); title(myTitle);
    if (exist("myLegend","var")), legend(myLegend,"Location","best"); end
end

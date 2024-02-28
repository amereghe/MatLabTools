% {}~

%% description
% this is a script which shows:
% * the Bethe-Bloch for the accelerated particles. Refs:
%   - main formula: PDG, 2018, Chap. 33, pag. 447 (eq. 33.5)
%   - material parameters:
%     . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html
%   - density effect: Sternheimer, Berger and Seltzer, ATOMIC DATA AND NUCLEAR DATA TABLES 30,26 l-27 1 (1984)
% * the Landau-Vavilov for the accelerated particles. Refs:
%   - main formula: PDG, 2018, Chap. 33, pag. 450 (eq. 33.11)
%   - material parameters:
%     . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html

%% include libraries
% - include Matlab libraries
pathToLibrary="..\";
addpath(genpath(pathToLibrary));

%% clean/close
clear all;
close all;

%% settings

% - particle
myPart="CARBON"; % available: "PROTON", "CARBON", "HELIUM"

% NOTA BENE: please choose either an array of values of Ek and a single value
%            for the range traversed or the other way around;
% - kinetic energies
% Ek=1:1:1000; % [MeV] % proton energies
Ek=1:1:400; % [MeV/A] % carbon energies
% Ek=228.57; % single energy

% - range traversed
mmEquiv=3.67; % [mm]
% mmEquiv=0.1:0.1:10.1; % [mm]

% - material
myMaterial="WATER";

%% complement user's input
if (length(Ek)>1 && length(mmEquiv)>1), error("Please choose to scan either energy or range!"); end
if (length(Ek)==1), Ek=1:1:Ek; end

%% Load particle data
% returns: myM [MeV/c2], myEk [MeV], myZ [], unitEk ("MeV" for protons, "MeV/u" for others);
[myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);

%% Load material data
% returns: ZoA [], I [eV], rho [g/cm3], densEff_plasmaFreq [eV], densEff_C [], 
%      densEff_x0 [], densEff_x1 [], densEff_a [], densEff_m [], densEff_d0 [], X0l [cm]
[ZoA,I,rho,densEff_plasmaFreq,densEff_C,densEff_x0,densEff_x1,densEff_a,densEff_m,densEff_d0,X0l]=...
    setMaterial(myMaterial);

%% Bethe-Bloch

% - relativistic quantities
[myBeta,myGamma,myBetaGamma]=ComputeRelativisticQuantities(myEk,myM);    % [], [], []

% - Wmax
Wmax=ComputeWmax(myBetaGamma,myGamma,myM); % [MeV]
% % - show Wmax
% ShowMe(Wmax,Ek,"W_{max} [MeV]",sprintf("E_k [%s]",unitEk),sprintf("W_{max} of %s",myPart));

% - density correction
densCorr=ComputeDensityCorrection(myBetaGamma,densEff_x0,densEff_x1,densEff_a,densEff_m,densEff_C,densEff_d0); % []

% - actual calculation
dEodx=ComputeBetheBloch(myZ,myBeta,myBetaGamma,Wmax,ZoA,I,densCorr); % [MeV/g cm2]
% - show Bethe-Bloch
ShowMe(dEodx,myBetaGamma,"<dE/dx> [MeV/g cm^2]","\beta\gamma []",sprintf("Mean stopping power of %s in %s",myPart,myMaterial)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
ShowMe(dEodx,Ek,"<dE/dx> [MeV/g cm^2]",sprintf("E_k [%s]",unitEk),sprintf("Mean stopping power of %s in %s",myPart,myMaterial)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
ShowMe(Wmax*1000,Ek,"W_{max} [keV]",sprintf("E_k [%s]",unitEk),sprintf("Max Energy transfer in a single collision of %s in %s",myPart,myMaterial)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');

%% compute range (based on Bethe-Bloch)
range=ComputeRange(myEk,dEodx*rho)*10; % [mm]
% - show range
ShowMe(range,Ek,"R [mm]",sprintf("E_k [%s]",unitEk),sprintf("Range of %s in %s",myPart,myMaterial));

%% compute delta_p/p for n-mm of water-equivalent material (based on Bethe-Bloch)
if (length(mmEquiv)==1)
    % - actual calculation
    dPoP=interp1(range,myBetaGamma,range-mmEquiv)./myBetaGamma-1;
    % - show dPoP vs beam energy for a specific thickness
    ShowMe(dPoP,Ek,"\delta []",sprintf("E_k [%s]",unitEk),sprintf("%s momentum variation after traversing %g mm of %s equivalent",myPart,mmEquiv,myMaterial));
else
    % - actual calculation
    dPoP=interp1(range,myBetaGamma,range(end)-mmEquiv)./myBetaGamma(end)-1;
    % - show dPoP vs thickness for a specific beam energy
    ShowMe(dPoP,mmEquiv,"\delta []","thickness [mm]",sprintf("Momentum variation vs %s equivalent thickness for %g %s %s",myMaterial,Ek(end),unitEk,myPart));
end

%% compute delta_energy for n-mm of water-equivalent material (based on Bethe-Bloch)
if (length(mmEquiv)==1)
    % - actual calculation
    dE=interp1(range,myEk,range-mmEquiv)-myEk;
    % - show dPoP vs beam energy for a specific thickness
    ShowMe(-dE,Ek,"\DeltaE [MeV]",sprintf("E_k [%s]",unitEk),sprintf("%s energy variation after traversing %g mm of %s equivalent",myPart,mmEquiv,myMaterial));
else
    % - actual calculation
    dE=interp1(range,myEk,range(end)-mmEquiv)-myEk;
    % - show dPoP vs thickness for a specific beam energy
    ShowMe(-dE,mmEquiv,"\DeltaE [MeV]","thickness [mm]",sprintf("Energy variation vs %s equivalent thickness for %g %s %s",myMaterial,Ek(end),unitEk,myPart));
end

%% save data
save("DE_CARBON_3.67mmH2O_AnalModel.mat","dE","Ek");

%% Landau-Vavilov for n-mm of water-equivalent material
if (length(mmEquiv)==1)
    % - actual calculation
    mpEnLoss=ComputeLandauVavilov(myZ,myBeta,myBetaGamma,mmEquiv/10*rho,ZoA,I,densCorr); % [MeV]
    % - show Landau-Vavilov vs beam energy for a specific thickness
    ShowMe(mpEnLoss/(mmEquiv/10*rho),myBetaGamma,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Most probable energy loss of %s after traversing %g mm of %s equivalent",myPart,mmEquiv,myMaterial)); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
else
    % - actual calculation
    mpEnLoss=ComputeLandauVavilov(myZ,myBeta(end),myBetaGamma(end),mmEquiv/10*rho,ZoA,I,densCorr(end)); % [MeV]
    % - show Landau-Vavilov vs thickness for a specific beam energy
    ShowMe(mpEnLoss,mmEquiv,"\DeltaE [MeV]","thickness [mm]",sprintf("Most probable energy loss vs %s equivalent thickness for %g %s %s IONs",myMaterial,Ek(end),unitEk,myPart)); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
end

%% compare Bethe-Bloch and Landau-Vavilov
if (length(mmEquiv)==1)
    ShowMyContent=NaN(2,size(dEodx,2)); ShowMyContent(1,:)=dEodx; ShowMyContent(2,:)=mpEnLoss/(mmEquiv/10*rho); myLegend=["<dE/dx> (Bethe-Bloch)" "most probable \DeltaE/x (Landau-Vavilov)"];
    ShowMe(ShowMyContent,myBetaGamma,"\DeltaE [MeV/g cm^2]","\beta\gamma []",sprintf("Bethe-Bloch vs Landau-Vavilov for %s in %g mm of %s",myPart,mmEquiv,myMaterial),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
    ShowMe(ShowMyContent,Ek,"\DeltaE [MeV/g cm^2]",sprintf("E_k [%s]",unitEk),sprintf("Bethe-Bloch vs Landau-Vavilov for %s in %g mm of %s",myPart,mmEquiv,myMaterial),myLegend); set(gca, 'YScale', 'log'); set(gca, 'XScale', 'log');
else
    dE=Ek(end)-interp1(range,Ek,range(end)-mmEquiv);
    ShowMyContent=NaN(2,size(dE,2)); ShowMyContent(1,:)=dE; ShowMyContent(2,:)=mpEnLoss; myLegend=["<dE> (Bethe-Bloch)" "most probable \DeltaE (Landau-Vavilov)"];
    ShowMe(ShowMyContent,mmEquiv,"\DeltaE [MeV]","thickness [mm]",sprintf("Bethe-Bloch vs Landau-Vavilov for %g %s %s in %s",Ek(end),unitEk,myPart,myMaterial),myLegend); set(gca, 'YScale', 'log'); % set(gca, 'XScale', 'log');
end

%% local functions

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

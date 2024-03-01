function [theta0,Ek]=ComputeMCSthetaRMS_H2O(Ek,myThickness,myPart)
% To compute the Root Mean Square (RMS) induced by Multiple Coulomb
%      Scattering (MCS) of a massive charged particle (hadrons/muons) when
%      going through a material;
% From PDG, 2018, Chap. 33, pag. 451 (eq. 33.15)
%
% input:
% - Ek (1D array or scalar): kinetic energy for which the Bethe-Bloch is
%      evaluated; protons: [MeV]; ions: [MeV/u];
% - myThickness (1D array or scalar): H2O thicknesses [mm];
% - myPart: "PROTON"/"HELIUM"/"CARBON";
%
% output vars:
% - theta0 (2D array): RMS angle due to MCS [rad];
%
% NB: size(theta0)=(length(Ek),length(myThickness))
%     length(beta)=length(pp)
%
    if (~exist("myPart","var")), myPart=missing(); end
    if (~exist("Ek","var")), Ek=missing(); end
    if (ismissing(Ek)), Ek=max(EkQuery); end
    if (length(Ek)==1), Ek=0.1:0.1:Ek; end

    % - set particle properties based on myPart var
    %   returns: myM [MeV/c2], myEk [MeV], myZ [], unitEk 
    %            ("MeV" for protons, "MeV/u" for others);
    [myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);
    
    % - load material data
    %   returns: ZoA [], I [eV], rho [g/cm3], plasmaFreq [eV], C [], x0 [],
    %   x1 [], a [], m [], d0 [], X0l [cm]
    [ZoA,I,rho,plasmaFreq,C,x0,x1,a,m,d0,X0l]=setMaterial("WATER");
    
    % - relativistic quantities: [], [], []
    [myBeta,myGamma,myBetaGamma]=ComputeRelativisticQuantities(myEk,myM);
    
    % - actual calculation [rad]
    theta0=ComputeMCSthetaRMS(myBeta,myBetaGamma*myM,myZ,myThickness,X0l);
    
end
function dEodx=ComputeBetheBloch_H2O(Ek,myPart)
% input:
% - Ek (1D array or scalar): kinetic energy for which the Bethe-Bloch is
%      evaluated; protons: [MeV]; ions: [MeV/u];
% - myPart: "PROTON"/"HELIUM"/"CARBON";
%
% output:
% - dEodx (1D array): stopping power in water mapped on Ek [MeV/g cm2];
%   NB: length(dEodx)=length(Ek)
%
    if (~exist("myPart","var")), myPart=missing(); end
    
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
    % - Wmax
    Wmax=ComputeWmax(myBetaGamma,myGamma,myM); % [MeV]
    % - density correction
    densCorr=ComputeDensityCorrection(myBetaGamma,x0,x1,a,m,C,d0); % []
    
    % - actual calculation [MeV/g cm2]
    dEodx=ComputeBetheBloch(myZ,myBeta,myBetaGamma,Wmax,ZoA,I,densCorr);

end

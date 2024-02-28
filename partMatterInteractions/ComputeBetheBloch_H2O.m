function dEodx=ComputeBetheBloch_H2O(Ek,myPart)
    if (length(Ek)==1), Ek=0.1:0.1:Ek; end
    if (~exist("myPart","var")), myPart="N/A"; end
    
    % - set particle properties based on myPart var
    %   returns: myM [MeV/c2], myEk [MeV], myZ [], unitEk ("MeV" for protons, "MeV/u" for others);
    [myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);
    
    % - load material data
    %   returns: ZoA [], I [eV], rho [g/cm3], plasmaFreq [eV], C [], x0 [],
    %   x1 [], a [], m [], d0 [], X0l [cm]
    [ZoA,I,rho,plasmaFreq,C,x0,x1,a,m,d0,X0l]=setMaterial("WATER");

    % - relativistic quantities
    [myBeta,myGamma,myBetaGamma]=ComputeRelativisticQuantities(myEk,myM);    % [], [], []
    % - Wmax
    Wmax=ComputeWmax(myBetaGamma,myGamma,myM); % [MeV]
    % - density correction
    densCorr=ComputeDensityCorrection(myBetaGamma,x0,x1,a,m,C,d0); % []
    
    % - actual calculation
    dEodx=ComputeBetheBloch(myZ,myBeta,myBetaGamma,Wmax,ZoA,I,densCorr); % [MeV/g cm2]

end

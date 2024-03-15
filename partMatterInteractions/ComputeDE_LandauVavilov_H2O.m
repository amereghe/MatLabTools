function [DEquery,Ek]=ComputeDE_LandauVavilov_H2O(EkQuery,myThinckness,myPart,Ek)
% input:
% - EkQuery (1D array or scalar): kinetic energies for which the DE is
%      computed; protons: [MeV]; ions: [MeV/u];
% - myThickness (1D array or scalar): H2O thicknesses [mm];
% - myPart: "PROTON"/"HELIUM"/"CARBON";
% - Ek (1D array or scalar, optional): kinetic energies for tabulating
%      dEodx values; protons: [MeV]; ions: [MeV/u];
%
% output:
% - DEquery (2D array): energy loss in water mapped on Ek [MeV];
%   NB: DEquery<0 means that the energy is lost!!!
% - Ek (1D array): kinetic energies for tabulating dEodx values;
%      protons: [MeV]; ions: [MeV/u];
%
% NB: size(DE)=(length(EkQuery),length(myThinckness))
%     length(range)=length(dEodx)=length(Ek)
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
    % - density correction
    densCorr=ComputeDensityCorrection(myBetaGamma,x0,x1,a,m,C,d0); % []
    
    DEquery=NaN(length(EkQuery),length(myThinckness));
    for iThick=1:length(myThinckness)
        % - actual calculation [MeV]
        DE=-ComputeLandauVavilov(myZ,myBeta,myBetaGamma,myThinckness(iThick)/10*rho,ZoA,I,densCorr);
        % - compute DE [MeV]
        DEquery(:,iThick)=interp1(Ek,DE,EkQuery,"spline");
    end

end
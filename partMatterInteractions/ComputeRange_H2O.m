function [rangeQuery,dEodx,Ek]=ComputeRange_H2O(EkQuery,myPart,Ek)
% input:
% - EkQuery (1D array or scalar): kinetic energies for which the range is
%      computed; protons: [MeV]; ions: [MeV/u];
% - myPart: "PROTON"/"HELIUM"/"CARBON";
% - Ek (1D array or scalar, optional): kinetic energies for tabulating
%      dEodx values; protons: [MeV]; ions: [MeV/u];
%
% output:
% - rangeQuery (1D array): range in water of particles with kinetic energy
%      EkQuery [mm];
% - dEodx (1D array): stopping power in water mapped on Ek [MeV/g cm2];
% - Ek (1D array): kinetic energies for tabulating dEodx values;
%      protons: [MeV]; ions: [MeV/u];
%
% NB: length(range)=length(EkQuery)
%     length(dEodx)=length(Ek)
%
    if (~exist("myPart","var")), myPart=missing(); end
    if (~exist("Ek","var")), Ek=missing(); end
    if (ismissing(Ek)), Ek=max(EkQuery); end
    if (length(Ek)==1), Ek=0.1:0.1:Ek; end
    
    % - set particle properties based on myPart var
    %   returns: myM [MeV/c2], myEk [MeV], myZ [],
    %            unitEk ("MeV" for protons, "MeV/u" for others);
    [myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);
    
    % - load material data
    %   returns: ZoA [], I [eV], rho [g/cm3], plasmaFreq [eV], C [], x0 [],
    %   x1 [], a [], m [], d0 [], X0l [cm]
    [ZoA,I,rho,plasmaFreq,C,x0,x1,a,m,d0,X0l]=setMaterial("WATER");
    
    % - tabulation of stopping power [MeV/g cm2]
    dEodx=ComputeBetheBloch_H2O(Ek,myPart);
    
    % - compute range at query points, based on tabulated stopping power
    %   [mm]
    rangeQuery=interp1(Ek,ComputeRange(myEk,dEodx*rho)*10,EkQuery,"spline");
end
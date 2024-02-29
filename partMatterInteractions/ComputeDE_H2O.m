function [DEquery,range,dEodx,Ek]=ComputeDE_H2O(EkQuery,myThinckness,myPart,Ek)
% input:
% - EkQuery (1D array or scalar): kinetic energies for which the DE is
%      computed; protons: [MeV]; ions: [MeV/u];
% - myThickness (1D array or scalar): H2O thicknesses [mm];
% - myPart: "PROTON"/"HELIUM"/"CARBON";
% - Ek (1D array or scalar, optional): kinetic energies for tabulating
%      dEodx values; protons: [MeV]; ions: [MeV/u];
%
% output:
% - DEquery (1D array): energy loss in water mapped on Ek [MeV];
% - range (1D array): range in water of particles with kinetic energy
%      EkQuery [mm];
% - dEodx (1D array): stopping power in water mapped on Ek [MeV/g cm2];
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
    
    % - get range
    [range,dEodx,Ek]=ComputeRange_H2O(Ek,myPart,Ek);
    
    % - set particle properties based on myPart var
    %   returns: myM [MeV/c2], myEk [MeV], myZ [], unitEk ("MeV" for protons, "MeV/u" for others);
    [myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart);
    
    DEquery=NaN(length(EkQuery),length(myThinckness));
    for iThick=1:length(myThinckness)
        % - tabulation of DE values
        DE=interp1(range,myEk,range-myThinckness(iThick),"spline")-myEk; % [MeV]
        % - compute DE [MeV]
        DEquery(:,iThick)=interp1(Ek,DE,EkQuery,"spline");
    end

end
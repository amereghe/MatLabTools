function range=ComputeRange(Ek,dEodx)
% To convert the provided map stopping power vs kinetic energy into
%     range vs kinetic energy;
%
% input vars:
% - Ek (1D array): kinetic energy of particle (NOT per nucleon) [MeV];
% - dEodx (1D array): stopping power of particle[MeV/cm];
% NB: length(Ek)=length(dEodx);
%
% output vars:
% - range (1D array): particle range [cm];
% NB: length(range)=length(Ek)=length(dEodx);
%
    range=cumtrapz(Ek,1./(dEodx));
end


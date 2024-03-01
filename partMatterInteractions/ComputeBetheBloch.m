function meanSpower=ComputeBetheBloch(z,beta,betagamma,Wmax,ZoA,I,densCorr)
% To compute the mean stopping power of a massive charged particle (hadrons/muons)
% From PDG, 2018, Chap. 33, pag. 447 (eq. 33.5)
%
% input vars:
% - z (scalar): particle charge;
% - beta (1D array): reduced speed of particle (special relativity) [];
% - betagamma (1D array): product of reduced speed and energy of particle
%  (special relativity) [];
% - Wmax (1D array, same size as betagamma and gamma): max energy transfer
%   [MeV];
% - ZoA (scalar): ratio between atomic number and mass number of the
%   material [];
% - I (scalar): mean excitation energy [eV];
% - densCorr (1D array, optional): density correction [];
% NB: length(betagamma)=length(beta)=length(densCorr);
%
% output vars:
% - meanSpower (1D array): mean stopping power [MeV/g cm2];
% NB: length(meanSpower)=length(betagamma)=length(beta)=length(densCorr);
%
    K=0.307075; % [MeV cm2 /mol]
    % load particle data; in particular, electron mass me [MeV/c2]
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeBetheBloch","educational\particleData.m"));
    if (~exist("densCorr","var")), densCorr=0.0; end
    meanSpower=K*z^2*ZoA./beta.^2.*(0.5*log(2*me*betagamma.^2.*Wmax*1E12/I^2)-beta.^2-densCorr/2);
end

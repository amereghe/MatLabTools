function mpEnLoss=ComputeLandauVavilov(z,beta,betagamma,x,ZoA,I,densCorr)
% To compute the most probable energy loss according to Landau-Vavilov
%       of a massive charged particle (hadrons/muons)
% From PDG, 2018, Chap. 33, pag. 450 (eq. 33.11)
%
% input vars:
% - z (scalar): particle charge;
% - beta (1D array): reduced speed of particle (special relativity) [];
% - betagamma (1D array): product of reduced speed and energy of particle
%  (special relativity) [];
% - x (scalar): material thickness [g cm-2];
% - ZoA (scalar): ratio between atomic number and mass number of the
%   material [];
% - I (scalar): mean excitation energy [eV];
% - densCorr (1D array, optional): density correction [];
% NB: length(betagamma)=length(beta)=length(densCorr);
%
% output vars:
% - mpEnLoss (1D array): most probable energy loss [MeV];
% NB: length(mpEnLoss)=length(betagamma)=length(beta)=length(densCorr);
%
    K=0.307075; % [MeV cm2 /mol]
    % load particle data; in particular, electron mass me [MeV/c2]
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeLandauVavilov","educational\particleData.m"));
    csi=(K/2)*ZoA*z^2*(x./beta.^2);
    jj=0.20; % []
    if (~exist("densCorr","var")), densCorr=0.0; end
    mpEnLoss=csi.*(log(2*me*betagamma.^2.*1E6/I)+log(csi*1E6/I)+jj-beta.^2-densCorr);
end


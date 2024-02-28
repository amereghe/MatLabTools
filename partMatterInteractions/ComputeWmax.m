function Wmax=ComputeWmax(betagamma,gamma,M)
% To compute the max energy transfer to electrons by a massive charged
%    particle (hadrons/muons)
% From PDG, 2018, Chap. 33, pag. 447 (eq. 33.5)
%
% input vars:
% - betagamma (1D array): product of reduced speed and energy (special
%   relativity) [];
% - gamma (1D array): reduced speed energy (special relativity) [];
% - M (scalar): particle mass [MeV/c2];
% NB: length(betagamma)=length(gamma);
% 
% output vars:
% - Wmax (1D array, same size as betagamma and gamma): max energy transfer
%   [MeV];
% NB: length(Wmax)=length(betagamma)=length(gamma);
%
    % load particle data; in particular, electron mass me [MeV/c2]
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeWmax","educational\particleData.m"));
    Wmax=(2*me*betagamma.^2)./(1+2*gamma*me/M+(me/M)^2);
end

function densCorr=ComputeDensityCorrection(betagamma,x0,x1,a,m,C,d0)
% To compute the density correction, to be used for calculating the 
%        stopping power of a massive charged particle (hadrons/muons)
% Formula from Sternheimer, Berger and Seltzer, ATOMIC DATA AND NUCLEAR DATA TABLES 30,26 l-27 1 (1984)
%
% input vars:
% - betagamma (1D array): product of reduced speed and energy (special
%   relativity) [];
% - x0, x1, a, m, C, d0 (scalars): material parameters;
%
% output vars:
% - densCorr (1D array): density corrections [];
% NB: length(densCorr)=length(betagamma);

    if (~exist("d0","var")), d0=0.0; end
    densCorr=NaN(1,length(betagamma));
    x=log10(betagamma);
    indices=(x1<=x); densCorr(indices)=2*log(10)*x(indices)-C;
    indices=(x0<=x & x<x1); densCorr(indices)=2*log(10)*x(indices)-C+a*(x1-x(indices)).^m;
    indices=(x<x0); densCorr(indices)=d0*10.^(2*(x(indices)-x0)); % non-conductor
end

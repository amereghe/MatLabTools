function theta0=ComputeMCSthetaRMS(beta,pp,z,myThickness,X0)
% To compute the Root Mean Square (RMS) induced by Multiple Coulomb
%      Scattering (MCS) of a massive charged particle (hadrons/muons) when
%      going through a material;
% From PDG, 2018, Chap. 33, pag. 451 (eq. 33.15)
%
% input vars:
% - beta (1D array or scalar): reduced speed of particle (special relativity) [];
% - pp (1D array or scalar): momentum of particle (special relativity) [MeV/c];
% - z (scalar): particle charge [];
% - myThickness (1D array or scalar): thickness of material traversed by 
%   the particle [mm];
% - X0 (scalar): radiation length of traversed material [cm];
% NB: length(betagamma)=length(beta)=length(densCorr);
%
% output vars:
% - theta0 (2D array): RMS angle due to MCS [rad];
%
% NB: size(theta0)=(length(beta),length(myThickness))
%     length(beta)=length(pp)
%
    theta0=NaN(length(beta),length(myThickness));
    for iThick=1:length(myThickness)
        theta0(:,iThick)=13.6./(beta.*pp)*z*sqrt(myThickness(iThick)*0.1./X0).*...
            (1+0.038*log((myThickness(iThick)*0.1./X0)*(z./beta).^2));
    end
end
% {}~



function theta0=computeTheta0(bPart, pcPart, zPart, xx, X0)
% this function implements the formula for the theta_RMS plane reported in
% the PDG (2018 ed, 33.15) by Lynch & Dahl
%     https://www.sciencedirect.com/science/article/abs/pii/0168583X9195671Y?via%3Dihub
% inputs:
%   bPart: relativistic normalised speed [];
%   pcPart: particle momentum [MeV/c];
%   zPart: charge state of the particle [];
%   xx: xx of material to be traversed [same as X0];
%   X0: radiation length [same as xx];
    theta0=13.6/(bPart*pcPart)*zPart*sqrt(xx/X0)*(1+0.038*log((xx/X0)*(zPart/bPart)^2));
end
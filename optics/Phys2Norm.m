function [zOut]=Phys2Norm(zIn,beta,alpha,emiG)
% Phys2Norm(zIn,beta,alpha,emiG)     to transform a set of particle
%                                       coordinates from physical units to
%                                       normalised units
% input:
% - zIn (float(nPoints,2)): beam population (physical units [m,rad]);
% - alpha,beta,emiG (float): optics functions used to compute physical
%   coordinates;
% output:
% - zOut(float(nPoints,2)): beam population (normalised units [,]);

    if (~exist("emiG","var")), emiG=1; end
    % one plane at a time!
    TT=[1 0; alpha beta]/sqrt(beta*emiG);
    zOut=TT*zIn';
    zOut=zOut';
end

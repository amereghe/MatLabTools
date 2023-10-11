function [zOut]=Norm2Phys(zIn,beta,alpha,emiG)
% Norm2Phys(zIn,beta,alpha,emiG)     to transform a set of particle
%                                       coordinates from normalised units to
%                                       physical units
% input:
% - zIn (float(nPoints,2)): beam population (normalised units [,]);
% - alpha,beta,emiG (float): optics functions used to compute physical
%   coordinates;
% output:
% - zOut(float(nPoints,2)): beam population (physical units [m,rad]);

    if (~exist("emiG","var")), emiG=1; end
    % one plane at a time!
    TT=[1 0; -alpha/beta 1/beta]*sqrt(beta*emiG);
    zOut=TT*zIn';
    zOut=zOut';
end

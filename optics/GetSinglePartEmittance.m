function [emiG]=GetSinglePartEmittance(MyPoints,alpha,beta,gamma)
% GetSinglePartEmittance(MyPoints,alpha,beta,gamma)
%      to get the single-particle emittance for all particles in the given
%         beam population, estimated based on the given optics functions.
%
% input:
% - MyPoints (float(nPoints,2)): beam population (physical units [m,rad]);
% - alpha,beta,gamma (float): optics functions used to compute emittances
%   [,m,m^-1]. gamma is optional, whereas the other two are mandatory;
% output:
% - emiG(float(nPoints)): single-particle emittances [m,rad];

    % one plane at a time!
    if (~exist("gamma","var")), gamma=(1+alpha^2)/beta; end
    emiG=NaN(size(MyPoints,1),1);
    emiG=gamma*MyPoints(:,1).^2+2*alpha*MyPoints(:,1).*MyPoints(:,2)+beta*MyPoints(:,2).^2;
end

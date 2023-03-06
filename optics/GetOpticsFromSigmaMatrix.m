function [alpha,beta,emiG,sigM]=GetOpticsFromSigmaMatrix(MyPoints)
% GetOpticsFromSigmaMatrix(MyPoints) to get the beam optics functions from 
%                                       the statistical analysis of the beam
%
% input:
% - MyPoints (float(nPoints,2)): beam population (physical units [m,rad]);
% output:
% - alpha,beta,emiG (float): optics functions and emittance of the beam 
%   population [,m,m rad];
% - sigM (float(2,2)): sigma matrix;

    % one plane at a time!
    sigM=cov(MyPoints);
    [beta,alpha,emiG]=DecodeOpticsFit([sigM(1,1) sigM(1,2) sigM(2,2)]);
end

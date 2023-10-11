function [alpha,beta,emiG,sigM,bars]=GetOpticsFromSigmaMatrix(MyPoints)
% GetOpticsFromSigmaMatrix(MyPoints) to get the beam optics functions from 
%                                       the statistical analysis of the beam
%
% input:
% - MyPoints (float(nPoints,2)): beam population (physical units [m,rad]);
% output:
% - alpha,beta,emiG (float): optics functions and emittance of the beam 
%   population [,m,m rad];
% - sigM (float(2,2)): sigma matrix;
% - bars (float(2,1)): mean of the point distributions;

    % one plane at a time!
    bars=mean(MyPoints);
    sigM=cov(MyPoints);
    [beta,alpha,emiG]=DecodeOpticsFit([sigM(1,1) sigM(1,2) sigM(2,2)]);
end

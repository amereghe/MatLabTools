function [alpha,beta,emiG,sigM]=GetOpticsFromSigmaMatrix(MyPoints)
    sigM=cov(MyPoints);
    [beta,alpha,emiG]=DecodeOpticsFit([sigM(1,1) sigM(1,2) sigM(2,2)]);
end

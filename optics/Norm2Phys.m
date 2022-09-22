function [zOut]=Norm2Phys(zIn,beta,alpha,emiG)
    TT=[1 0; -alpha/beta 1/beta]*sqrt(beta*emiG);
    zOut=TT*zIn';
    zOut=zOut';
end

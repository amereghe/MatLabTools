function [zOut]=Phys2Norm(zIn,beta,alpha,emiG)
    TT=[1 0; alpha beta]/sqrt(beta*emiG);
    zOut=TT*zIn';
    zOut=zOut';
end

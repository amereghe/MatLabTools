function A=TransportMatrixQuad(k1,lQ,thin)
% TransportMatrixQuad  Compute the 2x2 transport matrix of a quad.
% 
% input arguments:
% - k1: K1 of the quad [m^-2] - can be an array;
% - lQ: length of the quad [m] - can be an array;
% - thin: if true, the thin-lens matrix is returned - optional;
% 
% only k1 and lQ can be arrays singularly, not at the same time.

    iThin=0;
    if ( exist('thin','var') )
        iThin=thin;
    end
    if ( length(kl)>1 & length(lQ)>1 )
        error("length(kl)>1 & length(lQ)>1");
    else
        ll=max(length(k1),length(lQ));
    end
    if ( sum(lQ<0)>0 )
        error("Negative quadrupole length(s)!");
    end
    
    A=zeros(2,2,ll);
    if ( iThin )
        A(1,1,:)=1;
        A(1,2,:)=0;
        A(2,1,:)=-k1*lQ;
        A(2,2,:)=1;
    else
        % thick quad
        indicesF=(k1>0);
        sqrtKs=sqrt(abs(k1));
        phis=sqrtKs*lQ;
        % focussing part
        A(1,1,indicesF)=cos(phis(indicesF));
        A(1,2,indicesF)=sin(phis(indicesF))./sqrtKs(indicesF);
        A(2,1,indicesF)=-sqrtKs(indicesF).*sin(phis(indicesF));
        % de-focussing part
        A(1,1,~indicesF)=cosh(phis(~indicesF));
        A(1,2,~indicesF)=sinh(phis(~indicesF))./sqrtKs(~indicesF);
        A(2,1,~indicesF)=sqrtKs(~indicesF).*sinh(phis(~indicesF));
        %
        A(2,2,:)=A(1,1,:);
    end
end
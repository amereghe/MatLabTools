function A=TransportMatrixDrift(lD)
% TransportMatrixDrift  Compute the 2x2 transport matrix of a drift.
% 
% input arguments:
% - lD: length of the drift [m] - can be an array;

    if ( sum(lD<0)>0 )
        error("Negative drift length(s)!");
    end
    
    A=zeros(2,2,length(lD));
    A(1,1,:)=1;
    A(1,2,:)=lD;
    A(2,1,:)=0;
    A(2,2,:)=1;
end
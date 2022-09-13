function [emiG]=GetSinglePartEmittance(MyPoints,alpha,beta,gamma)
    if (~exist("gamma","var")), gamma=(1+alpha^2)/beta; end
    emiG=NaN(size(MyPoints,1),1);
    emiG=gamma*MyPoints(:,1).^2+2*alpha*MyPoints(:,1).*MyPoints(:,2)+beta*MyPoints(:,2).^2;
end

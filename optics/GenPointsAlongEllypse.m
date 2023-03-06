function MyEllypse=GenPointsAlongEllypse(alpha,beta,emiG,dAng)
% GenPointsAlongEllypse(alpha,beta,emiG,dAng)     generates points along an
%                                                    optics ellypse
%
% By default, the function generates 361 points (one per degree, included 0
%    and 360 degs), equispaced along the ellypse descriibed by the given optics
%    functions.
% If emiG is an array and beta/alpha are scalars, then as many ellypses as
%    length(emiG) are generated, all with the same optics functions.
% If beta/alpha are arrays like emiG, then the ellypses will all be different
%    from each other.
%
    %% input data
    if (~exist("dAng","var")), dAng=1; end
    angs=0:dAng:360;
    nEllypses=length(emiG);
    if (length(alpha)==1 && nEllypses>1), alpha=ones(nEllypses,1)*alpha; end
    if (length( beta)==1 && nEllypses>1), beta =ones(nEllypses,1)* beta; end
    if (length(alpha)~=length(emiG)), error("length(alpha)~=length(emiG)"); end
    if (length(beta )~=length(emiG)), error("length(beta )~=length(emiG)"); end
    
    %% generate ellypses
    MyEllypse=NaN(length(angs),2,nEllypses);
    for ii=1:nEllypses
        MyEllypse(:,1,ii)=cosd(angs);
        MyEllypse(:,2,ii)=sind(angs);
        MyEllypse(:,:,ii)=Norm2Phys(MyEllypse(:,:,ii),beta(ii),alpha(ii),emiG(ii));
    end
end

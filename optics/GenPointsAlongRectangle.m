function MyRect=GenPointsAlongRectangle(bb,hh,nX,nY)
% GenPointsAlongRectangle(bb,hh,nX,nY)     generates points along an optics
%                                               rectangle (e.g. contour of
%                                               bar of charge)
%
% By default, the function generates 2*nX+2*(nY-2)+1 (to avoid repetirions,
%    apart from the first/last one), equispaced along the rectangle of
%    half-basis bb and half-height hh.
% The rectangle is centered along the two axis - hence the ranges are:
%    [-bb:bb] and [-hh:hh].
% If bb/hh are arrays, then as many rectangles as length(bb)/length(hh) 
%    are generated.
%
    %% input data
    if (~exist("nX","var")), nX=41; end
    if (~exist("nY","var")), nY=21; end
    nBB=length(bb); nHH=length(hh); nRects=max(nBB,nHH);
    if (nBB==1 && nHH~=1), bb=ones(nRects,1)*bb; end
    if (nBB~=1 && nHH==1), hh=ones(nRects,1)*hh; end
    if (length(bb)~=length(hh)), error("length(bb)~=length(hh)"); end
    
    nBarPoints=2*(nX+nY-2)+1;
    
    %% generate rectangles
    MyRect=NaN(nBarPoints,2,nRects);
    for ii=1:nRects
        xDom=linspace(-bb(ii),bb(ii),nX);
        yDom=linspace(-hh(ii),hh(ii),nY); yDom=yDom(2:end-1); % avoid repetitions
        MyRect(1:end-1,1,ii)=[ xDom                         bb(ii)*ones(1,length(yDom))  xDom(end:-1:1)              -bb(ii)*ones(1,length(yDom)) ]; 
        MyRect(1:end-1,2,ii)=[-hh(ii)*ones(1,length(xDom))  yDom                         hh(ii)*ones(1,length(xDom)) yDom(end:-1:1)               ];
        MyRect(end,:,ii)=MyRect(1,:,ii);
    end
end


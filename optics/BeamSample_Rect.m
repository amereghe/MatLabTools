function MyPoints=BeamSample_Rect(nPoints,bb,hh)
% BeamSample_Rect(nPoints,bb,hh)     generates points inside an optics
%                                        rectangle (e.g. bar of charge),
%                                        uniformly distributed;
%
% The rectangle is centered along the two axis - hence the ranges are:
%    [-bb:bb] and [-hh:hh].
% If bb/hh are arrays, then as many beam populations as length(bb)/length(hh) 
%    are generated.
%
    %% input data
    nBB=length(bb); nHH=length(hh); nBeamSamples=max(nBB,nHH);
    if (nBB==1 && nHH~=1), bb=ones(nBeamSamples,1)*bb; end
    if (nBB~=1 && nHH==1), hh=ones(nBeamSamples,1)*hh; end
    if (length(bb)~=length(hh)), error("length(bb)~=length(hh)"); end
    
    %% generate populations
    MyPoints=NaN(nPoints,2,nBeamSamples);
    for ii=1:nBeamSamples
        MyPoints(:,1,ii)=2*bb(ii)*rand(nPoints,1)-bb(ii);
        MyPoints(:,2,ii)=2*hh(ii)*rand(nPoints,1)-hh(ii);
    end
end

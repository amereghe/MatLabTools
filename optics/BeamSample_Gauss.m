function MyPoints=BeamSample_Gauss(nPoints,alpha,beta,emiG)
% BeamSample_Gauss(nPoints,alpha,beta,emiG)     generates points with a 2D 
%                                          Gaussian distribution filling the
%                                          ellypse described by the given optics
%                                          functions.
%
% If emiG is an array and beta/alpha are scalars, then as many ellypses as
%    length(emiG) are generated, all with the same optics functions.
% If beta/alpha are arrays like emiG, then the ellypses will all be different
%    from each other.
% The beam population(s) are centered in [0,0].
%
    %% input data
    if (~exist("alpha","var")), alpha=0; end
    if (~exist("beta","var")), alpha=1; end
    if (~exist("emiG","var")), emiG=1E-6; end
    nBeamSamples=length(emiG);
    if (length(alpha)==1 && nBeamSamples>1), alpha=ones(nBeamSamples,1)*alpha; end
    if (length( beta)==1 && nBeamSamples>1), beta =ones(nBeamSamples,1)* beta; end
    if (length(alpha)~=length(emiG)), error("length(alpha)~=length(emiG)"); end
    if (length(beta )~=length(emiG)), error("length(beta )~=length(emiG)"); end
    
    %% generate populations
    MyPoints=NaN(nPoints,2,nBeamSamples);
    for ii=1:nBeamSamples
        u1=rand(nPoints,1);
        u2=rand(nPoints,1);
        
        % Box-Mueller Transform
        rr=sqrt(-2*log(u1));
        phi=2*pi*u2;
        MyPoints(:,1,ii)=rr.*cos(phi);
        MyPoints(:,2,ii)=rr.*sin(phi);
        MyPoints(:,:,ii)=Norm2Phys(MyPoints(:,:,ii),beta(ii),alpha(ii),emiG(ii));
    end
end

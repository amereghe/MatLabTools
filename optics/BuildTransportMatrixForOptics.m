function C=BuildTransportMatrixForOptics(A)
% BuildTransportMatrixForOptics      builds the matrix for transporting optics
%                                      functions (beta,alpha,gamma) starting from
%                                      the orbit transport matrix
%
% - input:
%   . A: 2D transport matrix (2x2xNconfigs) on a single plane. The third
%        dimension is used to separate different powering configurations of
%        the same piece of beam line;
%
% - outpus:
%   . C: 2D transport matrix (3x3xNconfigs) on a single plane. The third
%        dimension is used to separate different powering configurations of
%        the same piece of beam line;
%
% NB: the third dim of C is equal to the third one of A, to represent
%     a series of matrices
%
% see also DecodeOpticsFit, DecodeOrbitFit, FitOpticsThroughSigmaData,
%     SolveCoSystem and SolveSigSystem
    C=zeros(3,3,size(A,3));
    %
    C(1,1,:)=A(1,1,:).^2;
    C(1,2,:)=-2*A(1,1,:).*A(1,2,:);
    C(1,3,:)=A(1,2,:).^2;
    %
    C(2,1,:)=-A(1,1,:).*A(2,1,:);
    C(2,2,:)=A(1,1,:).*A(2,2,:)+A(2,1,:).*A(1,2,:);
    C(2,3,:)=-A(1,2,:).*A(2,2,:);
    %
    C(3,1,:)=A(2,1,:).^2;
    C(3,2,:)=-2*A(2,1,:).*A(2,2,:);
    C(3,3,:)=A(2,2,:).^2;
end

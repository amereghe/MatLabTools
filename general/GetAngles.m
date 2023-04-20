function thetas=GetAngles(Rm,lCos,lDegs)
% input:
% - Rm: rotation matrix (3x3x nSets) or array of normal vectors (nSets x3);
% - lCos (boolean): if true, Rm is a collection of plane normals;
%                   if false (default), Rm is a rotation matrix;
% - lDegs (boolean): if true (default), convert angles in degrees;
%
%      Rm = Rz(a) Ry(b) Rx(g)
%      Rx(g) = [
%                1   0   0
%                0   Cg -Sg
%                0   Sg  Cg
%              ]
%      Ry(b) = [
%                Cg  0   Sg
%                0   1   0
%               -Sg  0   Cg
%              ]
%      Rz(a) = [
%                Ca -Sa 0
%                Sa  Ca 0
%                0   0  1
%              ]
%      Rm(a,b,g)= [
%                CaCb   CaSbSg-SaCg    CaSbCg+SaSg
%                SaCb   SaSbSg+CaCg    SaSbCg-CaSg
%                -Sb         CbSg           CbCg
%              ] 
%      https://en.wikipedia.org/wiki/Rotation_matrix
%      alpha=atan2(Rm(2,1),Rm(1,1)); [-pi  :pi]
%      beta=-asin(Rm(3,1));          [-pi/2:pi/2]
%      gamma=atan2(Rm(3,2),Rm(3,3)); [-pi  :pi]
%       
    if (~exist("lCos","var")), lCos=false; end
    if (~exist("lDegs","var")), lDegs=true; end
    nRows=size(Rm,1);
    nCols=size(Rm,2);
    if (lCos)
        nDims=nCols;
        nSets=size(Rm,1);
    else
        if (nRows~=nCols), error("Number of rows/columns are not equal: %d/%d!",nRows,nCols); end
        nDims=nCols;
        nSets=size(Rm,3);
    end
    if (nDims~=3), error("For the time being, only 3D stuff!"); end
    thetas=NaN(nSets,nDims);
    if (lCos)
        for ii=1:nSets
            thetas(ii,:)=acos(Rm(ii,:)); % [-pi  :pi]
        end
    else
        for ii=1:nSets
            thetas(ii,1)=atan2(Rm(2,1),Rm(1,1)); % alpha [-pi  :pi]
            thetas(ii,2)=-asin(Rm(3,1));         % beta [-pi/2:pi/2]
            thetas(ii,3)=atan2(Rm(3,2),Rm(3,3)); % gamma [-pi  :pi]
        end
    end
    if (lDegs), thetas=rad2deg(thetas); end
end

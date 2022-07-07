function NewMatrix=PaddMe(NewArray,OldMatrix,PadVal)
% for the time being, only 2D matrices
    if ( ~exist("PadVal","var") ), PadVal=NaN(); end
    if ( ~exist("OldMatrix","var") | ismissing(OldMatrix) )
        % return array/matrix to be given back
        NewMatrix=NewArray;
    else
        NewMatrix=OldMatrix;
        nColsNew=size(NewArray,2); nRowsNew=size(NewArray,1);
        nColsExist=size(NewMatrix,2); nRowsExist=size(NewMatrix,1);
        if ( nRowsExist<nRowsNew )
            % fill in existing columns with PadVals instead of 0.0
            NewMatrix(nRowsExist+1:nRowsNew,:)=PadVal;
        end
        NewMatrix(1:nRowsNew,nColsExist+1:nColsExist+nColsNew)=NewArray;
        if ( nRowsExist>nRowsNew )
            % fill in added columns with PadVals instead of 0.0
            NewMatrix(nRowsNew+1:nRowsExist,:)=PadVal;
        end
    end
end

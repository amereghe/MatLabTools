function RR=GetTransMatrix(rMatrix,plane,myFormat,eleNames)
% GetTransMatrix        Return the 3x3 transport matrix out of MADX
%                         printouts (this function simply changes the format
%                         of information already present in rMatrix.
% 
% input:
% - rMatrix: table where to find MADX data. Two formats are possible, based
%   on myFormat:
%   . 'TFS': we have a twiss-like table, i.e. one optics and values of the
%            transport matrix element along the beam line;
%   . 'SCAN': we have a scan table, i.e. a table where the matrix element
%            are specified at only one lattice entry for different optics;
% - plane (optional): 'H/HOR' (default) or 'V/VER';
% - myFormat (optional): 'TFS' or 'SCAN' (default). See rMatrix;
% - eleNames (optional): list of element names at which the matrix should
%   be returned. Used only in case of 'TFS' format (obviously);
%
% output:
% - RR: 3x3xNdata transport matrix. RR is given for all the lines contained
%       in rMatrix, unless for the 'TFS' format, for which a subset of element
%       names can be selected;
% 

    %% which plane
    if ( ~exist('plane','var') )
        plane="H";
    end
    %% which format
    if ( ~exist('myFormat','var') )
        myFormat="SCAN";
    end
    
    %% dimension of output matrix
    switch upper(myFormat)
        case {"TFS"}
            [ colNames, colUnits, colFacts, mapping, readFormat ] = ...
                                  GetColumnsAndMappingTFS('rmatrix');
            NAMEs=strip(rMatrix{mapping(strcmp(colNames,'NAME'))},'"');
            if ( exist('eleNames','var') )
                useNData=length(eleNames);
                [~,iis,~]=intersect(NAMEs,eleNames);
            else
                useNData=length(NAMEs);
                iis=1:useNData;
            end
        case {"SCAN"}
            colNames=[ "Brho" "BP" "I" "RE11" "RE12" "RE21" "RE22" "RE16" "RE26" "RE33" "RE34" "RE43" "RE44" "RE36" "RE46" "RE51" "RE52" "RE55" "RE56" "RE66" ];
            useNData=size(rMatrix,1);
            iis=1:useNData;
            
        otherwise
            error("Unknown format: %s. Can only be TFS or SCAN.",myFormat);
    end
    RR=zeros(3,3,useNData);
    
    %% actually do the job
    switch upper(plane)
        case {"H","HOR"}
            readRows=1:2;
            readCols=[1 2 6];
        case {"V","VER"}
            readRows=3:4;
            readCols=[3 4 6];
        otherwise
            error("Wrong indication of plane: %s. Can be only H(OR) or V(ER)",plane);
    end
    for iRow=1:length(readRows)
        for iCol=1:length(readCols)
            colName=sprintf("RE%1d%1d",readRows(iRow),readCols(iCol));
            switch upper(myFormat)
                case {"TFS"}
                    temp=rMatrix{mapping(strcmp(colNames,colName))};
                case {"SCAN"}
                    temp=rMatrix(:,strcmp(colNames,colName));
            end
            RR(iRow,iCol,:)=temp(iis);
        end
    end
    RR(3,3,:)=1;
end

function resizedData=ResizePIBData(measData)
% ResizePIBData    risezes PIB data, which are just one per acquition, contrary
%                  to GIM, QBM and SFM, which have multiple distributions for a
%                  single spill
%
% input:
% - measData [float(max(Nx,Ny),maxColumns,2,nDataSets)]: array of data;
%   . Nx,Ny: number of hor/ver fibers;
%   . maxColumns: number of time acquisitions + values of X (first column);
%     this is in general 2;
%   . 2: planes: 1: hor; 2: ver;
%   . nDataSets: number of files;
%
% output:
% - resizedData [float(max(Nx,Ny),nDataSets+1,2)]: array of data;
%   . Nx,Ny: number of hor/ver fibers;
%   . nDataSets+1: number of acquisitions (original data sets) + values
%                  of X (first column);
%   . 2: planes: 1: hor; 2: ver;
%
% see also ParseSFMData
    resizedData=zeros(size(measData,1),size(measData,4)+1,size(measData,3));
    for ii=1:size(measData,4)
        if ( ii==1 ) resizedData(:,1,:)=measData(:,1,:,ii); end % fiber central values
        resizedData(:,ii+1,:)=measData(:,2,:,ii);
    end
end

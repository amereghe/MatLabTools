function sumData=SumSpectra(data,times)
% SumSpectra     computes either the distribution sum of those recorded by SFM, QBM and GIM,
%                   or the evolution of the integral (times var provided or ~=missing());
%
% input:
% - data [float(max(Nx,Ny),maxColumns,2,nDataSets)]: array of data. See ParseSFMData
%   for further info on formats;
% - times [float(maxColumns-1,nDataSets)] (optional): time stamps of frames;
%   if this var is provided, the evolution of the integral is computed instead
%      of the distribution sum;
% 
% output:
% - sumData: array of data; its actual dimensions depend on the sum requested,
%   i.e. if times is provided or not:
%     times not provided or ==missing() (distribution sum, default):
%           [float(Nn,nDataSets+1,2)]
%     times provided and ~=missing() (evolution with time of integral):
%           [float(Ntimes,nDataSets+1,2)]: 
%   where:
%   . Nn: number of fibers;
%   . nDataSets: number of files;
%   . Ntimes: number of time stamps;
%   . 2: planes: 1: hor; 2: ver;
%
%   Please keep in mind that the second dimension of the array lists in the 
%     first column either the x/y central positions of the fibers/channels
%     (distribution sum, default) or the time stamps of frames;
%
% see also ParseSFMData and IntegrateSpectra.

    if (~exist("times","var")), times=missing(); end
    Nn=size(data,1);
    nDataSets=size(data,4);
    
    fprintf("computing sums...\n");
    if (size(times,1)==1 && size(times,2)==1)
        sumData=zeros(Nn,nDataSets+1,2);
        sumData(:,1,:)=data(:,1,:,1); % copy positions of fibers on both planes from first data set
        for iSet=1:nDataSets
            % get total distribution for each data set
            sumData(:,iSet+1,:)=sum(data(:,2:end,:,iSet),2,'omitnan');
        end
    else
        if (nDataSets~=size(times,2))
            error("Inconsistent number of DataSets: %d (profiles) vs %d (timestamps)",...
                nDataSets,size(times,2));
        end
        nTimes=size(times,1);
        sumData=zeros(nTimes,nDataSets+1,2);
        % copy positions of fibers on both planes from first data set
        sumData(:,1,1)=times(:,1); % hor plane
        sumData(:,1,2)=times(:,1); % ver plane
        for iSet=1:nDataSets
            % get integral for each time frame
            sumData(:,iSet+1,:)=sum(data(:,2:end,:,iSet),1,'omitnan');
        end
    end
end

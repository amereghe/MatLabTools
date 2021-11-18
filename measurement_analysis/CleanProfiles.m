function [indices]=CleanProfiles(yIN,noiseLevel)
% CleanProfiles      to identify a bell-shaped profile in the data
% 
% The function implements the algorithm set up by L.Falbo on CAMeretta:
% - clean the distribution of the pedestal (noise level);
% - get the maximum in the distribution, and keep all the points around it
%   until a given cutting level is reached;
%
% input:
% - yIN (2D float array): signals to process:
%   . rows: index of independent coordinate (e.g. time/position);
%   . columns: index of the signal to process;
%   NB: column 1 is NOT the list of values of the independent variable;
% - noiseLevel (scalar): cut threshold (either as percentage or as ratio to 1);
%   default: 5%;
%
% output:
% - indices (2D boolean): indices of the signal points to be kept;
%
    if ( ~exist('noiseLevel','var') ), noiseLevel=0.05; end % default cutting level wrt max
    if ( noiseLevel>1 ), noiseLevel=noiseLevel*1.0E-2; end  % if cutting level >1, it is assumed in percentage
    indices=false(size(yIN));
    [maxs,ids]=max(yIN);
    for ii=1:size(yIN,2)
        cutLevel=maxs(ii)*noiseLevel;
        myDiff=diff([0 yIN(:,ii)' 0]>=cutLevel);
        indStart = find(myDiff==1);
        indStop = find(myDiff==-1)-1;
        for jj=1:numel(indStart) % loop through each block
            if ( indStart(jj)<=ids(ii) & ids(ii)<=indStop(jj) )
                indices(indStart(jj):indStop(jj),ii)=true;
                break
            end
        end
    end
end
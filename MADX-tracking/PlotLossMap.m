function [hh,cc] = PlotLossMap(losses,indices,dS,maxS,minS,Nbins)
% PlotLossMap     plot the longitudinal distribution of losses (histogram)
%
% Nota bene: the function does not create a figure or a subplot, they
% should be created beforehand;
%
% [hh,cc] = PlotLossMap(losses,indices,dS,maxS,minS,Nbins)
%
% input arguments:
%   losses: table of losses. For the format of the table, please see
%                 GetVariablesAndMappingParticleData
%   indices: index of particles to be plotted (eg to apply some filtering);
%
% optional input arguments:
%   dS:   bin width [m];
%   maxS: max value of s-coordinate [m];
%   minS: min value of s-coordinate [m];
%   Nbins: number of bins;
%
% output arguments:
%   hh:  histogram counts;
%   cc:  histogram edges;
%
% See also ReadLosses, ShowLossMap, GetVariablesAndMappingParticleData.

    dsUsr=0.1; % [m]
    if ( exist('dS','var') )
        dsUsr=dS;
    end
    maxSUsr=max(losses{9});
    if ( exist('maxS','var') )
        maxSUsr=maxS;
    end
    minSUsr=min(losses{9});
    if ( exist('minS','var') )
        minSUsr=minS;
    end
    if ( exist('Nbins','var') )
        dsUsr=(maxSUsr-minSUsr)/Nbins;
    end
    
    % column mapping
    [ colNames, colUnits, colFacts, mapping ] = ...
                             GetVariablesAndMappingParticleData('losses');
    colS=mapping(find(strcmp(colNames,'s')));
    
    % compute histogram
    edges=[minSUsr:dsUsr:maxSUsr];
    if (ismissing(indices))
        [hh,cc] = histcounts(losses{colS},edges);
    else
        [hh,cc] = histcounts(losses{colS}(indices),edges);
    end
    edges = cc(2:end) - 0.5*(cc(2)-cc(1));
    
    % plot histogram
    bar(edges,hh/sum(hh)/dsUsr,1);
    
    % additionals
    xlabel('s [m]');
    ylabel('pdf [m^{-1}]');
    xlim([minSUsr maxSUsr]);
    ylim([0.5/(dsUsr*sum(hh)) 2*max(hh)/(sum(hh)*dsUsr)]);
    grid on;
    
end
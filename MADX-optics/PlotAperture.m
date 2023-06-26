function PlotAperture(aper,aperOff,aperS,apeMin,apeMax)
% PlotAperture    plot aperture profile
%
% PlotAperture(aper,aperOff,aperS,apeMax,apeMin)
%
% input arguments:
%   aper:    aperture on a specific plane [m] (array of values);
%   aperOff: aperture offset on a specific plane [m] (array of values);
%   aperS:   s-positions of apertures [m] (array of values);
%
% optional input arguments:
%   apeMin: min value of aperture plot [m];
%   apeMax: min value of aperture plot [m];
% 
% See also GetAperture.

    % plot aperture
    plot(aperS,(aper+aperOff),'k-',aperS,(-aper+aperOff),'k-');
    hold on;
    
    % plot grey areas
    if ( ~exist('apeMax','var') ), apeMax=max( aper+aperOff)*1.1; end
    if ( ~exist('apeMin','var') ), apeMin=min(-aper+aperOff)*1.1; end
    patch([aperS fliplr(aperS)], [( aper+aperOff) apeMax*ones(size(aper))],'r', 'FaceColor','#DCDCDC');
    patch([aperS fliplr(aperS)], [(-aper+aperOff) apeMin*ones(size(aper))],'r', 'FaceColor','#DCDCDC');

    % additionals
    ylim([apeMin apeMax]);

end

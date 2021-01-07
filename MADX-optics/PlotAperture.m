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
    plot(aperS,(aper+aperOff)*1E3,'k-',aperS,(-aper+aperOff)*1E3,'k-');
    hold on;
    
    % plot grey areas
    apeMaxUsr=max(ylim);
    if ( exist('apeMax','var') )
        apeMaxUsr=apeMax;
    end
    apeMinUsr=min(ylim);
    if ( exist('apeMin','var') )
        apeMinUsr=apeMin;
    end
    patch([aperS fliplr(aperS)], [( aper+aperOff) apeMaxUsr*ones(size(aper))]*1E3,'r', 'FaceColor','#DCDCDC');
    patch([aperS fliplr(aperS)], [(-aper+aperOff) apeMinUsr*ones(size(aper))]*1E3,'r', 'FaceColor','#DCDCDC');

    % additionals
    ylim([apeMinUsr apeMaxUsr]*1E3);
    ylabel('[mm]');
    grid on;

end
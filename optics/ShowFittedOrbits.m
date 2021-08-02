function ShowFittedOrbits(z,zp,D,Dp,plane,avedpp,labels)
% showFittedOrbits              show the results of the reconstructed
%                                  orbits based on the fit vs D/Dp
%                                  (scan version)
%
% input:
% - z [m], zp []: orbits as reconstructed from fits;
% - D [m], Dp []: dispersion and dispersion prime used to perform the scans;
% - plane: current plane being plotted;
% - avedpp []: average delta_p_over_p;
% - labels (optional): string of labels, identifying different fit cases;
%   if not given, the passed optics functions are assumed to be reconstructed
%                 by a fit parameteric in avedpp; hence, z and zp are
%                 arrays as long as D and Dp;
%
%
% See also ShowFittedOpticsFunctions.

    figure();
    if ( size(z,2)>1 )
        % more data sets
        legends=strings(size(z,2),1);
        if ( exist('labels','var') )
            for ii=1:size(z,2), legends(ii)=sprintf("%s - \\delta_{ave}=%g",labels(ii),avedpp(ii)); end
        else
            for ii=1:size(z,2), legends(ii)=sprintf("\\delta_{ave}=%g",avedpp(ii)); end
        end
    end
    %
    ax1=subplot(1,2,1);
    if ( exist('labels','var') && size(z,2)==1 )
        plot(1:length(labels),z,'*-');
        xticks(1:length(labels)); xticklabels(labels); xtickangle(45); 
    else
        plot(D,z,'*-');
        xlabel("D [m]");
    end
    title("z_0"); ylabel("[m]");
    grid on;
    if ( size(z,2)>1 ), legend(legends,'Location','best'); end
    %
    ax2=subplot(1,2,2);
    if ( exist('labels','var') && size(z,2)==1 )
        plot(1:length(labels),z,'*-');
        xticks(1:length(labels)); xticklabels(labels); xtickangle(45); 
    else
        plot(Dp,zp,'*-');
        xlabel("D' []");
    end
    title("z'_0"); ylabel("[]");
    grid on;
    %
    % linkaxes([ax1 ax2],"x");
    if ( size(z,2)>1 ), legend(legends,'Location','best'); end
    if ( size(z,2)==1 )
        sgtitle(sprintf("%s plane - \\delta_{ave}=%g",plane,avedpp)); % only one set of data
    else
        sgtitle(sprintf("%s plane",plane)); % only one set of data
    end    
end

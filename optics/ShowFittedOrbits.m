function ShowFittedOrbits(z,zp,D,Dp,plane,avedpp)
% showFittedOrbits              show the results of the reconstructed
%                                  orbits based on the fit vs D/Dp
%                                  (scan version)
%
% input:
% - z [m], zp []: orbits as reconstructed from fits;
% - D [m], Dp []: dispersion and dispersion prime used to perform the scans;
% - avedpp []: average delta_p_over_p;
% - plane: current plane being plotted;
% Nota Bene: z, zp are arrays as long as D and Dp;
%
%
% See also ShowFittedOpticsFunctions.

    figure();
    %
    ax1=subplot(1,2,1);
    plot(D,z,'*-');
    title("z_0"); ylabel("[m]"); xlabel("D [m]");
    grid on;
    %
    ax2=subplot(1,2,2);
    plot(Dp,zp,'*-');
    title("z'_0"); ylabel("[]"); xlabel("D' []");
    grid on;
    %
    % linkaxes([ax1 ax2],"x");
    sgtitle(sprintf("%s plane - \delta_{ave}=%g",plane,avedpp));
    
end

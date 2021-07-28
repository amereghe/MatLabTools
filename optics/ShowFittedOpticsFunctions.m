function ShowFittedOpticsFunctions(beta,alpha,emiG,disp,dispP,sigdpp,plane)
% ShowFittedOpticsFunctions        show the results of the reconstructed
%                                  optics functions based on the fit vs sigdpp 
%                                  (scan version)
%
% input:
% - beta [m], alpha [], emiG [pi m rad]: optics functions and geometric
%              emittance as reconstructed from fits;
% - disp [m], dispP [], sigdpp []: dispersion, dispersion prime and sigma_delta_p_over_p
%              as reconstructed from fits;
% - plane: current plane being plotted;
% Nota Bene: beta, alpha, emiG, disp, dispP are arrays as long as sigdpp;
%
% the generated figure has 2 rows:
% - on the first one, there are the betatron optics and emittance;
% - on the second one, the dispersion ones;
%
% See also ShowFittedOrbits.

    %% setting up
    figure();
    
    %% first row of plots: beta, alpha and emittance 
    ax1=subplot(2,3,1);
    plot(sigdpp,beta,'*-');
    title("\beta"); ylabel("[m]"); xlabel("\sigma_{\Deltap/p} []");
    grid on;
    %
    ax2=subplot(2,3,2);
    plot(sigdpp,alpha,'*-');
    title("\alpha"); ylabel("[]"); xlabel("\sigma_{\Deltap/p} []");
    grid on;
    % 
    ax3=subplot(2,3,3);
    plot(sigdpp,emiG*1E6,'*-');
    title("\epsilon"); ylabel("[\mum]"); xlabel("\sigma_{\Deltap/p} []");
    grid on;

    %% second row of plots: d and dp
    ax4=subplot(2,3,4);
    plot(sigdpp,disp,'*-');
    title("D"); ylabel("[m]"); xlabel("\sigma_{\Deltap/p} []");
    grid on;
    %
    ax5=subplot(2,3,5);
    plot(sigdpp,dispP,'*-');
    title("D'"); ylabel("[]"); xlabel("\sigma_{\Deltap/p} []");
    grid on;
    
    %% general
    linkaxes([ax1 ax2 ax3 ax4 ax5],"x");
    sgtitle(sprintf("%s plane",plane));
end

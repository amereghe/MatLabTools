function ShowFittedOpticsFunctions(beta,alpha,emiG,disp,dispP,sigdpp,planeLab,labels)
% ShowFittedOpticsFunctions        show the results of the reconstructed
%                                  optics functions based on a 6D fit
%
% input:
% - beta [m], alpha [], emiG [pi m rad]: optics functions and geometric
%              emittance as reconstructed from fits;
% - disp [m], dispP [], sigdpp []: dispersion, dispersion prime and sigma_delta_p_over_p
%              as reconstructed from fits;
% - planeLab: current plane being plotted;
% - labels (optional): string of labels, identifying different fit cases;
%   if not given, the passed optics functions are assumed to be reconstructed
%                 by a fit parameteric in sigdpp; hence, beta, alpha, emiG,
%                 disp, dispP are arrays as long as sigdpp;
%
% the generated figure has 2 rows:
% - on the first one, there are the betatron optics functions and emittance;
% - on the second one, the dispersion ones;
%
% more info at:
%      https://accelconf.web.cern.ch/d99/papers/PT10.pdf
%
% See also ShowFittedOrbits.
    
    %% setting up
    figure();
    if ( exist('labels','var') && size(beta,2)==1 )
        xVals=1:length(labels);
        myXlabel="";
    else
        xVals=sigdpp;
        myXlabel="\sigma_{\Deltap/p} []";
    end
    
    nSeries=size(beta,2);
    cm=colormap(parula(nSeries));
    xMin=min(xVals); xMax=max(xVals); dx=xMax-xMin;
    xlims=[ xMin-0.05*dx xMax+0.05*dx];
    
    %% first row of plots: beta, alpha and emittance 
    ax1=subplot(2,3,1);
    for ii=1:nSeries
        if (ii>1), hold on; end
        plot(xVals,beta(:,ii),'*-',"color",cm(ii,:));
    end
    title("\beta"); ylabel("[m]"); xlabel(myXlabel);
    grid on; xlim(xlims);
    if ( exist('labels','var') )
        if ( size(beta,2)==1 )
            xticks(1:length(labels));
            xticklabels(labels);
            xtickangle(45);
        else
            legend(labels,'Location','best');
        end
    end
    %
    ax2=subplot(2,3,2);
    for ii=1:nSeries
        if (ii>1), hold on; end
        plot(xVals,alpha(:,ii),'*-',"color",cm(ii,:));
    end
    title("\alpha"); ylabel("[]"); xlabel(myXlabel);
    grid on; xlim(xlims);
    if ( exist('labels','var') )
        if ( size(beta,2)==1 )
            xticks(1:length(labels));
            xticklabels(labels);
            xtickangle(45);
        else
            legend(labels,'Location','best');
        end
    end
    % 
    ax3=subplot(2,3,3);
    for ii=1:nSeries
        if (ii>1), hold on; end
        plot(xVals,emiG(:,ii)*1E6,'*-',"color",cm(ii,:));
    end
    title("\epsilon"); ylabel("[\mum]"); xlabel(myXlabel);
    grid on; xlim(xlims);
    if ( exist('labels','var') )
        if ( size(beta,2)==1 )
            xticks(1:length(labels));
            xticklabels(labels);
            xtickangle(45);
        else
            legend(labels,'Location','best');
        end
    end

    %% second row of plots: d and dp
    ax4=subplot(2,3,4);
    for ii=1:nSeries
        if (ii>1), hold on; end
        plot(xVals,disp(:,ii),'*-',"color",cm(ii,:));
    end
    title("D"); ylabel("[m]"); xlabel(myXlabel);
    grid on; xlim(xlims);
    if ( exist('labels','var') )
        if ( size(beta,2)==1 )
            xticks(1:length(labels));
            xticklabels(labels);
            xtickangle(45);
        else
            legend(labels,'Location','best');
        end
    end
    %
    ax5=subplot(2,3,5);
    for ii=1:nSeries
        if (ii>1), hold on; end
        plot(xVals,dispP(:,ii),'*-',"color",cm(ii,:));
    end
    title("D'"); ylabel("[]"); xlabel(myXlabel);
    grid on; xlim(xlims);
    if ( exist('labels','var') )
        if ( size(beta,2)==1 )
            xticks(1:length(labels));
            xticklabels(labels);
            xtickangle(45);
        else
            legend(labels,'Location','best');
        end
    end
    %
    if ( exist('labels','var') && size(beta,2)==1 )
        ax6=subplot(2,3,6);
        for ii=1:nSeries
            if (ii>1), hold on; end
            plot(xVals,sigdpp(:,ii),'*-',"color",cm(ii,:));
        end
        title("\sigma_{\Deltap/p}"); ylabel("[]"); xlabel(myXlabel);
        grid on; xlim(xlims);
        xticks(1:length(labels)); xticklabels(labels); xtickangle(45); 
    end

    %% general
    if ( exist('labels','var') && size(beta,2)==1 )
        linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],"x");
    else
        linkaxes([ax1 ax2 ax3 ax4 ax5],"x");
    end
    sgtitle(sprintf("%s plane",planeLab));
end

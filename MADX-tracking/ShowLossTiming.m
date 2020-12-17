function [lossHist,cc]=ShowLossTiming(data,indeces,Nturns,turnCol,injPattern,currTitle)
% ShowLossTiming  Show timing of losses
%
% Two plots are shown:
%   top: total beam intensity vs turn number, normalised to single
%   injection;
%   bottom: losses happening in a single turn
%
% [lossHist,cc]=ShowLossTiming(data,indeces,Nturns,turnCol,injPattern,currTitle)
%
% input arguments:
%   data: table with particle coordinates;
%   indeces: index of particles to be plotted (eg to apply some filtering);
%   Nturns: total number of turns;
%   turnCol: index of column where the turn number is recorded;
%   injPattern: injection pattern;
%   currTitle: title of the plot;
%

    % some normalisation factors
    nTotAllInjected=sum(injPattern);
    nTotSingleInjection=max(injPattern);
    
    % compute histogram
    [lossHist,cc]=histcounts(data{turnCol}(indeces),0:Nturns+1);
    % edges = cc(2:end) - 0.5*(cc(2)-cc(1));
    edges = cc(1:end-1);

    ff=figure('Name','Loss timing','NumberTitle','off');
    ax1=subplot(2,1,1);
    % intensity shows also injections
    plot(edges,(cumsum(injPattern)-cumsum(lossHist))/nTotSingleInjection*100,'*-');
    hold on;
    % intensity shows only losses
    plot(edges,(cumsum(injPattern)-injPattern-cumsum(lossHist))/nTotSingleInjection*100,'*-');
    grid on;
    xlabel('turn');
    ylabel(sprintf("total beam intensity\n[%% wrt single injection]"));
    xlim([0 Nturns+1]);
    set(ax1, 'YScale', 'log');
    legend('Show Injection','Only losses','Location','best');
    
    % losses per turn
    ax2=subplot(2,1,2);
    bar(edges,lossHist/nTotSingleInjection*100);
    grid on;
    xlabel('turn');
    ylabel(sprintf("losses per turn\n[%% wrt single injection]"));
    xlim([0 Nturns+1]);
    set(ax2, 'YScale', 'log');

    % title of figure
    sgtitle(sprintf('%s - %s','Loss timing (end of turn)',currTitle));
end
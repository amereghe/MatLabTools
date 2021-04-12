% {}~

PT=-0.02:0.0001:0.02;
DPP=-0.02:0.0001:0.02;

% get relativistic beta of reference particle
mm=938.27208816; % [MeV]
Ek=7; % [MeV]
gamma=Ek/mm+1;
betagamma=sqrt(gamma^2-1);
beta=betagamma/gamma;

f1=figure('Name','show PT','NumberTitle','off');

% PT vs dpp
ax1=subplot(1,2,1);
fun_pt=@(x) beta*x./(1+x);
plot(DPP*1000,fun_pt(DPP)*1000);
xlabel('DPP [10^{-3}]');
ylabel('PT [10^{-3}]');
grid on;

% PT vs dpp
ax2=subplot(1,2,2);
fun_dpp=@(x) x./(beta-x);
plot(PT*1000,fun_dpp(PT)*1000);
xlabel('PT [10^{-3}]');
ylabel('DPP [10^{-3}]');
grid on;


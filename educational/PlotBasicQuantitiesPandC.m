% {}
% to-do:
% - allow to plot any quantity as a function of any other one

% load particle data
run(".\particleData.m");

% proton data
EkMin_p=7; % [MeV]
EkMax_p=250; % [MeV]
EkStep_p=1; % [MeV]
Ek_p=EkMin_p:EkStep_p:EkMax_p; % [MeV]
range_p=@(x) 2.03E-02*x.^1.79; % range [mm], x [MeV], from fit of PSTAR data over [7MeV:300MeV], https://physics.nist.gov/cgi-bin/Star/ap_table.pl

% carbon data
EkMin_C=7; % [MeV/A]
EkMax_C=440; % [MeV/A]
EkStep_C=1; % [MeV/A]
Ek_C=EkMin_C:EkStep_C:EkMax_C; % [MeV/A]
range_C=@(x) 7.66E-03*x.^1.76; % range [mm], x [MeV/A], from fit to data from ICRU73 (errata), https://www.researchgate.net/publication/255700394_P_Sigmund_A_Schinner_H_Paul_Errata_and_addenda_for_ICRU_Report_73_Stopping_of_Ions_Heavier_than_Helium_J_of_the_ICRU_2009?enrichid=rgreq-cddd1932f703ba84581b29d24d4be41b-xxx&enrichsource=y292zxjqywdlozi1ntcwmdm5ndtbuzo0ntcymtc3nzk0nzq0mzjamtq4njaymdyymtuxnq%3D%3D

% scan data
independent='range'; % Ek or range
cLight=299792458E0; % [m/s]
circumference=77.640; % [m]

% relativistic quantities
[beta_p,gamma_p,betagamma_p]=ComputeRelativisticQuantities(Ek_p,mp);
[beta_C,gamma_C,betagamma_C]=ComputeRelativisticQuantities(Ek_C*AC,mC);

% plots
% - independent variable
if strcmp(independent,'Ek')
    label_x_axis='E_k [MeV/A]';
    xPlot_p=Ek_p;
    xPlot_C=Ek_C;
else
    label_x_axis='Range [mm]';
    xPlot_p=range_p(Ek_p);
    xPlot_C=range_C(Ek_C);
end
% plot(xPlot,range(Ek));
% xlabel(label_x_axis);
% ylabel('Range [mm]');
% grid on;
% return;
% - actually plot
% - relativistic gamma
ax1=subplot(3,3,1);
plot(xPlot_C,gamma_C,xPlot_p,gamma_p);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('\gamma_{rel} []');
grid on;
% - relativistic betagamma
ax2=subplot(3,3,2);
plot(xPlot_C,betagamma_C,xPlot_p,betagamma_p);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('\beta\gamma_{rel} []');
grid on;
% - relativistic beta
ax3=subplot(3,3,3);
plot(xPlot_C,beta_C,xPlot_p,beta_p);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('\beta_{rel} []');
grid on;
% - momentum
ax5=subplot(3,3,5);
plot(xPlot_C,betagamma_C*mC/AC,xPlot_p,betagamma_p*mp);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('pc [MeV/c/A]');
grid on;
% - magnetic rigidity
ax8=subplot(3,3,8);
plot(xPlot_C,betagamma_C*mC/(cLight*1E-6*ZC),xPlot_p,betagamma_p*mp/(cLight*1E-6*Zp));
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('B\rho [Tm]');
grid on;
% - speed
ax6=subplot(3,3,6);
plot(xPlot_C,beta_C*cLight,xPlot_p,beta_p*cLight);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('v [m/s]');
grid on;
% - revolution time
ax9=subplot(3,3,9);
plot(xPlot_C,circumference./(beta_C.*cLight)*1E6,xPlot_p,circumference./(beta_p.*cLight)*1E6);
legend('Carbon','proton','location','best');
xlabel(label_x_axis);
ylabel('T_{rev} [\mus]');
grid on;
% - range
ax7=subplot(3,3,7);
if strcmp(independent,'Ek')
    plot(xPlot_C,range_C(Ek_C),xPlot_p,range_p(Ek_p));
    legend('Carbon','proton','location','best');
    ylabel('Range [mm]');
else
    plot(xPlot_C,Ek_C,xPlot_p,Ek_p);
    legend('Carbon','proton','location','best');
    ylabel('Ek [MeV]');
end
xlabel(label_x_axis);
grid on;
linkaxes([ax1,ax2,ax3,ax5,ax6,ax7,ax8,ax9],'x');
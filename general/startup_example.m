%Startup file - MatLab automatically runs the file named "startup.m" if it
%is saved in a know folder in the path 

fprintf('Executed startup file at C:/Users/enrico.felcini/Documents/MATLAB \n')

%% Define figure properties
fprintf('Setting Figures Properties \n');

set(0,'defaultFigureColor','w')
set(0,'defaultAxesFontWeight', 'bold')
set(0,'defaultAxesFontSize', 16)
set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'DefaultAxesBox','on')

%% Load path
fprintf('Loading Path \n');
run('C:\Users\enrico.felcini\Desktop\MATLAB_Development\pathdef.m');

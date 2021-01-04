% {}~
energy=30;
magnet="H21";
path2Files=sprintf("S:\\Accelerating-System\\Accelerator-data\\Area dati MD\\00RFKO\\Carbonio\\StudioFuochi\\Sala3Ottica2\\Steering4\\nuovorangeScanH21-H22\\2020-11-29\\%imm\\%s\\PRC-544-*\\Profiles\\*.csv",energy,magnet);
files=dir(path2Files);
% csvFileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00RFKO\Carbonio\StudioFuochi\Sala3Ottica2\Steering4\nuovorangeScanH21-H22\2020-11-29\270mm\H22\PRC-544-201130-0003\Profiles\Data-7E0030440900-179925879-T2-030C-DDSF.csv";
% measData(:,:,1)=table2array(readtable(csvFileName,'HeaderLines',1,'MultipleDelimsAsOne',true));
% csvFileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00RFKO\Carbonio\StudioFuochi\Sala3Ottica2\Steering4\nuovorangeScanH21-H22\2020-11-29\270mm\H22\PRC-544-201130-0003\Profiles\Data-7E0030440900-179925936-T2-030C-DDSF";
% measData(:,:,2)=table2array(readtable(csvFileName,'HeaderLines',1,'MultipleDelimsAsOne',true));%
% nDataSets=size(measData,3);
nDataSets=length(files);
measData=[];
fprintf("acquring data...\n");
for iSet=1:nDataSets
    measData(:,:,iSet)=table2array(readtable(sprintf("%s\\%s",files(iSet).folder,files(iSet).name),'HeaderLines',1,'MultipleDelimsAsOne',true));
end

fprintf("plotting data...\n");
tmpTitleFig=sprintf("%i mm - %s",energy,magnet);
ff=figure('Name',tmpTitleFig,'NumberTitle','off');
% hor distribution
subplot(1,2,1);
cm=colormap(parula(nDataSets));
for iSet=1:nDataSets
    showSpectrum(measData(:,1,iSet),measData(:,2,iSet),iSet,cm(iSet,:));
    hold on;
end
title("horizontal plane");
grid on;
xlabel("position [mm]");
ylabel("ID");
zlabel("Counts []");
% ver distribution
subplot(1,2,2);
for iSet=1:nDataSets
    showSpectrum(measData(:,3,iSet),measData(:,4,iSet),iSet,cm(iSet,:));
    hold on;
end
title("vertical plane");
grid on;
xlabel("position [mm]");
ylabel("ID");
zlabel("Counts []");
sgtitle(tmpTitleFig);
        
function showSpectrum(xx,yy,cc,color)
    nn=length(xx);
    zz=cc*ones(nn,1);
    fill3([xx fliplr(xx)],[zz zz],[yy zeros(nn,1)],color,'FaceAlpha',0.3);
    hold on;
    plot3(xx,zz,yy,'Color',color);
end
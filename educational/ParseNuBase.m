%% function to create a DB of properties of nuclides
% source: https://www-nds.iaea.org/amdc/
% path to txt file: https://www-nds.iaea.org/amdc/ame2020/nubase_4.mas20.txt

% name of ASCII file to parse
DBfileName="nubase_4.mas20.txt";

% columns
NumVariables = 18;
VariableNames  = {'A','Z','Name','s','MassExcess','dMass','Exc','dE',...
    'Orig','Isom.Unc','Isom.Inc','T','Tunit','dT','Jpi','Ensdf_year',...
    'Discovery','BR'};
VariableWidths = [ 4,7,5,2,13,11,12,11,2,1,1,9,3,7,14,12,5,90] ;                                                  
DataType       = {'double','double','string','string','double','double',...
                  'string','string','string','string','string','string',...
                  'string','string','string','string','string','string'};

% define parser
opts = fixedWidthImportOptions('NumVariables',NumVariables,...
                               'VariableNames',VariableNames,...
                               'VariableWidths',VariableWidths,...
                               'VariableTypes',DataType,...
                               "CommentStyle","#");

%% parse ASCII file
T = readtable(DBfileName,opts);
% remove numerical indication of isomer state from Z
T.Z=floor(T.Z/10);

%% save to .mat table
save(strrep(DBfileName,".txt",".mat"),"T");

%% main function

function [cyCodes,ranges,Eks,Brhos,currents,fields,kicks,psNames,FileNameCurrents]=AcquireLGENValues(beamPartIn,machineIn,configIn,filters,LGENsCheck)

    fprintf("Getting current values...\n");
    
    % filter PSs where all CyCo show "NaN" or "0"
    if ( ~exist('filters','var') ), filters=["NaN" "0"]; end
    if ( exist('LGENsCheck','var') )
        doVisualCheck=true;
    else
        doVisualCheck=false;
        LGENsCheck=missing;
    end

    % processing
    beamPart=upper(beamPartIn);
    machine=upper(machineIn);
    config=upper(configIn);

    % preliminary checks
    if ( ~strcmp(config,"TM") & ~strcmp(config,"RFKO") )
        error("unrecognised config: %s - available only TM and RFKO!",config);
    end
    if ( ~strcmp(beamPart,"PROTON") & ~strcmp(beamPart,"CARBON") )
        error("unrecognised beam particle: %s - available only PROTON and CARBON!",beamPart);
    end
    if ( ~strcmp(machine,"SYNCHRO") & ~strcmp(machine,"LINET") & ~strcmp(machine,"SALA3") ...
                                    & ~strcmp(machine,"LINEU") & ~strcmp(machine,"SALA2H") ...
                                    & ~strcmp(machine,"LINEV") & ~strcmp(machine,"SALA2V") ...
                                    & ~strcmp(machine,"LINEZ") & ~strcmp(machine,"SALA1") ...
                                    )
        error("unrecognised machine: %s - available only SYNCHRO, LINEZ/SALA1, LINEV/SALA2V, LINEU/SALA2H and LINET/SALA3!",machine);
    end
    fprintf("...for: machine=%s; beamPart=%s; config=%s;\n",machine,beamPart,config);

    % do the job
    switch machine
        case "SYNCHRO"
            switch beamPart
                case "PROTON"
                    % BUILD TABLE WITH CyCo, Range, Energy and Brho
                    % - get CyCo (col 1 []), range (col 2 [mm]) and Energy (col 4 [MeV/n]) - columns in cell array
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Rampe\MatlabRampGen2.8\INPUT\CSV-TRATTAMENTI\Protoni.csv";
                    CyCoData = GetOPDataFromTables(FileName);
                    % - build array of values of Brho (as in RampGen)
                    mp = 938.255; An = 1; Zn = 1;
                    % PARSE FILE WITH CURRENTS AT FT - columns in final cell array:
                    % - nRows: number of power supplies + a header
                    % - nColumns: number of cycle codes + 2 (PS name + property)
                    FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\Sincro\CorrentiFlatTop\ProtoniSincro_2021-02-13.xlsx"; % AMereghetti, 2021-11-19: no longer there!
                    currentData = GetOPDataFromTables(FileNameCurrents,"Foglio1");
                case "CARBON"
                    if ( strcmp(config,"RFKO") )
                        error("no source of data available for %s %s %s",machine,beamPart,config);
                    end
                    % BUILD TABLE WITH CyCo, Range, Energy and Brho
                    % - get CyCo (col 1 []), range (col 2 [mm]) and Energy (col 4 [MeV/n]) - columns in cell array
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Rampe\MatlabRampGen2.8\INPUT\CSV-TRATTAMENTI\Carbonio.csv";
                    CyCoData = GetOPDataFromTables(FileName);
                    % - build array of values of Brho (as in RampGen)
                    mp = 931.2225; An = 12; Zn = 6;
                    % PARSE FILE WITH CURRENTS AT FT - columns in final cell array:
                    % - nRows: number of power supplies + a header
                    % - nColumns: number of cycle codes + 2 (PS name + property)
                    FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\Sincro\CorrentiFlatTop\CarbonioSincro_2021-02-05.xlsx"; % AMereghetti, 2021-11-19: no longer there!
                    currentData = GetOPDataFromTables(FileNameCurrents,"Foglio1");
                otherwise
                    error("no source of data available for %s %s %s",machine,beamPart,config);
            end % switch: LGEN, SYNCHRO, beamPart
            % continue crunching CyCo data
            CyCoData = CyCoData(2:end,:); % remove header
            c = 2.99792458e8;  % velocità della luce [m/s]
            BRO = @(x)(An/Zn)*((mp*sqrt((1 + x/mp).^2 - 1))/c)*10^6;
            temp=num2cell(BRO(cell2mat(CyCoData(:,4))));
            % - make a unique table: 1=CyCo[], 2=range[mm], 3=Energy[MeV/n], 4=Brho[Tm] - columns in final cell array
            CyCoData={CyCoData{:,1} ; CyCoData{:,2} ; CyCoData{:,4} ; temp{:,1} }';
            buffer = vertcat( CyCoData{:,1} ) ;      % extract only first four digits of cyco
            CyCoData(:,1) = cellstr(buffer(:,1:4)) ; % 
        case {"LINEZ","SALA1","LINEV","SALA2V","LINEU","SALA2H","LINET","SALA3"}
            switch beamPart
                case "PROTON"
                    % BUILD TABLEs WITH CyCo, Range, Energy and Brho
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\MeVvsCyCo_P.xlsx";
                    CyCoData = GetOPDataFromTables(FileName,"Sheet1");
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\EvsBro_P.xlsx";
                    BrhoData = GetOPDataFromTables(FileName,"Sheet1");
                    % PARSE FILE WITH CURRENTS AT FT - columns in final cell array:
                    switch machine
                        case {"LINEZ","SALA1"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Protoni\ProtoniSala1\Protoni_Sala1_2022-03-09.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"09.03.2022 - 10.27");
                        case {"LINEV","SALA2V"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Protoni\ProtoniSala2V\Protoni_Sala2V_2021-02-13.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"27.01.2022 - 09.08");
                        case {"LINEU","SALA2H"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Protoni\ProtoniSala2H\Protoni_Sala2H_2021-08-09.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"09.08.2021 - 14.51");
                        case {"LINET","SALA3"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Protoni\ProtoniSala3\Protoni_Sala3_2021-08-11.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"11.08.2021 - 08.59");
                    end
                case "CARBON"
                    % BUILD TABLEs WITH CyCo, Range, Energy and Brho
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\MeVvsCyCo_C.xlsx";
                    CyCoData = GetOPDataFromTables(FileName,"Sheet1");
                    FileName="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\EvsBro_C.xlsx";
                    BrhoData = GetOPDataFromTables(FileName,"Sheet1");
                    % PARSE FILE WITH CURRENTS AT FT - columns in final cell array:
                    switch machine
                        case {"LINEZ","SALA1"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Carbonio\lineaZ\fuocopiccolo\Carbonio_Sala1_FromRepoNovembre2020.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"09.11.2020 - 10.10");
                        case {"LINEV","SALA2V"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Carbonio\lineaV\FuocoPiccolo\Carbonio_Sala2V_FromRepo.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"21.08.2019 - 12.11");
                        case {"LINEU","SALA2H"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Carbonio\lineaU\FuocoPiccolo\Carbonio_Sala2H_FromRepo.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"21.08.2019 - 12.04");
                        case {"LINET","SALA3"}
                            FileNameCurrents="S:\Accelerating-System\Accelerator-data\Area dati MD\00Setting\HEBT\Carbonio\lineaT\fuocopiccolo\Carbonio_Sala3_FromRepoNovembre2020.xlsx";
                            currentData = GetOPDataFromTables(FileNameCurrents,"09.11.2020 - 10.11");
                    end
                otherwise
                    error("no source of data available for %s %s %s",machine,beamPart,config);
            end % switch: LGEN, LINET/SALA3/LINEU/SALA2H/LINEV/SALA2V/LINEZ/SALA1, beamPart
            % - get CyCo (col 2 []), range (col 3 [mm]) and Energy (col 1 [MeV/n]) - columns in cell array
            CyCoData = CyCoData(2:end,:); % remove header
            % - get Brho (col 2 [Tm]) and Energy (col 1 [MeV/n]) - columns in cell array:
            BrhoData = BrhoData(2:end,:); % remove header
            % - get common ranges
            [commonRanges,iCRa,iCRb]=intersect(cell2mat(CyCoData(:,3)),cell2mat(BrhoData(:,1)));
            CyCoData=CyCoData(iCRa,:);
            BrhoData=BrhoData(iCRb,:);
            % - make a unique table: 1=CyCo[], 2=range[mm], 3=Energy[MeV/n], 4=Brho[Tm] - columns in final cell array
            CyCoData={CyCoData{:,2} ; CyCoData{:,3} ; CyCoData{:,1} ; BrhoData{:,2} }';
        otherwise
            error("no source of data available for %s %s %s",machine,beamPart,config);
    end % switch: machine

    % get currents and PSs to be crunched
    % - nRows: number of power supplies + a header
    % - nColumns: number of cycle codes + 2 (PS name + property)
    [currents,psNames]=tableCurrents(currentData(2:end,3:end),currentData(2:end,1)); % remove useless data from PS file and convert to matrix of floats
    nPSs=length(psNames);

    % - get cycle codes to be crunched
    buffer = vertcat( currentData{1,3:end} ) ; % extract only first four digits of cyco
    currCycodes=cellstr(buffer(:,1:4)) ;       %
    nCyCodes=length(currCycodes);

    for iFilter=1:length(filters)
        switch upper(filters(iFilter))
            case "NAN"
                % - keep only PSs with no NANs (full set of cycodes should be NaN)
                fprintf("...filtering NaNs from PSs...\n");
                % PS deleted)
                iRows=zeros(size(currents,1),1,'logical');
                for ii=1:length(iRows)
                    iRows(ii)=length(currents(ii,~isnan(currents(ii,:))))==nCyCodes;
                end
                nDelete=nPSs-sum(iRows);
                if ( nDelete>0 )
                    warning("found %d PSs with rows/columns full of NaNs! removing them...",nDelete);
                    currents=currents(iRows,:);
                    psNames=psNames(iRows);
                    nPSs=length(psNames);
                end
            case {"ZERO","0","0.0","0."}
                % - keep only PSs with no 0.0s (full set of cycodes should be 0)
                fprintf("...filtering 0.0s from PSs...\n");
                % PS deleted)
                iRows=zeros(size(currents,1),1,'logical');
                for ii=1:length(iRows)
                    iRows(ii)=length(currents(ii,currents(ii,:)~=0.0))==nCyCodes;
                end
                nDelete=nPSs-sum(iRows);
                if ( nDelete>0 )
                    warning("found %d PSs with rows/columns full of 0s! removing them...",nDelete);
                    currents=currents(iRows,:);
                    psNames=psNames(iRows);
                    nPSs=length(psNames);
                end
            otherwise
                warning("...un-identified filtering criterion: %s",filters(iFilter));
        end
    end

    % map the CyCo in both current data and CyCo data
    [commonCyCodes,iCCa,iCCb]=intersect(currCycodes,CyCoData(:,1));
    if ( iCCa~=nCyCodes )
        warning("not all cycle codes in PS file will be dumped!");
    end
    % - general data:
    cyCodes=commonCyCodes;
    CyCoData=CyCoData(iCCb,:);
    ranges=cell2mat(CyCoData(:,2));
    Eks=cell2mat(CyCoData(:,3));
    Brhos=cell2mat(CyCoData(:,4));
    % - currents, fields, kicks
    currents=currents(:,iCCa)';
    fields=Currents2Fields(psNames,currents');
    kicks=Fields2Kicks(fields,Brhos);

    if ( length(cyCodes)==0 )
        warning("no data loaded!");
        if ( doVisualCheck )
            warning("skipping visual checks!");
        end
    else
        if ( doVisualCheck )
            fprintf("...preparing checking plots...\n");
            if ( isempty(LGENsCheck) )
                LGENsCheck=string(psNames)';
            end
            xVals=ranges;
            xLab="BP [mm]"; % "BP [mm]", "Ek [MeV/n]", "Brho [Tm]"
            fprintf("   ...bare currents...\n");
            visualCheck(LGENsCheck,psNames,xVals,xLab,currents);
            fprintf("   ...fields...\n");
            visualCheck(LGENsCheck,psNames,xVals,xLab,currents,fields);
            fprintf("   ...normalised kicks...\n");
            visualCheck(LGENsCheck,psNames,xVals,xLab,currents,fields,kicks);
        end
    end

    fprintf("...done.\n");
end

%% ancillary functions

function [currents,psNames]=tableCurrents(currentData,psNameData)
    nRows=size(currentData,1);
    nCols=size(currentData,2);
    whichRows=false(nRows,1);
    for iRow=1:nRows
        if ( ischar(currentData{iRow,1}) || isstring(currentData{iRow,1}) )
            whichRows(iRow)=1;
        else
            whichRows(iRow)=~ismissing(currentData{iRow,1});
        end
    end
    nEmpty=nRows-sum(whichRows);
    if ( nEmpty>0 )
        warning("found %d PSs with empty rows! removing them...",nEmpty);
    end
    currents=currentData(whichRows,:);
    psNames=upper(psNameData(whichRows,:));
    if ( ischar(currents{1,1}) || isstring(currents{1,1}) )
        currents=str2double(currents);
    else
        currents=cell2mat(currents);
    end
end

function visualCheck(LGENs,psNames,xVals,xLab,currents,fields,kicks)
    % visual check
    figure('Name','visual check','NumberTitle','off');
    nSets=length(LGENs);
    % automatically set grid of subplots
    [nRows,nCols]=GetNrowsNcols(nSets);
    for iSet=1:nSets
        currLGEN=LGENs(iSet);
        subplot(nRows,nCols,iSet);
        jj=find(strcmp(psNames,currLGEN));
        if ( exist('fields','var') )
            [pQ,unit,name]=LGENname2pQ(currLGEN);
            if ( exist('kicks','var') )
                plot(currents(:,jj),fields(:,jj),'s-');
                ylabel(sprintf("%s [%s]",name,unit));
                yyaxis right;
                plot(currents(:,jj),kicks(:,jj),'.-');
                [kickName,kickUnit]=DecodeKickName(name);
                ylabel(sprintf("%s [%s]",kickName,kickUnit));
                yyaxis left;
                xlabel("I [A]");
                legend('field','kick','Location','best');
            else        
                minField=min(fields(:,jj));
                maxField=max(fields(:,jj));
                tmpFields=minField:(maxField-minField)/200:maxField;
                tmpCurrents=polyval(pQ,tmpFields);
                plot(fields(:,jj),currents(:,jj),'*',tmpFields,tmpCurrents,'-');
                xlabel(sprintf("%s [%s]",name,unit));
                ylabel("I [A]");
                legend('data','curve','Location','best');
            end
        else
            plot(xVals,currents(:,jj),'*');
            xlabel(xLab);
            ylabel("I [A]");
            legend('data','Location','best');
        end
        grid on;
        title(currLGEN);
    end
end

function vOut=ConvertCyCodes(cyCodesIN,ZZin,what,pathP,pathC)
% ConvertCyCodes             converts a given list of cycle codes into a list 
%                              of corresponding beam energies or mm range
% input:
% - cyCodesIN (array of strings): array of cycle codes to be indentified/converted;
% - ZZin (array of integers, optional): array labelling which particle DB of
%           cyCodes should be looked up;
% - what (string, optional): variable requested:
%   . Ek (default): kinetic energies corresponding to the cyCodes [MeV(u];
%   . mm: mm-range corresponding to the cyCodes;
% - pathP (string, optional): path to MeVvsCyCo file for protons;
% - pathC (string, optional): path to MeVvsCyCo file for carbon ions;
%
% output:
% - vOut (array of floats): either beam energies [MeV/u] or range [mm];
%
% NB: length(vOut)=length(cyCodesIN)=length(ZZin)
%
% See also: GetOPDataFromTables, MapCyCode and ParseMeVvsCyCo.

    % default requests
    if ( ~exist('ZZin','var') ), ZZin=ones(size(cyCodesIN)); end
    if ( ~exist('what','var') ), what="Ek"; end
    if ( ~exist('pathP','var') ), pathP=1; end
    if ( ~exist('pathC','var') ), pathC=6; end
   
    % get reference cyCodes
    [P_Eks,P_cyCodes,P_mms]=ParseMeVvsCyCo(pathP);
    [C_Eks,C_cyCodes,C_mms]=ParseMeVvsCyCo(pathC);

    % get maps
    [lCCP,iCCP]=MapCyCode(cyCodesIN,P_cyCodes);
    [lCCC,iCCC]=MapCyCode(cyCodesIN,C_cyCodes);
    % verify that all cycodes are in principle recognizable
    unidentified=find(~lCCC & ~lCCP);
    if ( ~isempty(unidentified) )
        error("unable to decode some cyCodes\n:%s",join(cyCodesIN(unidentified),newline));
    end
    
    % assign values
    vOut=zeros(length(cyCodesIN),1);
    indices_P=(lCCP & ZZin==1);
    indices_C=(lCCC & ZZin==6);
    indices_N=(ZZin==-1);
    if ( ~isempty(indices_N) )
        doubleFound=find(lCCC(indices_N) & lCCP(indices_N));
        if ( ~isempty(doubleFound) )
            error("cannot determine weather cyCodes with no part are actually protons or carbon ions\n:%s",...
                join(cyCodesIN(doubleFound),newline));
        end
        indices_NP=(lCCP & ZZin==-1);
        indices_NC=(lCCC & ZZin==-1);
    end
    switch upper(what)
        case "EK"
            vOut(indices_P)=P_Eks(iCCP(indices_P));
            vOut(indices_C)=C_Eks(iCCC(indices_C));
            if ( ~isempty(indices_N) )
                vOut(indices_NP)=P_Eks(iCCP(indices_NP));
                vOut(indices_NC)=C_Eks(iCCC(indices_NC));
            end
        case "MM"
            vOut(indices_P)=P_mms(iCCP(indices_P));
            vOut(indices_C)=C_mms(iCCC(indices_C));
            if ( ~isempty(indices_N) )
                vOut(indices_NP)=P_mms(iCCP(indices_NP));
                vOut(indices_NC)=C_mms(iCCC(indices_NC));
            end
        otherwise
            error("Unable to recognize request %s",what);
    end
end

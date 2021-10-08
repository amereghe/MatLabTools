function vOut=ConvertCyCodes(cyCodesIN,what,pathP,pathC)
% ConvertCyCodes             converts a given list of cycle codes into a list 
%                              of corresponding beam energies or mm range
% input:
% - cyCodesIN (array of strings): array of cycle codes to be indentified/converted;
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
% See also: DecodeCyCodes, GetOPDataFromTables, MapCyCode and ParseMeVvsCyCo.

    % default requests
    if ( ~exist('what','var') ), what="Ek"; end
    if ( ~exist('pathP','var') ), pathP=1; end
    if ( ~exist('pathC','var') ), pathC=6; end
   
    % get reference cyCodes
    [P_Eks,P_cyCodes,P_mms]=ParseMeVvsCyCo(pathP);
    [C_Eks,C_cyCodes,C_mms]=ParseMeVvsCyCo(pathC);

    % get maps
    [rangeCodes,partCodes]=DecodeCyCodes(cyCodesIN);
    % verify that all particle codes are recognizable
    unidentified=(partCodes~=0 & partCodes~=3);
    if ( ~isempty(unidentified) )
        error("unidentified particle in some cyCodes\n:%s",join(cyCodesIN(unidentified),newline));
    end
    [lCCP,iCCP]=MapCyCode(rangeCodes,P_cyCodes);
    [lCCC,iCCC]=MapCyCode(rangeCodes,C_cyCodes);
    % verify that all ranges are recognizable
    unidentified=find(~lCCC & ~lCCP);
    if ( ~isempty(unidentified) )
        error("unidentified range in some cyCodes\n:%s",join(cyCodesIN(unidentified),newline));
    end
    
    % assign values
    vOut=zeros(length(cyCodesIN),1);
    indices_P=(lCCP & partCodes==0);
    indices_C=(lCCC & partCodes==3);
    switch upper(what)
        case "EK"
            vOut(indices_P)=P_Eks(iCCP(indices_P));
            vOut(indices_C)=C_Eks(iCCC(indices_C));
        case "MM"
            vOut(indices_P)=P_mms(iCCP(indices_P));
            vOut(indices_C)=C_mms(iCCC(indices_C));
        otherwise
            error("Unable to recognize request %s",what);
    end
end

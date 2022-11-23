function outNames=MagNames2LGENnames(inNames,lInv,PSmapping)
    if (~exist("lInv","var")), lInv=false; end % by default, convert Magnet Name into LGEN
    
    outNames=strings(length(inNames),1);
    if (lInv)
        % LGEN name --> Magnet name
        arrayIN=PSmapping.LGEN;
        arrayOUT=PSmapping.Magnet_NAME;
        whatIN="Magnet Name";
    else
        % Magnet name --> LGEN name
        arrayIN=PSmapping.Magnet_NAME;
        arrayOUT=PSmapping.LGEN;
        whatIN="LGEN Name";
    end
    
    % query mapping
    for ii=1:length(inNames)
        jj=find(strcmpi(string(arrayIN),inNames(ii)));
        if ( isempty(jj) ), error("%s %s not found in LGEN mapping table!",whatIN,inNames(ii)); end
        outNames(ii)=string(arrayOUT(jj));
    end
end


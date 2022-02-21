function cyCodesOut=PadCyCodes(cyCodesIN)
% PadCyCodes       head cyCodes with 0, ie cyCodes<12 chars: head as many "0" as needed
    cyCodesOut=pad(cyCodesIN,12,"left","0");
end

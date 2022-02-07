function cyCodesOut=PadCyCodes(cyCodesIN)
% PadCyCodes       head cyCodes with 0, ie cyCodes<12 chars: head as many "0" as needed
    cyCodesOut=cyCodesIN;
    % pay attention to missing cyCodes
    indices=(~ismissing(cyCodesOut));
    cyCodesOut(indices)=pad(cyCodesOut(indices),12,"left","0");
end

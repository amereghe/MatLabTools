function [currName,currUnit]=DecodeKickName(kickName)
% DecodeKickName               get MADX kick name and unit from the field
% name
    switch upper(kickName)
        case "B"
            currName="K0";
            currUnit="m-1";
        case "G"
            currName="K1";
            currUnit="m-2";
        case "S"
            currName="K2";
            currUnit="m-3";
        case "K"
            currName="kick";
            currUnit="rad";
        otherwise
            warning("unexpected multipole field name: %s",kickName);
            currName="???";
            currUnit="???";
    end
end

function [rangeCodes,partCodes]=DecodeCyCodes(cyCodes)
% DecodeCyCodes         decodes cyCodes
% 
% for the time being, only the range and particle part is taken.
    rangeCodes=extractBetween(cyCodes,1,4);
    partCodes=str2double(extractBetween(cyCodes,5,5));
end

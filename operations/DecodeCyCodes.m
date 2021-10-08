function [rangeCodes,partCodes]=DecodeCyCodes(cyCodes)
% DecodeCyCodes         decodes cyCodes
% 
% for the time being, only the range and particle part is taken.
    rangeCodes=extractBetween(cyCodes,1,4);
    partCodes=extractBetween(cyCodes,5,5); % 0: protons; 3: carbon ions;
end
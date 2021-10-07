function [lCC,iCC]=MapCyCode(cyCodeIN,cyCodeRef)
% MapCyCode              map a given list of cycle codes onto a list of
%                           reference ones
% input:
% - cyCodeIN (array of strings): list of cycle codes to be identified;
% - cyCodeRef (array of strings): list of cycle codes of reference;
%
% output:
% - lCC (array of booleans): presence/absence of the a given cyCodeIN in cyCodeRef;
% - iCC (array of integers): index in cyCodeRef of a given cyCodeIN;
%
% NB: length(lCC)=length(iCC)=length(cyCodeIN)
%
% See also: ConvertCyCodes, GetOPDataFromTables and ParseMeVvsCyCo.
    [lCC,iCC]=ismember(upper(extractBetween(cyCodeIN,1,4)),upper(extractBetween(cyCodeRef,1,4)));
end

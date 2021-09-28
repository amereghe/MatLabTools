function convCoeff=EstimateConvCoeff(doses)
% EstimateConvCoeff()   to estimate the counts->dose conversion coefficient.
%
% The coefficient is estimated as min difference among dose values or
%   minimum dose value; hence, the function may return the least
%   significant bit. The search is performed only on positive dose values
%   or positive dose variations.
%
% input:
% - doses (array of floats): array of dose values [uSv];
% 
% output:
% - convCoeff (scalar, float): conversion coefficient;

    % min, positive value
    nonZerDoses=doses(doses>0.0);
    minVal=min(nonZerDoses);
    
    % min, positive delta
    nonZerDoses=sort(nonZerDoses);
    nonZerDoses=unique(nonZerDoses);
    diffs=diff(nonZerDoses);
    diffs=diffs(diffs>0.0);
    minDiff=min(diffs);
    
    % conv coeff is the actual min
    convCoeff=min(minDiff,minVal);
end

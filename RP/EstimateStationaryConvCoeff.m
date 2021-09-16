function convCoeff=EstimateStationaryConvCoeff(doses)
    % min, positive value
    nonZerDoses=doses(doses>0.0);
    minVal=min(nonZerDoses);
    % min, positive delta
    diffs=diff(doses);
    diffs=diffs(diffs>0.0);
    minDiff=min(diffs);
    % conv coeff is the actual min
    convCoeff=min(minDiff,minVal);
end
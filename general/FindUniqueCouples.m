function [uniquev1,uniquev2,idx]=FindUniqueCouples(v1,v2)
    % from:
    %   https://it.mathworks.com/matlabcentral/answers/109003-select-unique-couples-from-two-vectors
    v = [v1, v2];
    [uniquerows, idx] = unique(v, 'rows');
    uniquev1 = v1(idx);
    uniquev2 = v2(idx);    
end

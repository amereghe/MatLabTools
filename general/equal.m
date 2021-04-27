function isEqual=equal(x,y,prec)
% isEqual      verify that x==y within a given precision
    isEqual=0;
    if ( x ~= 0 )
        isEqual=abs(y./x-1)<prec;
    else
        isEqual=abs(y-x)<prec;
    end
end

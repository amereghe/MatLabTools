function lComp=CompFloats(f1,f2,way,myPrec)
    if (~exist('way','var')), way="EQ"; end
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( size(f1)~=size(f2) )
        error("Cannot compare two float entities of different dimensions!");
    end
    switch upper(way)
        case "EQ"
            lComp=EQ(f1,f2,myPrec);
        case "LT"
            lComp=LT(f1,f2,myPrec);
        case "LE"
            lComp=LE(f1,f2,myPrec);
        case "GT"
            lComp=GT(f1,f2,myPrec);
        case "GE"
            lComp=GE(f1,f2,myPrec);
        otherwise
            error("Not-recognised way of comparing two floats: %s",way);
    end
end

function lComp=EQ(f1,f2,myPrec)
    % f1==f2 within myPrec
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( f2==0 )
        lComp=abs(f1)<=myPrec;
    else
        lComp=abs(f1./f2-1)<=myPrec;
    end
end
function lComp=GT(f1,f2,myPrec)
    % f1>f2 within myPrec
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( EQ(f1,f2,myPrec) )
        lComp=false;
    else
        lComp=f1>f2;
    end
end
function lComp=LT(f1,f2,myPrec)
    % f1<f2 within myPrec
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( EQ(f1,f2,myPrec) )
        lComp=false;
    else
        lComp=f1<f2;
    end
end
function lComp=GE(f1,f2,myPrec)
    % f1>=f2 within myPrec
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( EQ(f1,f2,myPrec) )
        lComp=true;
    else
        lComp=f1>f2;
    end
end
function lComp=LE(f1,f2,myPrec)
    % f1<=f2 within myPrec
    if (~exist('myPrec','var')), myPrec=1.0E-12; end
    if ( EQ(f1,f2,myPrec) )
        lComp=true;
    else
        lComp=f1<f2;
    end
end

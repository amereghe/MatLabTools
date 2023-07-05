function myFmt=StartConditionsFormat(tracker)
% example format of line of parsed files (argument of ID is read as well):
%                 START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0; ! ID=1 
%                 PTC_START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0; ! ID=1 
    switch upper(tracker)
        case {"MADX","MAD","MAD-X"}
            myFmt='START, X=%f, PX=%f, Y=%f, PY=%f, T=%f, PT=%f;%*[^\n]';
        case "PTC"
            myFmt='PTC_START, X=%f, PX=%f, Y=%f, PY=%f, T=%f, PT=%f;%*[^\n]';
        otherwise
            error("Unknown tracker %s!",tracker);
    end
end

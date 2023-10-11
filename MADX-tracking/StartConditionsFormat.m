function myFmt=StartConditionsFormat(tracker,action)
% example format of line of parsed files (argument of ID is read as well):
%                 START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0; ! ID=1 
%                 PTC_START, X=-0.01, PX=-0.01, Y=0, PY=0, T=0, PT=0; ! ID=1 
    if (~exist("action","var")), action=missing(); end
    if (ismissing(action)), action="R"; end
    switch upper(tracker)
        case {"MADX","MAD","MAD-X"}
            initial="START";
        case "PTC"
            initial="PTC_START";
        otherwise
            error("Unknown tracker %s!",tracker);
    end
    switch upper(action)
        case {"READ","R"}
            myFmt=strcat(initial,", X=%f, PX=%f, Y=%f, PY=%f, T=%f, PT=%f;%*[^\n]");
        case {"WRITE","W"}
            myFmt=strcat(initial,", X=% 22.15E, PX=% 22.15E, Y=% 22.15E, PY=% 22.15E, T=% 22.15E, PT=% 22.15E;%*[^\n]");
        otherwise
            error("Unknown action %s!",action);
    end
end

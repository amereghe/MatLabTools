function newName=GetIncrementalName(origName,lDebug)
    if ( ~exist('lDebug','var') ), lDebug=false; end
    if ( isfile(origName) )
        origNameSplit=split(origName,".");
        ext=origNameSplit(end);
        lE=strlength(ext); lS=strlength(origName);
        for ii=2:99
            newName=sprintf("%s_%02d.%s",extractBetween(origName,1,lS-lE-1),ii,ext);
            if ( ~isfile(newName) )
                if ( lDebug )
                    warning("GetIncrementalName: OLD name: %s; NEW name: %s",origName,newName);
                end
                break;
            end
        end
    else
        newName=origName;
    end
    
end

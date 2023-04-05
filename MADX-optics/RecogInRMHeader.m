function [iColVarName,VarNam,VarEle]=RecogInRMHeader(header,varName)
% example of header:
%   brho[tm],bp[mm],i[a]:h2_019a_ceb,hkick[rad]:h2_019a_ceb,
%         x[m]:h2_025b_sfh,y[m]:h2_025b_sfh,
%         x[m]:he_010b_qpp,y[m]:he_010b_qpp,
%         x[m]:he_012b_sfp,y[m]:he_012b_sfp
    iColVarName=(contains(header,varName,'IgnoreCase',true));
    if (~any(iColVarName)), error("Cannot find %s in header!",varName); end
    if (contains(varName,"KICK[rad]",'IgnoreCase',true))
        % peculiar case: refine search of y columns
        if (contains(header(iColVarName),"HKICK[rad]:",'IgnoreCase',true))
            iColVarName=contains(header,"X[m]:",'IgnoreCase',true);
        elseif (contains(header(iColVarName),"VKICK[rad]:",'IgnoreCase',true))
            iColVarName=contains(header,"Y[m]:",'IgnoreCase',true);
        else
            header(iColVarName)
            error("what should I take?");
        end
    end
    if (any(contains(header(iColVarName),":")))
        Vars=upper(split(header(iColVarName),":"));
        if (contains(varName,"KICK[rad]",'IgnoreCase',true))
            VarNam=Vars(:,1);
            VarEle=Vars(:,2);
        else
            VarNam=Vars(1);
            VarEle=Vars(2);
        end
    else
        VarNam=missing();
        VarEle=missing();
    end
    iColVarName=find(iColVarName);
end

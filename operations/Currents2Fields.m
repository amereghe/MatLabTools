function tableFields=Currents2Fields(psNames,currents)
% Currents2Fields            convert currents into fields, using the
% inverse of the functions coded in LGENname2pQ
    nPSs=length(psNames);
    nValues=size(currents,2);
    tableFields=zeros(nValues,nPSs);
    for jj=1:nPSs
        [pQ,unit,name]=LGENname2pQ(psNames{jj});
        pQend=pQ(end);
        for ii=1:nValues
            pQ(end)=pQend-currents(jj,ii);
            [x,err]=newtonMethodPol(pQ);
            tableFields(ii,jj)=x;
        end
    end
end

function [x,err]=newtonMethodPol(pQ,x0,prec,nMax)
    x=0.0;
    if ( exist('x0','var') )
        x=x0;
    end
    if ( ~exist('prec','var') )
        prec=1E-12;
    end
    if ( ~exist('nMax','var') )
        nMax=100;
    end
    %
    pQder=pQ(1:end-1);
    for ii=1:nMax
        xN = x - polyval(pQ,x)/polyval(pQder,x);
        if( x~=0.0 )
            err=xN/x-1;
        else
            err=xN-x;
        end
        % fprintf("%d %.5E %.5E \n",ii,x,err); % debug
        if (abs(err)<prec)
            break;
        else
            x=xN;
        end
    end
end

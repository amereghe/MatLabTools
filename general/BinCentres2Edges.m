function [Vout]=BinCentres2Edges(Vin)
    delta=diff(Vin); delta=delta(1);
    if (size(Vin,1)==1)
        % column array
        Vout=[Vin Vin(end)+delta]-delta/2;
    else
        % row array
        Vout=[Vin;Vin(end)+delta]-delta/2;
    end
end

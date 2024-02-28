function [ZoA,I,rho,plasmaFreq,C,x0,x1,a,m,d0,X0l]=setMaterial(matName)
%   - material parameters:
%     . https://pdg.lbl.gov/2022/AtomicNuclearProperties/index.html
%   - density effect: Sternheimer, Berger and Seltzer, ATOMIC DATA AND NUCLEAR DATA TABLES 30,26 l-27 1 (1984)

    switch upper(matName)
        case {"WATER","WAT","H2O"}
            fprintf("...using WATER material data...\n");
            ZoA=0.555087; % []
            I=79.7; % [eV]
            rho=1.0; % [g/cm3]
            plasmaFreq=21.469; % [eV]
            C=3.5017; % actually, -C []
            x0=0.2400; % []
            x1=2.8004; % []
            a=0.09116; % []
            m=3.4773; % []
            d0=0.0; % []
            X0l=36.08; % [cm]
        otherwise
            error("Unknown material %s!",matName)
    end
end

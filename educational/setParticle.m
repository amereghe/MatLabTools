function [myM,myEk,myZ,myA,unitEk]=setParticle(Ek,myPart)
%  input:
%  - myPart: "PROTON"/"CARBON"/"HELIUM";
%  - Ek (1D array): kinetic energy; protons [MeV]; other: [MeV/u];
%
%  output:
%  - myM: mass of particle [MeV/c2];
%  - myEk (1D array): kinetic energy [MeV];
%  - myZ []: charge state of particle;
%  - myA []: nuclear mass of particle;
%  - unitEk: "MeV" for protons, "MeV/u" for others;

    run(strrep(mfilename('fullpath'),"setParticle","particleData.m"));
    switch upper(myPart)
        case {"P","PROT","PROTON"}
            fprintf("...using PROTON data...\n");
            myM=mp; myEk=Ek; myA=Ap; myZ=Zp; unitEk="MeV";
        otherwise
            switch upper(myPart)
                case {"HE","HELIUM","ALPHA","ALFA"}
                    myA=4; myZ=2; fprintf("...using HELIUM_4^2+ data...\n");
                case {"C","CARB","CARBON"}
                    myA=12; myZ=6; fprintf("...using CARBON_12^6+ data...\n");
                otherwise
                    error("Unknown particle %s!",myPart);
            end
            myM=ComputeMass(myA,myZ); myEk=Ek*myA; unitEk="MeV/u";
    end
end

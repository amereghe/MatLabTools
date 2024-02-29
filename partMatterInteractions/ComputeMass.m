function Mass=ComputeMass(A,Z)
    % ref: https://web-docs.gsi.de/~wolle/TELEKOLLEG/KERN/LECTURE/Fraser/L1.pdf
    % load particle data
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeMass","educational\particleData.m"));
    if (A==1 && Z==1)
        Mass=mp;
    elseif (A==1 && Z==0)
        Mass=mn;
    else
        % load DB of mass excess (object T)
        load(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeMass","educational\nubase_4.mas20.mat"),"T");
        % find line in DB
        myIndex=find(T.A==A & T.Z==Z & ismissing(T.s));
        if (isempty(myIndex)), error("...what is A,Z=%d,%d?",A,Z); end
        if (length(myIndex)>1), error("...non-unique A,Z=%d,%d?!",A,Z); end
        % calculate mass using mass defect
        Mass=A*mAmu+T.MassExcess(myIndex)*1E-3; % [keV] --> [MeV]
        % correct by electron mass and binding energy (Thomas-Fermi formula):
        Mass=Mass-Z*(me-15.73E-9*Z^(7./3.));
    end
end

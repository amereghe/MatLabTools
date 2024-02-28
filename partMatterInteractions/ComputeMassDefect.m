function MassDef=ComputeMassDefect(A,Z)
    % load particle data
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeMassDefect","educational\particleData.m"));
    % calculate mass defect
    MassDef=Z*(mp+me)+(A-Z)*mn-A*mAmu;
end

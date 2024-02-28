function Mass=ComputeMass(A,Z)
    % load particle data
    run(strrep(mfilename('fullpath'),"partMatterInteractions\ComputeMass","educational\particleData.m"));
    % calculate mass using mass defect
    Mass=A*mAmu-(Z*(mp+me)+(A-Z)*mn-A*mAmu);
end

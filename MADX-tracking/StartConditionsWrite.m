function StartConditionsWrite(FileName,particles,tracker)
    if ( ~exist('tracker','var') ), tracker="MADX"; end
    fprintf("writing starting conditions of %d particles to file %s (%s format)...\n",length(particles),FileName,tracker);
    myFmt=StartConditionsFormat(tracker);
    fileID = fopen(FileName,'w');
    for jj=1:length(particles)
        fprintf(fileID,"%s\n",sprintf(myFmt,particles(jj,:)));
    end
    fclose(fileID);
    fprintf("...done;\n");
end

function WritePolyMasterFile(tStamps,doses,fileName)
    % input:
    % - tStamps (array of time stamps): time stamps of counts;
    % - doses (array of floats): dose values at each time stamp;
    % - fileName: name of file to be created (including path, if needed);
    %
    % file of counts must have the following format:
    % - a 1-line header;
    % - a line with the integrated dose over 10 minutes; the format of the line is eg: "2021/07/23;23:04:26;PM1610 #218161;Dose Rate;0.0900 uSv/h;0.0000 uSv;0.0000 uSv;Gamma"
    % - the reported dose is NOT cumulative!
    nPoints=length(tStamps);
    fprintf("writing %d data points into file %s...\n",nPoints,fileName);
    fileID = fopen(fileName,"w");
    fprintf(fileID,"Date;Time;Device;Type;Rate;DoseDelta;Dose;Channel\n");
    fprintf(fileID,"%s\n",compose("%s;PM1610 #218161;Dose Rate;0.0900 uSv/h;%6.4f uSv;0.0000 uSv;Gamma",string(tStamps,"yyyy/MM/dd;HH:mm:ss"),doses));
    fclose(fileID);
    fprintf("...done;\n");
end

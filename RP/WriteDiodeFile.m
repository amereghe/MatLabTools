function WriteDiodeFile(tStamps,counts,fileName)
% WriteDiodeFile       write data to a text file, identical in format
%                           to that of diodes (REM coutners).
% input:
% - tStamps (array of time stamps): time stamps of counts;
% - counts (array of floats): counts at each time stamp;
% - fileName: name of file to be created (including path, if needed);
%
% A single monitor/data set is crunched at a time.
%
% file of counts must have the following format:
% - no header;
% - a line for each count; the format of the line is eg: "2021/02:13-00:17:40 CEST,13"
% - the counter is incremental: a new measurement starts at count==1;
%
% See also: ParseDiodeFiles, ParsePolyMasterFiles, ParseStationaryFiles, 
%           WritePolyMasterFile and WriteStationaryFile.
    nPoints=length(tStamps);
    fprintf("writing %d data points into file %s...\n",nPoints,fileName);
    fileID = fopen(fileName,"w");
    fprintf(fileID,"%s\n",compose("%s CEST,%d",string(tStamps,"yyyy/MM:dd-HH:mm:ss"),counts));
    fclose(fileID);
    fprintf("...done;\n");
end

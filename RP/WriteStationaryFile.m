function WriteStationaryFile(tStamps,doses,fileName,means,maxs,mins)
    % input:
    % - fileName: name of file to be created (including path, if needed);
    % - tStamps (array of time stamps): time stamps of dose values;
    % - doses (array of floats): dose values at each time stamp;
    % - means (array of floats): average dose at each time stamp;
    % - maxs (array of floats): max dose at each time stamp;
    % - mins (array of floats): min dose at each time stamp;
    %
    % file of counts must have the following format:
    % - 9 lines of header;
    % - a line for each dose event; the format of the line is eg: "12.09.21;03:21:10;0.000E+00;0.000E+00;0.000E+00;3.167E-04;100;0;No Alarm;"
    % - the counter is incremental;
    nPoints=length(tStamps);
    if ( ~exist('means','var') ), means=zeros(nPoints,1); end
    if ( ~exist('maxs','var') ), maxs=zeros(nPoints,1); end
    if ( ~exist('mins','var') ), mins=zeros(nPoints,1); end
    fprintf("writing %d data points into file %s...\n",nPoints,fileName);
    fileID = fopen(fileName,"w");
    WriteHeader(fileID);
    for ii=1:nPoints
        fprintf(fileID,"%s;%9.3E;%9.3E;%9.3E;%9.3E;100;0;No Alarm;\n",...
            string(tStamps(ii),"dd.MM.yy;HH:mm:ss"),means(ii),maxs(ii),mins(ii),doses(ii));
    end
    fclose(fileID);
    fprintf("...done;\n");
end

function WriteHeader(fileID)
    fprintf(fileID,"Stored at:;13.09.21;11:02\n");
    fprintf(fileID,"Data from: ;01.09.21;00:00\n");
    fprintf(fileID,"Until:;02.09.21;00:00\n");
    fprintf(fileID,"\n");
    fprintf(fileID,"Channel:;18\n");
    fprintf(fileID,"Position:;Neutron_Sala Trattamento 3\n");
    fprintf(fileID,"Unit:;µSv/h\n");
    fprintf(fileID,"\n");
    fprintf(fileID,"Date;Time;Mean value;Maximum;Minimum;Dose [µSv];Availability [%%];Status [hex];Alarm\n");
end
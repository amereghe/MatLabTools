function iAdds=AlignDataIndices(indices)
% AlignDataIndices        function that, based on the indices of FWHMs/BARs
%                            measurements and scanning manget currents,
%                            aligns data accordingly.
%
% input:
% - indices (float(1+nSeries,2)): min and max indices of the points
%    of the actual scan in the series and in the currentsXLS array;
%    NB: first index refers to currents in .xlsx file;
%
% output:
% - iAdds (float(1+nSeries,1)): offsets based on indices to align data in
%                               tables;
%
    iAdds=max(indices(:,1))-indices(:,1);
end

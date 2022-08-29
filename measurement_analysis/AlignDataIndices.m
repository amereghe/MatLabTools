function iAdds=AlignDataIndices(indices,lForceTwo)
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
    if ( ~exist("lForceTwo","var") ), lForceTwo=false; end
    nSeries=size(indices,1);
    nPlanes=size(indices,3);
    iAdds=zeros(nSeries,nPlanes);
    for ii=1:nPlanes
        iAdds(:,ii)=max(indices(:,1,ii))-indices(:,1,ii);
    end
    if ( nPlanes==1 && lForceTwo ), iAdds(:,2)=iAdds(:,1); end
end

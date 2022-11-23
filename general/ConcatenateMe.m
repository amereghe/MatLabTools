function [NewMatrix]=ConcatenateMe(OldMatrix,nTimes,lShift)
    if (~exist("nTimes","var")), nTimes=1; end % by default, copy only once
    if (~exist("lShift","var")), lShift=false; end % by default, do not shift values
    NewMatrix=missing();
    for iSeries=1:size(OldMatrix,2)
        MyCurrSeries=OldMatrix(~isnan(OldMatrix(:,iSeries)),iSeries);
        nVals=size(MyCurrSeries,1);
        MyNewSeries=NaN(nVals*nTimes,1);
        for iTime=1:nTimes
            if ( lShift )
                MyNewSeries((iTime-1)*nVals+1:iTime*nVals)=MyCurrSeries+MyCurrSeries(end)*(iTime-1);
            else
                MyNewSeries((iTime-1)*nVals+1:iTime*nVals)=MyCurrSeries;
            end
        end
        NewMatrix=PaddMe(MyNewSeries,NewMatrix);
    end
end

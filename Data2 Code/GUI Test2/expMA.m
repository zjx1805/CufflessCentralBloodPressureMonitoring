function []=expMA(BCGName,eventTag,mPlots)

% 10-beat exponential moving average filter for BCG signal

M=10;alpha=2/(M+1);
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
BCGsig = getappdata(mPlots.Analysis.(eventTag).Parent,[BCGName,'sig']);
BCGCopysig = getappdata(mPlots.Analysis.(eventTag).Parent,[BCGName,'Copysig']);
ECGMaxDiff=diff(ECGMaxLoc);
nInt=round(nanmedian(ECGMaxDiff)*1.2);
maxPeakIdx=length(ECGMaxLoc);
while (ECGMaxLoc(maxPeakIdx)-(startIdx-1)+nInt-1>length(BCGsig))
    maxPeakIdx = maxPeakIdx-1;
end
% disp(maxPeakIdx)
if maxPeakIdx<M
    fprintf('Error: Not enough beats for BCG exponential moving averaging!\n')
else
    for peakIdx = M:maxPeakIdx
        tempNum=0;tempDen=0;
        for beatIdx = 1:M
            start = ECGMaxLoc(peakIdx-beatIdx+1)-(startIdx-1);
            if ~isnan(start)
%                 [nInt,start,start+nInt,length(BCGsig)]
                tempBCGsig = BCGCopysig(start:start+nInt-1);
                tempAmp(beatIdx,1) = max(tempBCGsig)-min(tempBCGsig);
                isValid(beatIdx,1) = true;
            else
                tempAmp(beatIdx,1) = NaN;
                isValid(beatIdx,1) = false;
            end
        end
%         tempAmp
%         isValid
        isIncluded = double((tempAmp<=2*nanmedian(tempAmp) & isValid));
        for beatIdx = 1:M
            start = ECGMaxLoc(peakIdx-beatIdx+1)-(startIdx-1);
            if isIncluded(beatIdx,1) == 1
                tempNum=tempNum+(1-alpha)^(beatIdx-1)*BCGCopysig(start:start+nInt-1);
                tempDen=tempDen+(1-alpha)^(beatIdx-1);
            end
        end
        newstart = ECGMaxLoc(peakIdx)-(startIdx-1);
        if ~isnan(newstart)
            BCGsig(newstart:newstart+nInt-1)=tempNum/tempDen;
        end
    end
end
setappdata(mPlots.Analysis.(eventTag).Parent,[BCGName,'sig'],BCGsig)
set(mPlots.Analysis.(eventTag).(BCGName),'YData',BCGsig(currentWindowStartIdx:currentWindowEndIdx));
% fprintf([BCGName ' has been updated!\n'])
function [BCGout]=expMA(BCG,ECGMaxLoc)

M=10;alpha=2/(M+1);
BCGout=BCG;
ECGMaxDiff=diff(ECGMaxLoc);
nInt=round(nanmedian(ECGMaxDiff)*1.2);
maxPeakIdx=length(ECGMaxLoc);
while (ECGMaxLoc(maxPeakIdx)+nInt-1>length(BCG))
    maxPeakIdx = maxPeakIdx-1;
end
% disp(maxPeakIdx)
if maxPeakIdx<M
    fprintf('Error: Not enough beats!\n')
else
    for peakIdx = M:maxPeakIdx
        tempNum=0;tempDen=0;
        for beatIdx = 1:M
            if ~isnan(ECGMaxLoc(peakIdx-beatIdx+1))
                tempNum=tempNum+(1-alpha)^(beatIdx-1)*BCG(ECGMaxLoc(peakIdx-beatIdx+1):ECGMaxLoc(peakIdx-beatIdx+1)+nInt-1);
                tempDen=tempDen+(1-alpha)^(beatIdx-1);
            end
        end
        if ~isnan(ECGMaxLoc(peakIdx))
            BCGout(ECGMaxLoc(peakIdx):ECGMaxLoc(peakIdx)+nInt-1)=tempNum/tempDen;
        end
    end
end

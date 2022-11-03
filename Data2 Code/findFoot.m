function [PPGsigfoot]=findFoot(PPGsig,PPGsigMin,PPGsigMaxLoc,PPGsigMinLoc,ECGMaxLoc,startTime,fs)

PPGsigfoot=NaN(length(PPGsigMaxLoc),2);
for idx = 1:length(PPGsigMaxLoc)
    if isnan(PPGsigMaxLoc(idx))
        continue
    else
        tempTime = startTime+(PPGsigMinLoc(idx):1/fs:PPGsigMaxLoc(idx));
        tempTimeRel = PPGsigMinLoc(idx):1/fs:PPGsigMaxLoc(idx);
        PPGsigDRange = fix(tempTimeRel*fs);
        PPGsigD = diff5(PPGsig(PPGsigDRange),1,1/fs);
        [maxD,maxDLoc] = max(PPGsigD);
        xi = (-PPGsigMin(idx)-PPGsig(fix(PPGsigMinLoc(idx)*fs)+maxDLoc))/(maxD)+(startTime+PPGsigMinLoc(idx)+(maxDLoc-1)/fs);
        yi = -PPGsigMin(idx);
        if xi>ECGMaxLoc(idx)+startTime
            PPGsigfoot(idx,:)=[xi,yi];
        end
    end
end
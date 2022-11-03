function []=findFoot(signalName,eventTag,mPlots,mControls,mParams)

% Find signal foot and save them in the corresponding figure application
% data
% fprintf('Entered findFoot\n')
BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
PPGsig = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'sig']);
PPGsigMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'MaxLoc']);
PPGsigMax = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'Max']);
PPGsigMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'MinLoc']);
PPGsigMin = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'Min']);
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;
PPGsigFoot=NaN(length(BPMaxLoc),2);
fs = mParams.Constant.fs;

for ii = 1:length(BPMaxLoc)
    if isnan(PPGsigMaxLoc(ii)) || isnan(PPGsigMinLoc(ii))
        continue
    else
        PPGsigDRange = (PPGsigMinLoc(ii):PPGsigMaxLoc(ii))-(startIdx-1);
%         [length(PPGsig),PPGsigDRange(end)]
        PPGsigD = diff5(PPGsig(PPGsigDRange),1,1/fs);
        [maxD,maxDLoc] = max(PPGsigD);
        xi = (PPGsigMin(ii)-PPGsig(PPGsigMinLoc(ii)+maxDLoc-1-(startIdx-1)))/(maxD)*fs+(PPGsigMinLoc(ii)+(maxDLoc-1));
        yi = PPGsigMin(ii);
        if xi > ECGMaxLoc(ii)
            PPGsigFoot(ii,1:2) = [xi,yi];
        end
    end
end

setappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'Foot'],PPGsigFoot(:,2))
setappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'FootLoc'],PPGsigFoot(:,1))
XData = PPGsigFoot(PPGsigFoot(:,1)>currentWindowStartIdxAbs & PPGsigFoot(:,1)<currentWindowEndIdxAbs,1);
YData = PPGsigFoot(PPGsigFoot(:,1)>currentWindowStartIdxAbs & PPGsigFoot(:,1)<currentWindowEndIdxAbs,2);
set(mPlots.Analysis.(eventTag).Features.([signalName 'Foot']),'XData',(XData-1)/fs,'YData',YData)
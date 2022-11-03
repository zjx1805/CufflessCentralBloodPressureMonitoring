function []=findICGBPoint(eventTag,mPlots,mControls,mParams)

% Find the zero-crossing point of the ICGdzdt signal.

BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
ICGdzdtMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc');
ICGdzdtsig = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtsig');
ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;
ICGBpoint = NaN(length(BPMaxLoc),2);
fs = mParams.Constant.fs;

% for idx = 1:length(BPMaxLoc)
%     tempTime = (ECGMaxLoc(idx):ICGdzdtMaxLoc(idx))';
% %     tempTimeRel = (ECGMaxLoc(idx):1/fs:ICGdzdtMaxLoc(idx))';
%     if isnan(tempTime)
%         continue
%     else
%         tempIdxs = (ECGMaxLoc(idx):ICGdzdtMaxLoc(idx))-(startIdx-1);
%         [xi,yi]=polyxpoly(tempTime,zeros(size(tempTime)),tempTime,ICGdzdtsig(tempIdxs)');
%         if isempty(xi)
%             continue
%         else
%             ICGBpoint(idx,:)=[xi(end),yi(end)];
%         end
%     end
% end
for ii = 1:length(BPMaxLoc)
    if isnan(ECGMaxLoc(ii)) || isnan(ICGdzdtMaxLoc(ii))
        continue
    else
        tempIdx = (ECGMaxLoc(ii):ICGdzdtMaxLoc(ii))-(startIdx-1);
        zeroLoc = find(abs(ICGdzdtsig(tempIdx)) == min(abs(ICGdzdtsig(tempIdx))));
        ICGBpoint(ii,1:2) = [ECGMaxLoc(ii)+zeroLoc-1,ICGdzdtsig(ECGMaxLoc(ii)-(startIdx-1)+zeroLoc-1)];
    end
end

setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtBPoint',ICGBpoint(:,2))
setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtBPointLoc',ICGBpoint(:,1))
XData = ICGBpoint(ICGBpoint(:,1)>currentWindowStartIdxAbs & ICGBpoint(:,1)<currentWindowEndIdxAbs,1);
YData = ICGBpoint(ICGBpoint(:,1)>currentWindowStartIdxAbs & ICGBpoint(:,1)<currentWindowEndIdxAbs,2);
set(mPlots.Analysis.(eventTag).Features.ICGdzdtBPoint,'XData',(XData-1)/fs,'YData',YData)
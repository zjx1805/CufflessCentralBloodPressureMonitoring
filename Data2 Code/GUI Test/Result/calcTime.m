function [timeInfo]=calcTime(mResults,eventIdx,featureName,magnitudeValue,timeValue)

load ../mParams
fs = mParams.Constant.fs;
eventTag = ['Event' num2str(eventIdx)];
BPInfo = mResults.Analysis.(eventTag).([featureName 'BPInfo']);
BPMax = mResults.Analysis.(eventTag).BPMax;
BPMin = mResults.Analysis.(eventTag).BPMin;
if strcmp(featureName,'IJ') == 1
    referenceSigLoc = mResults.Analysis.(eventTag).BCGMinLoc;
    sigLoc = mResults.Analysis.(eventTag).BCGMaxLoc;
    
else
    referenceSignalName = featureName(end-2:end);
    signalName = extractBefore(featureName,referenceSignalName);
    sigLoc = mResults.Analysis.(eventTag).([signalName 'FootLoc']);
    if strcmp(referenceSignalName,'ECG') == 1
        referenceSigLoc = mResults.Analysis.(eventTag).ECGMaxLoc;
    elseif strcmp(referenceSignalName,'ICG') == 1
        referenceSigLoc = mResults.Analysis.(eventTag).ICGdzdtBPointLoc;
    elseif strcmp(referenceSignalName,'BCG') == 1
        referenceSigLoc = mResults.Analysis.(eventTag).BCGMinLoc;
    end
end
tempTime = (sigLoc-referenceSigLoc)/fs;
% length(tempTime)
if isempty(BPInfo)
    timeInfo = [];
else
    timeInfo = zeros(length(BPInfo),3);
    for ii = 1:size(BPInfo,1)
        startIdx = BPInfo(ii,1) ;
        endIdx = BPInfo(ii,2);
        idxRange = startIdx:endIdx;
        timeSeg = tempTime(startIdx:endIdx);
        [timeSorted,BPIdx] = sort(timeSeg);
        nNaN = length(timeSeg(isnan(timeSeg)));
        if length(timeSeg) - nNaN == 10
            trueRange = 3:8;
        elseif length(timeSeg) - nNaN == 9
            trueRange = 3:7;
        elseif length(timeSeg) - nNaN == 8
            trueRange = 3:6;
        elseif length(timeSeg) - nNaN == 7
            trueRange = 2:5;
        else
            trueRange = 1:10;
        end
        timeInfo(ii,1:3) = [mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),nanmean(timeSorted(trueRange))*1000];
    end
end

% minMagnitude = min(timeInfo(:,1));
% maxMagnitude = max(timeInfo(:,1));
% minTime = BPInfo(1,1);
% maxTime = BPInfo(end,1);
% mask = (timeInfo(:,1)<=minMagnitude+magnitudeValue*(maxMagnitude-minMagnitude)) & (BPInfo(:,1)<=minTime+timeValue*(maxTime-minTime));
% timeInfo = timeInfo(mask,:);
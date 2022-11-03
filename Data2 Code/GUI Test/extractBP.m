function [subjectBPInfo]=extractBP(feature1Name,feature2Name,eventTag,mPlots,mParams)

% Returns mean SP/DP in a specific window

subjectBPInfo = [];
BPMax = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMax');
BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
feature1Loc = getappdata(mPlots.Analysis.(eventTag).Parent,feature1Name);
feature2Loc = getappdata(mPlots.Analysis.(eventTag).Parent,feature2Name);
interventionIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionIdx');
currentIdx = 1;
SlidingWindowSize = mParams.Constant.SlidingWindowSize; 
while currentIdx+SlidingWindowSize-1 <= length(BPMax)
    seg = currentIdx:(currentIdx+SlidingWindowSize-1);
    mask = (isnan(feature1Loc(seg)) | isnan(feature2Loc(seg)));
    nNaN = sum(double(mask));
    if nNaN <= 3
        subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(seg)),mean(BPMin(seg)),length(seg),interventionIdx]];
    end
    currentIdx = currentIdx+1;
end



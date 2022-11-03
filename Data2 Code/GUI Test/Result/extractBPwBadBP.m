function [subjectBPInfo]=extractBPwBadBP(feature1Name,feature2Name,eventTag,subjectTag,BPmask,Features,mParams)

% Returns mean SP/DP in a specific window

subjectBPInfo = [];
BPMax = Features.(subjectTag).(eventTag).BPMax;
BPMin = Features.(subjectTag).(eventTag).BPMin;
feature1Loc =  Features.(subjectTag).(eventTag).(feature1Name);
feature2Loc = Features.(subjectTag).(eventTag).(feature2Name);
currentIdx = 1;
SlidingWindowSize = mParams.Constant.SlidingWindowSize; 
while currentIdx+SlidingWindowSize-1 <= length(BPMax)
    seg = currentIdx:(currentIdx+SlidingWindowSize-1);
    mask = (isnan(feature1Loc(seg)) | isnan(feature2Loc(seg))) | BPmask(seg);
    nNaN = sum(double(mask));
    BPseq = 1:length(BPMax);
    BPexcludedLoc = BPseq(BPmask);
    BPincludedLoc = setdiff(seg,BPexcludedLoc);
    if nNaN <= 3
        subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(BPincludedLoc)),mean(BPMin(BPincludedLoc)),length(seg)]];
    end
    currentIdx = currentIdx+1;
end



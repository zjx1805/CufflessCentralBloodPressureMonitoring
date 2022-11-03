function [BPMaxLoc,BPMax]=removeBPNexfinCalibrationPeriod(eventTag,BPMaxLoc,BPMax,mPlots,mParams)

% Remove candidate BPMax/BPMin if they are within Nexfin calibration
% process

fs = mParams.Constant.fs;
customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
BPsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BPsig');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
peakStdThreshold = customParams('peakStdThreshold');
peakStdWindowSize = customParams('peakStdWindowSize');

for ii = 1:length(BPMaxLoc)
    locRel = BPMaxLoc(ii)-(startIdx-1);
    stdleft = std(BPsig(max(1,locRel-peakStdWindowSize):locRel));
    stdright = std(BPsig(locRel:min(locRel+peakStdWindowSize,length(BPsig))));
    peakstd(ii) = min(stdleft,stdright);
end
BPMaxLoc(peakstd<peakStdThreshold)=[];
BPMax(peakstd<peakStdThreshold)=[];


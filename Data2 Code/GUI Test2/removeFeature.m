function []=removeFeature(featureName,locsToDelete,eventTag,mPlots,mControls,mParams)

% Remove selected features and corresponding features in other signals when
% one or more feature points are selected in the *Remove* mode

fs = mParams.Constant.fs;
entryCode = getappdata(mPlots.Analysis.(eventTag).Parent,'entryCode');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;

feature = getappdata(mPlots.Analysis.(eventTag).Parent,featureName);
featureLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc']);
if contains(featureName,'BP') == 1
    feature(locsToDelete) = [];
    featureLoc(locsToDelete) = [];
else
    if entryCode == 1
        feature(locsToDelete) = [];
        featureLoc(locsToDelete) = [];
    else
        feature(locsToDelete) = NaN;
        featureLoc(locsToDelete) = NaN;
    end
end
setappdata(mPlots.Analysis.(eventTag).Parent,featureName,feature)
setappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc'],featureLoc)

featureXData = featureLoc(featureLoc>currentWindowStartIdxAbs & featureLoc<currentWindowEndIdxAbs);
featureYData = feature(featureLoc>currentWindowStartIdxAbs & featureLoc<currentWindowEndIdxAbs);
set(mPlots.Analysis.(eventTag).Features.(featureName),'XData',(featureXData-1)/fs,'YData',featureYData)
function [beatsInfo]=updateFeature(featureName,eventTag,mPlots,mControls,mParams)
% Deprecated!

fs = mParams.Constant.fs;
entryCode = getappdata(mPlots.Analysis.(eventTag).Parent,'entryCode');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;

feature = getappdata(mPlots.Analysis.(eventTag).Parent,featureName);
featureLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc']);
beatsBefore = find(featureLoc>currentWindowStartIdxAbs,1)-1;
beatsBetween = length(featureLoc>currentWindowStartIdxAbs & featureLoc<currentWindowEndIdxAbs);
beatsInfo = [beatsBefore,beatsBetween];


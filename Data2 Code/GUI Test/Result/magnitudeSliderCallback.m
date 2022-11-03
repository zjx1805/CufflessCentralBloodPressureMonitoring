function []=magnitudeSliderCallback(src,cbdata,mPlots,mControls,mResults,featureNames)

% This slider sets the limit of the feature magnitude in the DP plot below
% which features will be shown.

load ../mParams
fs = mParams.Constant.fs;
eventTag = src.Parent.Tag;
eventIdx = str2double(eventTag(6:end));
magnitudeValue = src.Value;
timeValue = mControls.(eventTag).timeSlider.Value;
for ii = 1:length(featureNames)
    featureName = featureNames{ii};
    value = mControls.(eventTag).([featureName 'Box']).Value;
    if value == 1
        if ~isappdata(mControls.(eventTag).featurePanel,[featureName 'timeInfo'])
            [timeInfo]=calcTime(mResults,eventIdx,featureName,magnitudeValue,timeValue);
            setappdata(mControls.(eventTag).featurePanel,[featureName 'timeInfo'],timeInfo);
        else
            timeInfo = getappdata(mControls.(eventTag).featurePanel,[featureName 'timeInfo']);
        end
        
        
        
        if ~isempty(timeInfo)
            minMagnitude = min(timeInfo(:,2));
            maxMagnitude = max(timeInfo(:,2));
            BPInfo = mResults.Analysis.(eventTag).([featureName 'BPInfo']);
            BPMinLoc = mResults.Analysis.(eventTag).BPMinLoc;
            minTime = (BPMinLoc(BPInfo(1,1))-1)/fs;
            maxTime = (BPMinLoc(BPInfo(end,1))-1)/fs;
            allTime = (BPMinLoc(BPInfo(:,1))-1)/fs;
            currentTime = minTime+timeValue*(maxTime-minTime);
            mask = (timeInfo(:,2)<=minMagnitude+magnitudeValue*(maxMagnitude-minMagnitude)) & (allTime<=currentTime);
            timeInfo = timeInfo(mask,:);
            mControls.(eventTag).timeText.String = num2str(currentTime);
            set(mPlots.Analysis.(eventTag).([featureName 'SPTotal']),'XData',timeInfo(:,3),'YData',timeInfo(:,1))
            set(mPlots.Analysis.(eventTag).([featureName 'DPTotal']),'XData',timeInfo(:,3),'YData',timeInfo(:,2))
        end
    else
        set(mPlots.Analysis.(eventTag).([featureName 'SPTotal']),'XData',NaN,'YData',NaN)
        set(mPlots.Analysis.(eventTag).([featureName 'DPTotal']),'XData',NaN,'YData',NaN)
    end
end
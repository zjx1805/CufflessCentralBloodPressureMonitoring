function []=pairFeature(feature1Name,feature2Name,rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)

% Pair each of the feature point in feature1Name to a candidate feature in
% feature2Name

% fprintf(['Start pairing ' feature1Name ' and ' feature2Name '\n'])

customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
fs = mParams.Constant.fs;
entryCode = getappdata(mPlots.Analysis.(eventTag).Parent,'entryCode');

startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;
BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
[handleParts]=getHandle(mControls,eventTag);
selectedFeatureName = [handleParts{1},handleParts{2}];
% locsToDelete = getappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete');
% fprintf(['locsToDelte = [' num2str(locsToDelete) ']\n'])

feature1 = getappdata(mPlots.Analysis.(eventTag).Parent,feature1Name);
feature2 = getappdata(mPlots.Analysis.(eventTag).Parent,feature2Name);
feature1Loc = getappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc']);
feature2Loc = getappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc']);
feature1beatsBefore = find(feature1Loc>currentWindowStartIdxAbs,1)-1;
feature1beatsBetween = length(find(feature1Loc>currentWindowStartIdxAbs & feature1Loc<currentWindowEndIdxAbs));
feature2beatsBefore = find(feature2Loc>currentWindowStartIdxAbs,1)-1;
feature2beatsBetween = length(find(feature2Loc>currentWindowStartIdxAbs & feature2Loc<currentWindowEndIdxAbs));
beatsBefore = max(feature1beatsBefore,feature2beatsBefore);
beatsBetween = min(feature1beatsBetween,feature2beatsBetween);
% if ~isempty(beatsInfo)
%     beatsBefore = beatsInfo(1); beatsBetween = beatsInfo(2);
% end
% fprintf([feature1Name ': beatsBefore = ' num2str(feature1beatsBefore) ', beatsBetween = ' num2str(feature1beatsBetween) '\n'])
% fprintf([feature2Name ': beatsBefore = ' num2str(feature2beatsBefore) ', beatsBetween = ' num2str(feature2beatsBetween) '\n'])

% if currentWindowEndIdx-currentWindowStartIdx > 25*fs || (entryCode <= 2 && strcmp(feature1Name,'ECGMax') == 1 && contains(feature2Name,'BCG') == 1) ...
%         || getappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed') == 1
% %     fprintf('Full\n')
%     feature1LocTemp = feature1Loc; feature1Temp = feature1; feature2LocTemp = feature2Loc; feature2Temp = feature2;
% else
%     fprintf('Partial before pairing!\n')
%     feature1LocTemp = feature1Loc((beatsBefore+1):(beatsBefore+beatsBetween));
%     feature1Temp = feature1((beatsBefore+1):(beatsBefore+beatsBetween));
%     feature2LocTemp = feature2Loc((beatsBefore+1):(beatsBefore+beatsBetween));
%     feature2Temp = feature2((beatsBefore+1):(beatsBefore+beatsBetween));
%     
% %     fprintf([num2str(feature1LocTemp') '\n'])
% %     fprintf([num2str(feature2LocTemp') '\n'])
%     if size(rangeLimit,1) > 1
%         rangeLimit = rangeLimit((beatsBefore+1):(beatsBefore+beatsBetween),:);
%     end
% end

feature1LocTemp = feature1Loc; feature1Temp = feature1; feature2LocTemp = feature2Loc; feature2Temp = feature2;
% fprintf(['Before pairing, length of ' feature1Name ' is ' num2str(length(feature1Loc)) ' and length of ' feature2Name ' is ' num2str(length(feature2Loc)) '\n'])
% fprintf(['Before pairing, length of ' feature1Name ' on screen is ' num2str(length(feature1LocTemp)) ' and length of ' feature2Name ' is ' num2str(length(feature2LocTemp)) '\n'])
[feature1LocTemp,feature2LocTemp,feature1Temp,feature2Temp]=alignSignal2(feature1LocTemp,feature2LocTemp,feature1Temp,feature2Temp,round(rangeLimit*fs),isBothBP,eventTag,mPlots,feature1Name,feature2Name);
% fprintf(['After pairing, length of ' feature1Name ' on screen is ' num2str(length(feature1LocTemp)) ' and length of ' feature2Name ' is ' num2str(length(feature2LocTemp)) '\n'])

% Because max window length is 20 sec, value (25) should change if max window length changes
% if currentWindowEndIdx-currentWindowStartIdx > 25*fs || (entryCode <= 2 && strcmp(feature1Name,'ECGMax') == 1 && contains(feature2Name,'BCG') == 1) ...
%         || getappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed') == 1
% %     {entryCode,feature1Name,feature2Name}
%     setappdata(mPlots.Analysis.(eventTag).Parent,feature1Name,feature1Temp)
%     setappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc'],feature1LocTemp)
%     setappdata(mPlots.Analysis.(eventTag).Parent,feature2Name,feature2Temp)
%     setappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc'],feature2LocTemp)
% else
%     fprintf(['Partial\n'])
%     setappdata(mPlots.Analysis.(eventTag).Parent,feature1Name,[feature1(1:beatsBefore);feature1Temp;feature1((beatsBefore+beatsBetween):end)])
%     setappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc'],[feature1Loc(1:beatsBefore);feature1LocTemp;feature1Loc((beatsBefore+beatsBetween):end)])
%     setappdata(mPlots.Analysis.(eventTag).Parent,feature2Name,[feature2(1:beatsBefore);feature2Temp;feature2((beatsBefore+beatsBetween):end)])
%     setappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc'],[feature2Loc(1:beatsBefore);feature2LocTemp;feature2Loc((beatsBefore+beatsBetween):end)])
% %     fprintf([num2str(feature1LocTemp') '\n'])
% %     fprintf([num2str(feature2LocTemp') '\n'])
% end
setappdata(mPlots.Analysis.(eventTag).Parent,feature1Name,feature1Temp)
setappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc'],feature1LocTemp)
setappdata(mPlots.Analysis.(eventTag).Parent,feature2Name,feature2Temp)
setappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc'],feature2LocTemp)
if (entryCode <= 2 && entryCode >= 1 && strcmp(feature1Name,'ECGMax') == 1 && contains(feature2Name,'BCG') == 1) ...
        || getappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed') == 1
%     {entryCode,feature1Name,feature2Name}
    mask1 = (feature1LocTemp > currentWindowStartIdxAbs & feature1LocTemp < currentWindowEndIdxAbs);
    feature1LocTemp = feature1LocTemp(mask1); feature1Temp = feature1Temp(mask1); 
    mask2 = (feature2LocTemp > currentWindowStartIdxAbs & feature2LocTemp < currentWindowEndIdxAbs);
    feature2LocTemp = feature2LocTemp(mask2); feature2Temp = feature2Temp(mask2);
end

set(mPlots.Analysis.(eventTag).Features.(feature1Name),'XData',(feature1LocTemp-1)/fs,'YData',feature1Temp)
set(mPlots.Analysis.(eventTag).Features.(feature2Name),'XData',(feature2LocTemp-1)/fs,'YData',feature2Temp)
% feature1Loc = getappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc']);
% feature2Loc = getappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc']);
% fprintf(['After pairing, length of ' feature1Name ' is ' num2str(length(getappdata(mPlots.Analysis.(eventTag).Parent,[feature1Name 'Loc']))) ' and length of ' feature2Name ' is ' num2str(length(getappdata(mPlots.Analysis.(eventTag).Parent,[feature2Name 'Loc']))) '\n'])




function []=calcTime(feature1Name,feature2Name,eventTag,mPlots,mControls,mParams)

% out: [intervalTime,meanSP,meanDP,interventionIdx,startIdx,endIdx,len]
% This function calculates PTT/PAT specified by feature1Name and
% feature2Name

fs = mParams.Constant.fs;
entryCode = getappdata(mPlots.Result.Parent,'entryCode');
skipCalculation = getappdata(mPlots.Result.Parent,'skipCalculation');
skipFeature = getappdata(mPlots.Result.Parent,'skipFeature');
currentBPWindowSource = getappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowSource');
currentBPWindowReference = getappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowReference');
BPMax = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMax');
BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
SlidingWindowSize = mParams.Constant.SlidingWindowSize;
feature1Loc = getappdata(mPlots.Analysis.(eventTag).Parent,feature1Name);
feature2Loc = getappdata(mPlots.Analysis.(eventTag).Parent,feature2Name);
interventionIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionIdx');
interventionName = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionName');
if contains(feature2Name,'BCG') == 1
    sig2Name = 'BCG';
elseif contains(feature2Name,'PPGfinger') == 1
    sig2Name = 'PPGfinger';
elseif contains(feature2Name,'PPGear') == 1
    sig2Name = 'PPGear';
elseif contains(feature2Name,'PPGfeet') == 1
    sig2Name = 'PPGfeet';
elseif contains(feature2Name,'PPGtoe') == 1
    sig2Name = 'PPGtoe';
end
sig1Name = feature1Name(1:3);
sigSliderLoc = round(mControls.Adjust.(eventTag).([sig2Name 'Slider']).Value);

% fprintf([sig1Name '/' sig2Name '/' currentBPWindowReference '/' currentBPWindowSource '\n'])

if isempty(feature1Loc) || isempty(feature2Loc)
    out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
    BPInfo = [];
else
    intervalTime = (feature2Loc-feature1Loc)/fs;
%     BPInfo = extractBP(feature1Name,feature2Name,eventTag,mPlots,mParams); % BPInfo: [startIdx,endIdx,meanSP,meanDP,len,interventionIdx]
%     if contains(feature2Name,'PPG') == 1
%         setappdata(mPlots.Analysis.(eventTag).Parent,[extractBefore(feature2Name,'FootLoc') feature1Name(1:3) 'BPInfo'],BPInfo)
%     else
%         setappdata(mPlots.Analysis.(eventTag).Parent,'IJBPInfo',BPInfo)
%     end
    if (skipCalculation == 0 && skipFeature == 0)
        BPInfo = extractBP(feature1Name,feature2Name,eventTag,mPlots,mParams); % BPInfo: [startIdx,endIdx,meanSP,meanDP,len,interventionIdx]
        if contains(feature2Name,'PPG') == 1
            setappdata(mPlots.Analysis.(eventTag).Parent,[extractBefore(feature2Name,'FootLoc') feature1Name(1:3) 'BPInfo'],BPInfo)
        else
            setappdata(mPlots.Analysis.(eventTag).Parent,'IJBPInfo',BPInfo)
        end
    elseif skipCalculation == 0 && skipFeature == 1
        if contains(feature2Name,'PPG') == 1
            BPInfo = getappdata(mPlots.Analysis.(eventTag).Parent,[extractBefore(feature2Name,'FootLoc') feature1Name(1:3) 'BPInfo']);
        else
            BPInfo = getappdata(mPlots.Analysis.(eventTag).Parent,'IJBPInfo');
        end
    end
    
    if size(BPInfo,1) <= 5
        out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
%         fprintf('BPInfo too short!\n')
        if sigSliderLoc == 0
            sigSliderLoc = 1; % avoid index error
        end
        idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
        if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
            set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
        end
    else
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
            if sigSliderLoc == 0
                [~,loc]=min(BPInfo(:,4));
                idxRange = BPInfo(loc,1):BPInfo(loc,2);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==1
                loc = 1; % as long as it is non-empty
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==0
                loc = [];
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            end
%             BPInfo
            if ~isempty(loc)
                intervalTimeTemp = intervalTime(idxRange);
                [intervalTimeSorted,BPIdx] = sort(intervalTimeTemp);
                nNaN = length(intervalTimeTemp(isnan(intervalTimeTemp)));
                if length(intervalTimeTemp) - nNaN == 10
                    trueRange = 3:8;
                elseif length(intervalTimeTemp) - nNaN == 9
                    trueRange = 3:7;
                elseif length(intervalTimeTemp) - nNaN == 8
                    trueRange = 3:6;
                elseif length(intervalTimeTemp) - nNaN == 7
                    trueRange = 2:5;
                else
                    trueRange = 1:10;
                end
                out(1,1:7)=[nanmean(intervalTimeSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),interventionIdx,idxRange([1,end]),length(idxRange)];
                if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
                    set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','g')
                end
            else
                out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
                if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
                    fprintf(['Not qualified! ' sig1Name '/' sig2Name '/' currentBPWindowReference '/' currentBPWindowSource '\n'])
                    set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
                end
            end
        else
            if sigSliderLoc == 0
                [~,loc]=max(BPInfo(:,4));
                idxRange = BPInfo(loc,1):BPInfo(loc,2);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==1
                loc = 1; % as long as it is non-empty
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==0
                loc = [];
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            end
            if ~isempty(loc)
                intervalTimeTemp = intervalTime(idxRange);
                [intervalTimeSorted,BPIdx] = sort(intervalTimeTemp);
                nNaN = length(intervalTimeTemp(isnan(intervalTimeTemp)));
                if length(intervalTimeTemp) - nNaN == 10
                    trueRange = 3:8;
                elseif length(intervalTimeTemp) - nNaN == 9
                    trueRange = 3:7;
                elseif length(intervalTimeTemp) - nNaN == 8
                    trueRange = 3:6;
                elseif length(intervalTimeTemp) - nNaN == 7
                    trueRange = 2:5;
                else
                    trueRange = 1:10;
                end
                out(1,1:7)=[nanmean(intervalTimeSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),interventionIdx,idxRange([1,end]),length(idxRange)];
                if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
                    fprintf([sig1Name '/' sig2Name ': Green\n'])
                    set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','g')
                end
            else
                out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
                if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
                    fprintf([sig1Name '/' sig2Name ': Red\n'])
                    set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
                end
            end
        end
    end
end

%% Save features
PAT = getappdata(mPlots.Result.Parent,'PAT');
PTT = getappdata(mPlots.Result.Parent,'PTT');
IJInfo = getappdata(mPlots.Result.Parent,'IJInfo');
validEventIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'validEventIdx');
if contains(feature2Name,'PPG') == 1 %% PAT/PTT
    if contains(feature1Name,{'ECGMaxLoc','ICGdzdtBPointLoc','BCGMinLoc'}) == 1
        fieldName1 = feature1Name(1:3);
    end
    if contains(feature2Name,'PPG') == 1
        fieldName2 = extractBefore(feature2Name,'FootLoc');
    end
    if strcmp(fieldName1,'ECG') == 1
%         [fieldName2,fieldName1]
%         fieldnames(PAT.([fieldName2,fieldName1]))
%         [fieldName2,fieldName1]
        PAT.([fieldName2,fieldName1]).data(validEventIdx,:) = out;
        setappdata(mPlots.Analysis.(eventTag).Parent,[fieldName2,fieldName1,'Window'],out(end-2:end-1))
    else
        PTT.([fieldName2,fieldName1]).data(validEventIdx,:) = out;
        setappdata(mPlots.Analysis.(eventTag).Parent,[fieldName2,fieldName1,'Window'],out(end-2:end-1))
    end
else %% IJInfo
    IJInfo.data(validEventIdx,:) = out;
    setappdata(mPlots.Analysis.(eventTag).Parent,'IJWindow',out(end-2:end-1))
end
setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'IJInfo',IJInfo)
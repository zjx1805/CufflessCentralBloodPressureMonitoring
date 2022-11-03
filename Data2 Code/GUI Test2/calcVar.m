function []=calcVar(feature1Name,feature2Name,BPName,eventTag,mPlots,mControls,mParams)

% out: [intervalTime,meanSP,meanDP,interventionIdx,startIdx,endIdx,len]
% This function calculates PTT/PAT specified by feature1Name and
% feature2Name

fs = mParams.Constant.fs;
% entryCode = getappdata(mPlots.Result.Parent,'entryCode');
skipCalculation = getappdata(mPlots.Result.Parent,'skipCalculation');
skipFeature = getappdata(mPlots.Result.Parent,'skipFeature');
% currentBPWindowSource = getappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowSource');
% currentBPWindowReference = getappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowReference');
BPMax = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMax');
BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
PP = BPMax-BPMin;
BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
SlidingWindowSize = mParams.Constant.SlidingWindowSize;
feature1 = getappdata(mPlots.Analysis.(eventTag).Parent,feature1Name);
feature2 = getappdata(mPlots.Analysis.(eventTag).Parent,feature2Name);
interventionIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionIdx');
interventionName = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionName');

if strcmp(BPName,'DP') == 1
    BPCol = 4;
elseif strcmp(BPName,'PP') == 1
    BPCol = 5;
else
    fprintf(['calcTime: BPName not found!\n'])
end

if strcmp(feature1Name(end-2:end),'Loc') == 1 && strcmp(feature2Name(end-2:end),'Loc') == 1
    varProperty = 'Interval';
else
    varProperty = 'Amplitude';
end

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
% sigSliderLoc = round(mControls.Adjust.(eventTag).([sig2Name 'Slider']).Value);
sigSliderLoc = 0;

% fprintf([sig1Name '/' sig2Name '/' currentBPWindowReference '/' currentBPWindowSource '\n'])

if isempty(feature1) || isempty(feature2)
    out = [NaN,NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
    BPInfo = [];
else
    var = (feature2-feature1)/fs;
    
    if contains(feature2Name,'PPG') == 1 %% PAT/PTT
        if contains(feature1Name,'ECGMaxLoc') == 1
            fieldName1 = 'ECG';
        elseif contains(feature1Name,'BCG') == 1
            fieldName1 = extractBefore(feature1Name,'WaveLoc');
            fieldName1 = fieldName1(1:end-1);
        end
        if contains(feature2Name,'PPG') == 1
            fieldName2 = extractBefore(feature2Name,'FootLoc');
        end
    else %% IJ/JK/IK
        if strcmp(varProperty,'Interval') == 1
            wave1 = feature1Name(end-7);
            wave2 = feature2Name(end-7);
            fieldName1 = extractBefore(feature1Name,'WaveLoc');
            fieldName1 = fieldName1(1:end-1);
        elseif strcmp(varProperty,'Amplitude') == 1
            wave1 = feature1Name(end-4);
            wave2 = feature2Name(end-4);
            fieldName1 = extractBefore(feature1Name,'Wave');
            fieldName1 = fieldName1(1:end-1);
        end
    end
    
    if (skipCalculation == 0 && skipFeature == 0)
        BPInfo = extractBP(feature1Name,feature2Name,eventTag,mPlots,mParams); % BPInfo: [startIdx,endIdx,meanSP,meanDP,meanPP,len,interventionIdx]
        
        if contains(feature2Name,'PPG') == 1 %% PAT/PTT
            setappdata(mPlots.Analysis.(eventTag).Parent,[BPName,fieldName2,fieldName1,'BPInfo'],BPInfo)
        else %% IJ/JK/IK
            setappdata(mPlots.Analysis.(eventTag).Parent,[wave1,wave2,BPName,fieldName1,varProperty,'BPInfo'],BPInfo)
        end
        
    elseif skipCalculation == 0 && skipFeature == 1
        if contains(feature2Name,'PPG') == 1 %% PAT/PTT
            BPInfo = getappdata(mPlots.Analysis.(eventTag).Parent,[BPName,fieldName2,fieldName1,'BPInfo']);
        else %% IJ/JK/IK
            BPInfo = getappdata(mPlots.Analysis.(eventTag).Parent,[wave1,wave2,BPName,fieldName1,varProperty,'BPInfo']);
        end
    end
    
    if size(BPInfo,1) <= 5
        out = [NaN,NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
%         fprintf('BPInfo too short!\n')
        if sigSliderLoc == 0
            sigSliderLoc = 1; % avoid index error
        end
        idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
%         if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
%             set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
%         end
    else
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
            if sigSliderLoc == 0
                [~,loc]=min(BPInfo(:,BPCol));
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
                varTemp = var(idxRange);
                [varSorted,BPIdx] = sort(varTemp);
                nNaN = length(varTemp(isnan(varTemp)));
                if length(varTemp) - nNaN == 10
                    trueRange = 3:8;
                elseif length(varTemp) - nNaN == 9
                    trueRange = 3:7;
                elseif length(varTemp) - nNaN == 8
                    trueRange = 3:6;
                elseif length(varTemp) - nNaN == 7
                    trueRange = 2:5;
                else
                    trueRange = 1:10;
                end
                out(1,1:8)=[nanmean(varSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),mean(PP(idxRange(BPIdx(trueRange)))),...
                    interventionIdx,idxRange([1,end]),length(idxRange)];
%                 if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
%                     set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','g')
%                 end
            else
                out = [NaN,NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
%                 if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
%                     fprintf(['Not qualified! ' sig1Name '/' sig2Name '/' currentBPWindowReference '/' currentBPWindowSource '\n'])
%                     set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
%                 end
            end
        else
            if sigSliderLoc == 0
                [~,loc]=max(BPInfo(:,BPCol));
                idxRange = BPInfo(loc,1):BPInfo(loc,2);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==1
                loc = 1; % as long as it is non-empty
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            elseif sigSliderLoc~=0 && any(BPInfo(:,1)==sigSliderLoc)==0
                loc = [];
                idxRange = sigSliderLoc:sigSliderLoc+(SlidingWindowSize-1);
            end
            if ~isempty(loc)
                varTemp = var(idxRange);
                [varSorted,BPIdx] = sort(varTemp);
                nNaN = length(varTemp(isnan(varTemp)));
                if length(varTemp) - nNaN == 10
                    trueRange = 3:8;
                elseif length(varTemp) - nNaN == 9
                    trueRange = 3:7;
                elseif length(varTemp) - nNaN == 8
                    trueRange = 3:6;
                elseif length(varTemp) - nNaN == 7
                    trueRange = 2:5;
                else
                    trueRange = 1:10;
                end
                out(1,1:8)=[nanmean(varSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),mean(PP(idxRange(BPIdx(trueRange)))),...
                    interventionIdx,idxRange([1,end]),length(idxRange)];
%                 if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
%                     fprintf([sig1Name '/' sig2Name ': Green\n'])
%                     set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','g')
%                 end
            else
                out = [NaN,NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
%                 if strcmp(sig2Name,currentBPWindowSource) == 1 && strcmp(sig1Name,currentBPWindowReference) == 1
%                     fprintf([sig1Name '/' sig2Name ': Red\n'])
%                     set(mPlots.Adjust.([eventTag 'CurrentWindow']),'XData',(BPMinLoc(idxRange)-1)/fs,'YData',BPMin(idxRange),'Color','r')
%                 end
            end
        end
    end
end

%% Save features
PAT = getappdata(mPlots.Result.Parent,'PAT');
PTT = getappdata(mPlots.Result.Parent,'PTT');
SIGS = getappdata(mPlots.Result.Parent,'SIGS');
validEventIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'validEventIdx');
if contains(feature2Name,'PPG') == 1 %% PAT/PTT
    if contains(feature1Name,'ECGMaxLoc') == 1
        fieldName1 = 'ECG';
    elseif contains(feature1Name,'BCG') == 1
        fieldName1 = extractBefore(feature1Name,'WaveLoc');
        fieldName1 = fieldName1(1:end-1);
    end
    if contains(feature2Name,'PPG') == 1
        fieldName2 = extractBefore(feature2Name,'FootLoc');
    end
    if strcmp(fieldName1,'ECG') == 1
        PAT.(BPName).([fieldName2,fieldName1]).data(validEventIdx,:) = out;
        setappdata(mPlots.Analysis.(eventTag).Parent,[BPName,fieldName2,fieldName1,'Window'],out(end-2:end-1))
    else
        PTT.(BPName).([fieldName2,fieldName1]).data(validEventIdx,:) = out;
        setappdata(mPlots.Analysis.(eventTag).Parent,[BPName,fieldName2,fieldName1,'Window'],out(end-2:end-1))
    end
else %% IJ/JK/IK
    if strcmp(varProperty,'Interval') == 1
        wave1 = feature1Name(end-7);
        wave2 = feature2Name(end-7);
        fieldName1 = extractBefore(feature1Name,'WaveLoc');
        fieldName1 = fieldName1(1:end-1);
    elseif strcmp(varProperty,'Amplitude') == 1
        wave1 = feature1Name(end-4);
        wave2 = feature2Name(end-4);
        fieldName1 = extractBefore(feature1Name,'Wave');
        fieldName1 = fieldName1(1:end-1);
    end
    if strcmp(varProperty,'Amplitude') == 1 && strcmp(wave1,'J') == 1 && strcmp(wave2,'K') == 1
        out(1) = -out(1); % J-K amplitude is J value - K value
    end
    SIGS.([wave1,wave2]).(BPName).(fieldName1).(varProperty).data(validEventIdx,:) = out;
    setappdata(mPlots.Analysis.(eventTag).Parent,[wave1,wave2,BPName,fieldName1,varProperty,'Window'],out(end-2:end-1))
end
setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'SIGS',SIGS)

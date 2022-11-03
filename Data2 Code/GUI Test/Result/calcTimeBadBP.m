function []=calcTime(feature1Name,feature2Name,eventTag,subjectTag,BPmask,Features,subjectTabs,mParams)

% out: [intervalTime,meanSP,meanDP,interventionIdx,startIdx,endIdx,len]
% This function calculates PTT/PAT specified by feature1Name and
% feature2Name

fs = mParams.Constant.fs;
eventIdx = str2double(extractAfter(eventTag,'Event'));
BPMax = Features.(subjectTag).(eventTag).BPMax;
BPMin = Features.(subjectTag).(eventTag).BPMin;
feature1Loc =  Features.(subjectTag).(eventTag).(feature1Name);
feature2Loc = Features.(subjectTag).(eventTag).(feature2Name);
interventionName = Features.(subjectTag).(eventTag).eventName;
if isempty(feature1Loc) || isempty(feature2Loc)
    out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
    BPInfo = [];
else
    intervalTime = (feature2Loc-feature1Loc)/fs;
    intervalTime(BPmask) = NaN;
    BPInfo = extractBPwBadBP(feature1Name,feature2Name,eventTag,subjectTag,BPmask,Features,mParams); % BPInfo: [startIdx,endIdx,meanSP,meanDP,len]
    
    if size(BPInfo,1) <= 5
        out = [NaN,NaN,NaN,NaN,NaN,0];
    else
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
            [~,loc]=min(BPInfo(:,4));
            idxRange = BPInfo(loc,1):BPInfo(loc,2);
        else
            [~,loc]=max(BPInfo(:,4));
            idxRange = BPInfo(loc,1):BPInfo(loc,2);
        end
        intervalTimeTemp = intervalTime(idxRange);
        [intervalTimeSorted,BPIdx] = sort(intervalTimeTemp);
        nNaN = length(intervalTimeTemp(isnan(intervalTimeTemp)));
        
        
        if nNaN > 3
            out = [NaN,NaN,NaN,NaN,NaN,0];
            if strcmp(subjectTag,'Subject21') && strcmp(feature1Name,'BCGMinLoc') && strcmp(feature2Name,'BCGMaxLoc')
                eventTag
            end
        else
            
            if length(intervalTimeTemp) - nNaN == 10
                trueRange = 3:8;
            elseif length(intervalTimeTemp) - nNaN == 9
                trueRange = 3:7;
            elseif length(intervalTimeTemp) - nNaN == 8
                trueRange = 3:6;
            elseif length(intervalTimeTemp) - nNaN == 7
                trueRange = 2:5;
            end
            out(1,1:6)=[nanmean(intervalTimeSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(BPMin(idxRange(BPIdx(trueRange)))),idxRange([1,end]),length(idxRange)];
        end
            
        
    end
end

%% Save features
PAT = getappdata(subjectTabs,'PAT');
PTT = getappdata(subjectTabs,'PTT');
IJ = getappdata(subjectTabs,'IJ');
if contains(feature2Name,'PPG') == 1 %% PAT/PTT
    if contains(feature1Name,{'ECGMaxLoc','ICGdzdtBPointLoc','BCGMinLoc'}) == 1
        fieldName1 = feature1Name(1:3);
    end
    if contains(feature2Name,'PPG') == 1
        fieldName2 = extractBefore(feature2Name,'FootLoc');
    end
    if strcmp(fieldName1,'ECG') == 1
        PAT.(subjectTag).([fieldName2,fieldName1]).data(eventIdx,:) = out;
    else
        PTT.(subjectTag).([fieldName2,fieldName1]).data(eventIdx,:) = out;
    end
else %% IJ
    IJ.(subjectTag).data(eventIdx,:) = out;
end
setappdata(subjectTabs,'PAT',PAT)
setappdata(subjectTabs,'PTT',PTT)
setappdata(subjectTabs,'IJ',IJ)
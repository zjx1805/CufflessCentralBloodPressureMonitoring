function [out,BPInfo]=calcTime(sigL,sigR,startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx)

% out: [intervalTime,meanSP,meanDP,interventionIdx,startIdx,endIdx,len]

method='discrete';
method='continuous';
method='fixed-length';
if isempty(sigL) || isempty(sigR)
    out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
    BPInfo = [];
else
    minLen = min(length(sigL),length(sigR));
    if isempty(startTime)
        intervalTime = sigR(1:minLen,1)-sigL(1:minLen,1);
    else
        intervalTime = sigR(1:minLen,1)-sigL(1:minLen,1)-startTime;
    end
    tempSeq = 1:minLen;
    idxSeq = tempSeq(~isnan(sigL(1:minLen,1)) & ~isnan(sigR(1:minLen,1)));
    minWindowSize = 5;
    defaultWindowSize = 10;
    [BPInfo,~]=extractBP(BPMaxLoc,sigL,sigR,BPMax,BPMin,minWindowSize,defaultWindowSize,interventionIdx,method); % BPInfo: [startIdx,endIdx,meanSP,meanDP,len,interventionIdx]
    % maxWindowLen=max(BPInfo(:,5));
    % tempSeq=1:length(subjectBPInfo);
    % linesChosen = tempSeq(BPInfo(:,5)==maxWindowLen);
%     idxSeq
%     BPInfo
    if size(BPInfo,1) <= 5
        out = [NaN,NaN,NaN,interventionIdx,NaN,NaN,0];
%         BPInfo = [];
    else
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
            [~,loc]=min(BPInfo(:,4));
%             locs = find(BPInfo(:,4)<=calcPercentile(BPInfo(:,4),10) & BPInfo(:,4)>=calcPercentile(BPInfo(:,4),5));
%             rng('shuffle'); loc = locs(randi(length(locs)));
%             loc = calcPercentile(BPInfo(:,4),[0,0],method);
            idxRange = BPInfo(loc,1):BPInfo(loc,2);
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
            out(1,1:7)=[nanmean(intervalTimeSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(-BPMin(idxRange(BPIdx(trueRange)))),interventionIdx,BPInfo(loc,1:2),length(idxRange)];
        else
            [~,loc]=max(BPInfo(:,4));
%             locs = find(BPInfo(:,4)>=calcPercentile(BPInfo(:,4),90) & BPInfo(:,4)<=calcPercentile(BPInfo(:,4),95));
%             rng('shuffle'); loc = locs(randi(length(locs)));
%             loc = calcPercentile(BPInfo(:,4),[100,100],method);
            idxRange = BPInfo(loc,1):BPInfo(loc,2);
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
            out(1,1:7)=[nanmean(intervalTimeSorted(trueRange)),mean(BPMax(idxRange(BPIdx(trueRange)))),mean(-BPMin(idxRange(BPIdx(trueRange)))),interventionIdx,BPInfo(loc,1:2),length(idxRange)];
        end
    end
end
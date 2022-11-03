function out=calcPercentile(seq,percent,method)

minPercent = percent(1);
maxPercent = percent(2);

[seqSorted,sortedIdx] = sort(seq);
minLevel = seqSorted(1)+minPercent/100*(seqSorted(end)-seqSorted(1));
maxLevel = seqSorted(1)+maxPercent/100*(seqSorted(end)-seqSorted(1));

if strcmp(method,'discrete') == 1
    if minPercent >= 50
        if maxLevel > seqSorted(end-1)
            endIdx = length(seq)-1;
            startIdx = find(seqSorted<=minLevel,1,'last');
        else
            startIdx = find(seqSorted<=minLevel,1,'last');
            endIdx = find(seqSorted<=maxLevel,1,'last');
        end
    else
        if minLevel < seqSorted(2)
            startIdx = 2;
            endIdx = find(seqSorted>=maxLevel,1,'first');
        else
            startIdx = find(seqSorted>=minLevel,1,'first');
            endIdx = find(seqSorted>=maxLevel,1,'first');
        end
    end
elseif strcmp(method,'continuous') == 1
    if minPercent >= 50
        startIdx = find(seqSorted<=minLevel,1,'last');
        endIdx = find(seqSorted<=maxLevel,1,'last');
        if endIdx-startIdx+1 < 5
            startIdx = max(1,endIdx-4);
        end
    else
        startIdx = find(seqSorted>=minLevel,1,'first');
        endIdx = find(seqSorted>=maxLevel,1,'first');
        if endIdx-startIdx+1 < 5
            endIdx = min(length(seq),startIdx+4);
        end
    end
end

linesChosen = sortedIdx(startIdx:endIdx);
stream = RandStream('mt19937ar','Seed','shuffle');
out=datasample(stream,linesChosen,1);
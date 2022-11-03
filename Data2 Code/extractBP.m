function [subjectBPInfo,windowInfo]=extractBP(BPMaxLoc,sigL,sigR,BPMax,BPMin,minWindowSize,defaultWindowSize,interventionIdx,method)

minLen = min(length(sigL),length(sigR));
tempSeq = 1:minLen;

if strcmp(method,'discrete') == 1
    idxSeq = tempSeq(~isnan(sigL(1:minLen,1)) & ~isnan(sigR(1:minLen,1)));
    windowInfo=[];
    subjectBPInfo=[];
    BPMaxLocSplited = SplitVec(idxSeq,'consecutive');
    for vecIdx = 1:length(BPMaxLocSplited)
        vecSeg = BPMaxLocSplited{vecIdx};
        vecSegLen = length(vecSeg);
        currentDefaultWindowSize = defaultWindowSize;
        if vecSegLen >= minWindowSize
            out = 0;iter=1;
            %         fprintf(['vecIdx=' num2str(vecIdx) '\n'])
            while ~(out ~= 0 || currentDefaultWindowSize<minWindowSize)
                actualWindowSize = min([vecSegLen,currentDefaultWindowSize]);
                windowInfo(length(vecSeg)-actualWindowSize+1,3,vecIdx)=0;
                for winIdx = 1:length(vecSeg)-actualWindowSize+1
                    vecSegWin = vecSeg(winIdx:winIdx+actualWindowSize-1);
                    %                 fprintf(['winIdx=' num2str(winIdx) ', actualWindowSize=' num2str(actualWindowSize) '\n'])
                    outlierIdx = vecSegWin(isoutlier2(diff(BPMaxLoc(vecSegWin))));
                    windowInfo(winIdx,1:(2+length(outlierIdx)),vecIdx)=[vecSeg([winIdx,winIdx+actualWindowSize-1]),outlierIdx];
                end
                %             windowInfo
                if any(windowInfo(1:winIdx,3,vecIdx)==0)
                    out = 1;
                else
                    currentDefaultWindowSize = currentDefaultWindowSize-1;
                end
                %             fprintf(['From ' num2str(vecSeg(1)) ' to ' num2str(vecSeg(end)) ', iter=' num2str(iter) ', windowSize=' num2str(currentDefaultWindowSize) '\n'])
                iter = iter+1;
            end
            if currentDefaultWindowSize >= minWindowSize
                rowPool = find(windowInfo(:,3,vecIdx)==0 & windowInfo(:,1,vecIdx)~=0);
                for rowIdx = 1:length(rowPool)
                    currentRow = rowPool(rowIdx);
                    startIdx=windowInfo(currentRow,1,vecIdx);endIdx=windowInfo(currentRow,2,vecIdx);
                    subjectBPInfo=[subjectBPInfo;[startIdx,endIdx,mean(BPMax(startIdx:endIdx)),mean(-BPMin(startIdx:endIdx)),endIdx-startIdx+1,interventionIdx]];
                end
            end
        end
    end
elseif strcmp(method,'continuous') == 1
    idxSeq = double(~isnan(sigL(1:minLen,1)) & ~isnan(sigR(1:minLen,1)));
    len = length(idxSeq);
    currentIdx = 1;
    currentWindowSize = defaultWindowSize;
    windowInfo=[];
    subjectBPInfo=[];
    while currentIdx+currentWindowSize-1 <= len
        out = 0;
        seg = currentIdx:(currentIdx+currentWindowSize-1);
        segNaN = idxSeq(seg);
        nNaN = currentWindowSize - sum(segNaN);
        if nNaN <= 2
            subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(seg)),mean(-BPMin(seg)),length(seg),interventionIdx]];
        else
            currentWindowSize = currentWindowSize-1;
            while currentWindowSize >= minWindowSize && out == 0
                seg = currentIdx:(currentIdx+currentWindowSize-1);
                segNaN = idxSeq(seg);
                nNaN = currentWindowSize - sum(segNaN);
                if currentWindowSize > 7
                    if nNaN <= 2
                        out = 1;
                        subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(seg)),mean(-BPMin(seg)),length(seg),interventionIdx]];
                    end
                else
                    if nNaN <= 1
                        out = 1;
                        subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(seg)),mean(-BPMin(seg)),length(seg),interventionIdx]];
                    end
                end
                currentWindowSize = currentWindowSize-1;
            end
        end
        currentIdx = currentIdx+1;
        currentWindowSize = defaultWindowSize;
    end
elseif strcmp(method,'fixed-length') == 1
    idxSeq = double(~isnan(sigL(2:minLen-1,1)) & ~isnan(sigR(2:minLen-1,1)));
    len = length(idxSeq);
    currentIdx = 2;
    currentWindowSize = defaultWindowSize;
    windowInfo=[];
    subjectBPInfo=[];
    while currentIdx+currentWindowSize-1 <= len
        seg = currentIdx:(currentIdx+currentWindowSize-1);
        segNaN = idxSeq(seg-1);
        nNaN = currentWindowSize - sum(segNaN);
        if nNaN <= 3
            subjectBPInfo = [subjectBPInfo;[seg(1),seg(end),mean(BPMax(seg)),mean(-BPMin(seg)),length(seg),interventionIdx]];
        end
        currentIdx = currentIdx+1;
        currentWindowSize = defaultWindowSize;
    end
end
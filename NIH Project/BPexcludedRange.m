function [BPexcludedRangeMatrix]=BPexcludedRange(BP,timeRange,fs,windowSize,thresholdStd,maxGapWidth,minWidth)

startIdx=ceil(timeRange(1)/(1/fs)+1);endIdx=floor(timeRange(2)/(1/fs)+1);
BPMovStd=movstd(BP,windowSize);
flatRegionCandidate=find(BPMovStd(startIdx:endIdx)<=thresholdStd)+startIdx-1;
if ~isempty(flatRegionCandidate) % If there is no Nexfin BP calibration during the specified timeRange, then return empty set []
    flatRegionCandidateDiff=diff(flatRegionCandidate);
    currentIdx=find(flatRegionCandidateDiff==1,1);BPexcludedRangeMatrix=[];
    while currentIdx<length(flatRegionCandidateDiff) || ~isempty(currentIdx)
        BPexcludedRangeMatrix=[BPexcludedRangeMatrix;[flatRegionCandidate(currentIdx),flatRegionCandidate(currentIdx+1)]];
        nextIdx=currentIdx+find(flatRegionCandidateDiff(currentIdx:end)~=1,1)-1;
        if isempty(nextIdx)
            BPexcludedRangeMatrix(end,2)=flatRegionCandidate(end);
            break
        end
        BPexcludedRangeMatrix(end,2)=flatRegionCandidate(nextIdx);
        currentIdx=nextIdx+find(flatRegionCandidateDiff(nextIdx:end)==1,1)-1;
    end
    BPexcludedRangeMatrix=(BPexcludedRangeMatrix-1)*(1/fs);
    BPexcludedRangeMatrix(BPexcludedRangeMatrix(:,2)-BPexcludedRangeMatrix(:,1)<=minWidth,:)=[];
    BPexcludedRangeMatrixNew=[];
    maxIter=200;iter=1;
    while size(BPexcludedRangeMatrix,1)~=size(BPexcludedRangeMatrixNew,1)
        if iter>maxIter
            fprintf('Too many iterations in the function BPexcludedRange(...). Please look for possible errors!\n')
            break
        end
        if iter~=1
            BPexcludedRangeMatrix=BPexcludedRangeMatrixNew;
        end
        for ii=1:size(BPexcludedRangeMatrix,1)-1
            if BPexcludedRangeMatrix(ii+1,1)-BPexcludedRangeMatrix(ii,2)<=maxGapWidth
                BPexcludedRangeMatrixNew=BPexcludedRangeMatrix;
                temp=BPexcludedRangeMatrix(ii+1,2);
                BPexcludedRangeMatrixNew(ii+1,:)=[];
                BPexcludedRangeMatrixNew(ii,2)=temp;
                break
            else
                continue
            end
        end
        iter=iter+1;
    end
    BPexcludedRangeMatrix=BPexcludedRangeMatrixNew;
else
    BPexcludedRangeMatrix=[];
end
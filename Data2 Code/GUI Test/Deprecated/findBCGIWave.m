function []=findBCGIWave(eventTag,mPlots,mParams)

% Deprecated!

fs = mParams.Constant.fs;
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;
BCGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc');
BCGMaxLocBefore = BCGMaxLoc(BCGMaxLoc<=currentWindowStartIdxAbs);
BCGMaxLocBetween = BCGMaxLoc(BCGMaxLoc>currentWindowStartIdxAbs & BCGMaxLoc<currentWindowEndIdxAbs);
BCGMaxLocAfter = BCGMaxLoc(BCGMaxLoc>=currentWindowEndIdxAbs);
beatsBefore = length(BCGMaxLocBefore);
beatsBetween = length(BCGMaxLocBetween);
beatsAfter = length(BCGMaxLocAfter);
BCGMinLocTemp = NaN(size(BCGMaxLocBetween));
BCGMinTemp = NaN(size(BCGMaxLocBetween));

for ii = 1:beatsBetween
    if ~isnan(BCGMaxLocBetween(ii))
        tempStart = %% Not Completed!

BCGMinLoc=NaN(size(BCGMaxLoc));BCGMin=NaN(size(BCGMaxLoc));
tempExclude=[];
for ii = 1:min(length(ECGMaxLoc),length(BCGMaxLoc))
    if ~isnan(BCGMaxLoc(ii)) && BCGMaxLoc(ii)-ECGMaxLoc(ii)>20/fs
        tempStart=max([round(BCGMaxLoc(ii)*fs-0.25*fs)+1,round(ECGMaxLoc(ii)*fs)]);tempEnd=round(BCGMaxLoc(ii)*fs)+1;
        if tempEnd-tempStart+1 <= 10
            minLoc = [];
        else
            [~,minLocs]=findpeaks(-BCGsig(tempStart:tempEnd),'MinPeakHeight',-2,'MinPeakDistance',0.01,'MinPeakProminence',minPeakProminenceBCGMin);
            if isempty(minLocs)
                minLoc = [];
            else
                minLoc = minLocs(end);
            end
        end
        if isempty(minLoc) || minLoc <= 10
            %                     if isempty(minLoc)
            %                         fprintf(['ii=' num2str(ii) ', start=' num2str(tempStart/fs+startTime) ', end =' num2str(tempEnd/fs+startTime) ', minLoc is empty!\n'])
            %                     else
            %                         fprintf(['ii=' num2str(ii) ', start=' num2str(tempStart/fs+startTime) ', end =' num2str(tempEnd/fs+startTime) ', minLoc=' num2str(minLoc) '\n'])
            %                     end
            tempExclude = [tempExclude,ii];
        else
            BCGMinLoc(ii)=(tempStart+minLoc-1)/fs;BCGMin(ii)=BCGsig(tempStart+minLoc-1);
        end
    end
end
BCGMaxLoc(tempExclude)=NaN;BCGMax(tempExclude)=NaN;
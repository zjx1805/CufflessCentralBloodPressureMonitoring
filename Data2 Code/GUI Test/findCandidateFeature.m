function []=findCandidateFeature(signal,signalName,isForBCG,eventTag,mPlots,mParams)

% Find candidate features for different signals. Parameters used in the
% findpeaks() funciton are obtained from mParams.

customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
entryCode = getappdata(mPlots.Analysis.(eventTag).Parent,'entryCode');
% fprintf(['Start finding features for ' signalName ' with entryCode: ' num2str(entryCode) '\n'])

fs = mParams.Constant.fs;
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
signalUsed = signal(currentWindowStartIdx:currentWindowEndIdx);
% if isForBCG %% When BP/ECG changes, entire BCG changes
%     signalUsed = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig');
% end
currentWindowStartIdxAbs = startIdx+currentWindowStartIdx-1; currentWindowEndIdxAbs = startIdx+currentWindowEndIdx-1;

if strcmp(signalName,'BP') == 1
    minPeakHeightBPMax = customParams('minPeakHeightBPMax'); minPeakDistBPMax = customParams('minPeakDistBPMax'); minPeakProminenceBPMax = customParams('minPeakProminenceBPMax');
    minPeakHeightBPMin = customParams('minPeakHeightBPMin'); minPeakDistBPMin = customParams('minPeakDistBPMin'); minPeakProminenceBPMin = customParams('minPeakProminenceBPMin');
    [BPMaxTemp,BPMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBPMax,'MinPeakDistance',minPeakDistBPMax*fs,'MinPeakProminence',minPeakProminenceBPMax);
    [BPMinTemp,BPMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBPMin,'MinPeakDistance',minPeakDistBPMin*fs,'MinPeakProminence',minPeakProminenceBPMin);
    BPMinTemp=-BPMinTemp;BPMaxLocTemp=startIdx+currentWindowStartIdx-1+(BPMaxLocTemp-1);BPMinLocTemp=startIdx+currentWindowStartIdx-1+(BPMinLocTemp-1);
    [BPMaxLocTemp,BPMaxTemp]=removeBPNexfinCalibrationPeriod(eventTag,BPMaxLocTemp,BPMaxTemp,mPlots,mParams);
    set(mPlots.Analysis.(eventTag).Features.BPMax,'XData',(BPMaxLocTemp-1)/fs,'YData',BPMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.BPMin,'XData',(BPMinLocTemp-1)/fs,'YData',BPMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc',BPMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMax',BPMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc',BPMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMin',BPMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        BPMax = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMax');
        BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
        BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
        beatsMaxBefore = find(BPMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(BPMaxLoc>currentWindowStartIdxAbs & BPMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(BPMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(BPMinLoc>currentWindowStartIdxAbs & BPMinLoc<currentWindowEndIdxAbs));
%         fprintf(['BPMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(BPMaxLocTemp)) '\n'])
%         fprintf(['BPMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(BPMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc',[BPMaxLoc(1:beatsMaxBefore);BPMaxLocTemp;BPMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMax',[BPMax(1:beatsMaxBefore);BPMaxTemp;BPMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc',[BPMinLoc(1:beatsMinBefore);BPMinLocTemp;BPMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMin',[BPMin(1:beatsMinBefore);BPMinTemp;BPMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLocOld',BPMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxOld',BPMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLocOld',BPMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPMinOld',BPMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(BPMaxLocTemp),length(BPMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(BPMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'ECG') == 1
    minPeakDistECG = customParams('minPeakDistECG'); minPeakProminenceECG = customParams('minPeakProminenceECG');
    minPeakHeightECG = customParams('minPeakHeightECG');
    [ECGMaxTemp,ECGMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightECG,'MinPeakDistance',minPeakDistECG*fs,'MinPeakProminence',minPeakProminenceECG);
    ECGMaxLocTemp=startIdx+currentWindowStartIdx-1+(ECGMaxLocTemp-1);
    set(mPlots.Analysis.(eventTag).Features.ECGMax,'XData',(ECGMaxLocTemp-1)/fs,'YData',ECGMaxTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc',ECGMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMax',ECGMaxTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
        ECGMax = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMax');
        beatsMaxBefore = find(ECGMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(ECGMaxLoc>currentWindowStartIdxAbs & ECGMaxLoc<currentWindowEndIdxAbs));
%         fprintf(['ECGMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(ECGMaxLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc',[ECGMaxLoc(1:beatsMaxBefore);ECGMaxLocTemp;ECGMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMax',[ECGMax(1:beatsMaxBefore);ECGMaxTemp;ECGMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLocOld',ECGMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxOld',ECGMax);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',beatsMaxBefore);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',beatsMaxBetween);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',length(ECGMaxLocTemp));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(ECGMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'ICGdzdt') == 1
    minPeakDistICGdzdt = customParams('minPeakDistICGdzdt'); minPeakProminenceICGdzdt = customParams('minPeakProminenceICGdzdt');
    minPeakHeightICGdzdt = customParams('minPeakHeightICGdzdt');
    [ICGdzdtMaxTemp,ICGdzdtMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightICGdzdt,'MinPeakDistance',minPeakDistICGdzdt*fs,'MinPeakProminence',minPeakProminenceICGdzdt);
    if isempty(ICGdzdtMaxLocTemp) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        ICGdzdtMaxLocTemp = NaN(size(BPMaxLoc)); ICGdzdtMaxTemp = NaN(size(BPMaxLoc));
    else
        ICGdzdtMaxLocTemp=startIdx+currentWindowStartIdx-1+(ICGdzdtMaxLocTemp-1);
    end
    set(mPlots.Analysis.(eventTag).Features.ICGdzdtMax,'XData',(ICGdzdtMaxLocTemp-1)/fs,'YData',ICGdzdtMaxTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc',ICGdzdtMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMax',ICGdzdtMaxTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        ICGdzdtMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc');
        ICGdzdtMax = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMax');
        beatsMaxBefore = find(ICGdzdtMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(ICGdzdtMaxLoc>currentWindowStartIdxAbs & ICGdzdtMaxLoc<currentWindowEndIdxAbs));
%         fprintf(['ICGdzdtMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(ICGdzdtMaxLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLoc',[ICGdzdtMaxLoc(1:beatsMaxBefore);ICGdzdtMaxLocTemp;ICGdzdtMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)])
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMax',[ICGdzdtMax(1:beatsMaxBefore);ICGdzdtMaxTemp;ICGdzdtMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxLocOld',ICGdzdtMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtMaxOld',ICGdzdtMax);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',beatsMaxBefore);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',beatsMaxBetween);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',length(ICGdzdtMaxLocTemp));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(ICGdzdtMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'BCG') == 1
    if isForBCG %% When BP/ECG changes, entire BCG changes
        signalUsed = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig');
    end
    minPeakDistBCGMax = customParams('minPeakDistBCGMax'); minPeakProminenceBCGMax = customParams('minPeakProminenceBCGMax');
    minPeakDistBCGMin = customParams('minPeakDistBCGMin'); minPeakProminenceBCGMin = customParams('minPeakProminenceBCGMin');
    minPeakHeightBCGMax = customParams('minPeakHeightBCGMax'); minPeakHeightBCGMin = customParams('minPeakHeightBCGMin');
    [BCGMaxTemp,BCGMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGMax,'MinPeakDistance',minPeakDistBCGMax*fs,'MinPeakProminence',minPeakProminenceBCGMax);
    [BCGMinTemp,BCGMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBCGMin,'MinPeakDistance',minPeakDistBCGMin*fs,'MinPeakProminence',minPeakProminenceBCGMin);
    BCGMinTemp = -BCGMinTemp;
    if (isempty(BCGMaxLocTemp) || isempty(BCGMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        BCGMaxLocTemp=NaN(size(BPMaxLoc)); BCGMaxTemp=NaN(size(BPMaxLoc)); BCGMinLocTemp=NaN(size(BPMaxLoc)); BCGMinTemp=NaN(size(BPMaxLoc));
    else
        if isForBCG
            BCGMaxLocTemp=startIdx+(BCGMaxLocTemp-1); BCGMinLocTemp=startIdx+(BCGMinLocTemp-1);
        else
            BCGMaxLocTemp=startIdx+currentWindowStartIdx-1+(BCGMaxLocTemp-1); BCGMinLocTemp=startIdx+currentWindowStartIdx-1+(BCGMinLocTemp-1);
        end
    end
    if isForBCG
        mask1 = (BCGMaxLocTemp>currentWindowStartIdxAbs & BCGMaxLocTemp<currentWindowEndIdxAbs);
        mask2 = (BCGMinLocTemp>currentWindowStartIdxAbs & BCGMinLocTemp<currentWindowEndIdxAbs);
        set(mPlots.Analysis.(eventTag).Features.BCGMax,'XData',(BCGMaxLocTemp(mask1)-1)/fs,'YData',BCGMaxTemp(mask1))
        set(mPlots.Analysis.(eventTag).Features.BCGMin,'XData',(BCGMinLocTemp(mask2)-1)/fs,'YData',BCGMinTemp(mask2))
    else
        set(mPlots.Analysis.(eventTag).Features.BCGMax,'XData',(BCGMaxLocTemp-1)/fs,'YData',BCGMaxTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGMin,'XData',(BCGMinLocTemp-1)/fs,'YData',BCGMinTemp)
    end
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc') || isForBCG
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc',BCGMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMax',BCGMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinLoc',BCGMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMin',BCGMinTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLocOld',BCGMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxOld',BCGMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinLocOld',BCGMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinOld',BCGMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        BCGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc');
        BCGMax = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGMax');
        BCGMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinLoc');
        BCGMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGMin');
        beatsMaxBefore = find(BCGMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(BCGMaxLoc>currentWindowStartIdxAbs & BCGMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(BCGMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(BCGMinLoc>currentWindowStartIdxAbs & BCGMinLoc<currentWindowEndIdxAbs));
%         fprintf(['BCGMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(BCGMaxLocTemp)) '\n'])
%         fprintf(['BCGMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(BCGMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLoc',[BCGMaxLoc(1:beatsMaxBefore);BCGMaxLocTemp;BCGMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMax',[BCGMax(1:beatsMaxBefore);BCGMaxTemp;BCGMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinLoc',[BCGMinLoc(1:beatsMinBefore);BCGMinLocTemp;BCGMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMin',[BCGMin(1:beatsMinBefore);BCGMinTemp;BCGMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxLocOld',BCGMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMaxOld',BCGMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinLocOld',BCGMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGMinOld',BCGMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(BCGMaxLocTemp),length(BCGMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(BCGMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'PPGfinger') == 1
    minPeakDistPPGfingerMax = customParams('minPeakDistPPGfingerMax'); minPeakProminencePPGfingerMax = customParams('minPeakProminencePPGfingerMax');
    minPeakDistPPGfingerMin = customParams('minPeakDistPPGfingerMin'); minPeakProminencePPGfingerMin = customParams('minPeakProminencePPGfingerMin');
    minPeakHeightPPGfingerMax = customParams('minPeakHeightPPGfingerMax'); minPeakHeightPPGfingerMin = customParams('minPeakHeightPPGfingerMin');
    [PPGfingerMaxTemp,PPGfingerMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightPPGfingerMax,'MinPeakDistance',minPeakDistPPGfingerMax*fs,'MinPeakProminence',minPeakProminencePPGfingerMax);
    [PPGfingerMinTemp,PPGfingerMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightPPGfingerMin,'MinPeakDistance',minPeakDistPPGfingerMin*fs,'MinPeakProminence',minPeakProminencePPGfingerMin);
    if (isempty(PPGfingerMaxLocTemp) || isempty(PPGfingerMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        PPGfingerMaxLocTemp=NaN(size(BPMaxLoc)); PPGfingerMaxTemp=NaN(size(BPMaxLoc)); PPGfingerMinLocTemp=NaN(size(BPMaxLoc)); PPGfingerMinTemp=NaN(size(BPMaxLoc));
    else
        PPGfingerMaxLocTemp=startIdx+currentWindowStartIdx-1+(PPGfingerMaxLocTemp-1); PPGfingerMinLocTemp=startIdx+currentWindowStartIdx-1+(PPGfingerMinLocTemp-1); 
        PPGfingerMinTemp = -PPGfingerMinTemp;
    end
    set(mPlots.Analysis.(eventTag).Features.PPGfingerMax,'XData',(PPGfingerMaxLocTemp-1)/fs,'YData',PPGfingerMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.PPGfingerMin,'XData',(PPGfingerMinLocTemp-1)/fs,'YData',PPGfingerMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLoc',PPGfingerMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMax',PPGfingerMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMinLoc',PPGfingerMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMin',PPGfingerMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        PPGfingerMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLoc');
        PPGfingerMax = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMax');
        PPGfingerMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMinLoc');
        PPGfingerMin = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMin');
        beatsMaxBefore = find(PPGfingerMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(PPGfingerMaxLoc>currentWindowStartIdxAbs & PPGfingerMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(PPGfingerMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(PPGfingerMinLoc>currentWindowStartIdxAbs & PPGfingerMinLoc<currentWindowEndIdxAbs));
%         fprintf(['PPGfingerMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(PPGfingerMaxLocTemp)) '\n'])
%         fprintf(['PPGfingerMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(PPGfingerMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLoc',[PPGfingerMaxLoc(1:beatsMaxBefore);PPGfingerMaxLocTemp;PPGfingerMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMax',[PPGfingerMax(1:beatsMaxBefore);PPGfingerMaxTemp;PPGfingerMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMinLoc',[PPGfingerMinLoc(1:beatsMinBefore);PPGfingerMinLocTemp;PPGfingerMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMin',[PPGfingerMin(1:beatsMinBefore);PPGfingerMinTemp;PPGfingerMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxLocOld',PPGfingerMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMaxOld',PPGfingerMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMinLocOld',PPGfingerMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingerMinOld',PPGfingerMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(PPGfingerMaxLocTemp),length(PPGfingerMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(PPGfingerMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'PPGear') == 1
    minPeakDistPPGearMax = customParams('minPeakDistPPGearMax'); minPeakProminencePPGearMax = customParams('minPeakProminencePPGearMax');
    minPeakDistPPGearMin = customParams('minPeakDistPPGearMin'); minPeakProminencePPGearMin = customParams('minPeakProminencePPGearMin');
    minPeakHeightPPGearMax = customParams('minPeakHeightPPGearMax'); minPeakHeightPPGearMin = customParams('minPeakHeightPPGearMin');
    [PPGearMaxTemp,PPGearMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightPPGearMax,'MinPeakDistance',minPeakDistPPGearMax*fs,'MinPeakProminence',minPeakProminencePPGearMax);
    [PPGearMinTemp,PPGearMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightPPGearMin,'MinPeakDistance',minPeakDistPPGearMin*fs,'MinPeakProminence',minPeakProminencePPGearMin);
    if (isempty(PPGearMaxLocTemp) || isempty(PPGearMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        PPGearMaxLocTemp=NaN(size(BPMaxLoc)); PPGearMaxTemp=NaN(size(BPMaxLoc)); PPGearMinLocTemp=NaN(size(BPMaxLoc)); PPGearMinTemp=NaN(size(BPMaxLoc));
    else
        PPGearMaxLocTemp=startIdx+currentWindowStartIdx-1+(PPGearMaxLocTemp-1); PPGearMinLocTemp=startIdx+currentWindowStartIdx-1+(PPGearMinLocTemp-1); 
        PPGearMinTemp = -PPGearMinTemp;
    end
    set(mPlots.Analysis.(eventTag).Features.PPGearMax,'XData',(PPGearMaxLocTemp-1)/fs,'YData',PPGearMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.PPGearMin,'XData',(PPGearMinLocTemp-1)/fs,'YData',PPGearMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLoc',PPGearMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMax',PPGearMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMinLoc',PPGearMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMin',PPGearMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        PPGearMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLoc');
        PPGearMax = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMax');
        PPGearMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMinLoc');
        PPGearMin = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMin');
        beatsMaxBefore = find(PPGearMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(PPGearMaxLoc>currentWindowStartIdxAbs & PPGearMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(PPGearMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(PPGearMinLoc>currentWindowStartIdxAbs & PPGearMinLoc<currentWindowEndIdxAbs));
%         fprintf(['PPGearMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(PPGearMaxLocTemp)) '\n'])
%         fprintf(['PPGearMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(PPGearMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLoc',[PPGearMaxLoc(1:beatsMaxBefore);PPGearMaxLocTemp;PPGearMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMax',[PPGearMax(1:beatsMaxBefore);PPGearMaxTemp;PPGearMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMinLoc',[PPGearMinLoc(1:beatsMinBefore);PPGearMinLocTemp;PPGearMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMin',[PPGearMin(1:beatsMinBefore);PPGearMinTemp;PPGearMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxLocOld',PPGearMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMaxOld',PPGearMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMinLocOld',PPGearMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearMinOld',PPGearMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(PPGearMaxLocTemp),length(PPGearMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(PPGearMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'PPGfeet') == 1
    minPeakDistPPGfeetMax = customParams('minPeakDistPPGfeetMax'); minPeakProminencePPGfeetMax = customParams('minPeakProminencePPGfeetMax');
    minPeakDistPPGfeetMin = customParams('minPeakDistPPGfeetMin'); minPeakProminencePPGfeetMin = customParams('minPeakProminencePPGfeetMin');
    minPeakHeightPPGfeetMax = customParams('minPeakHeightPPGfeetMax'); minPeakHeightPPGfeetMin = customParams('minPeakHeightPPGfeetMin');
    [PPGfeetMaxTemp,PPGfeetMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightPPGfeetMax,'MinPeakDistance',minPeakDistPPGfeetMax*fs,'MinPeakProminence',minPeakProminencePPGfeetMax);
    [PPGfeetMinTemp,PPGfeetMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightPPGfeetMin,'MinPeakDistance',minPeakDistPPGfeetMin*fs,'MinPeakProminence',minPeakProminencePPGfeetMin);
    if (isempty(PPGfeetMaxLocTemp) || isempty(PPGfeetMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        PPGfeetMaxLocTemp=NaN(size(BPMaxLoc)); PPGfeetMaxTemp=NaN(size(BPMaxLoc)); PPGfeetMinLocTemp=NaN(size(BPMaxLoc)); PPGfeetMinTemp=NaN(size(BPMaxLoc));
    else
        PPGfeetMaxLocTemp=startIdx+currentWindowStartIdx-1+(PPGfeetMaxLocTemp-1); PPGfeetMinLocTemp=startIdx+currentWindowStartIdx-1+(PPGfeetMinLocTemp-1); 
        PPGfeetMinTemp = -PPGfeetMinTemp;
    end
    set(mPlots.Analysis.(eventTag).Features.PPGfeetMax,'XData',(PPGfeetMaxLocTemp-1)/fs,'YData',PPGfeetMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.PPGfeetMin,'XData',(PPGfeetMinLocTemp-1)/fs,'YData',PPGfeetMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLoc',PPGfeetMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMax',PPGfeetMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMinLoc',PPGfeetMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMin',PPGfeetMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        PPGfeetMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLoc');
        PPGfeetMax = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMax');
        PPGfeetMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMinLoc');
        PPGfeetMin = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMin');
        beatsMaxBefore = find(PPGfeetMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(PPGfeetMaxLoc>currentWindowStartIdxAbs & PPGfeetMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(PPGfeetMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(PPGfeetMinLoc>currentWindowStartIdxAbs & PPGfeetMinLoc<currentWindowEndIdxAbs));
%         fprintf(['PPGfeetMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(PPGfeetMaxLocTemp)) '\n'])
%         fprintf(['PPGfeetMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(PPGfeetMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLoc',[PPGfeetMaxLoc(1:beatsMaxBefore);PPGfeetMaxLocTemp;PPGfeetMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMax',[PPGfeetMax(1:beatsMaxBefore);PPGfeetMaxTemp;PPGfeetMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMinLoc',[PPGfeetMinLoc(1:beatsMinBefore);PPGfeetMinLocTemp;PPGfeetMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMin',[PPGfeetMin(1:beatsMinBefore);PPGfeetMinTemp;PPGfeetMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxLocOld',PPGfeetMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMaxOld',PPGfeetMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMinLocOld',PPGfeetMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetMinOld',PPGfeetMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(PPGfeetMaxLocTemp),length(PPGfeetMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(PPGfeetMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
elseif strcmp(signalName,'PPGtoe') == 1
    minPeakDistPPGtoeMax = customParams('minPeakDistPPGtoeMax'); minPeakProminencePPGtoeMax = customParams('minPeakProminencePPGtoeMax');
    minPeakDistPPGtoeMin = customParams('minPeakDistPPGtoeMin'); minPeakProminencePPGtoeMin = customParams('minPeakProminencePPGtoeMin');
    minPeakHeightPPGtoeMax = customParams('minPeakHeightPPGtoeMax'); minPeakHeightPPGtoeMin = customParams('minPeakHeightPPGtoeMin');
    [PPGtoeMaxTemp,PPGtoeMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightPPGtoeMax,'MinPeakDistance',minPeakDistPPGtoeMax*fs,'MinPeakProminence',minPeakProminencePPGtoeMax);
    [PPGtoeMinTemp,PPGtoeMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightPPGtoeMin,'MinPeakDistance',minPeakDistPPGtoeMin*fs,'MinPeakProminence',minPeakProminencePPGtoeMin);
    if (isempty(PPGtoeMaxLocTemp) || isempty(PPGtoeMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        PPGtoeMaxLocTemp=NaN(size(BPMaxLoc)); PPGtoeMaxTemp=NaN(size(BPMaxLoc)); PPGtoeMinLocTemp=NaN(size(BPMaxLoc)); PPGtoeMinTemp=NaN(size(BPMaxLoc));
    else
        PPGtoeMaxLocTemp=startIdx+currentWindowStartIdx-1+(PPGtoeMaxLocTemp-1); PPGtoeMinLocTemp=startIdx+currentWindowStartIdx-1+(PPGtoeMinLocTemp-1); 
        PPGtoeMinTemp = -PPGtoeMinTemp;
    end
    set(mPlots.Analysis.(eventTag).Features.PPGtoeMax,'XData',(PPGtoeMaxLocTemp-1)/fs,'YData',PPGtoeMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.PPGtoeMin,'XData',(PPGtoeMinLocTemp-1)/fs,'YData',PPGtoeMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLoc',PPGtoeMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMax',PPGtoeMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMinLoc',PPGtoeMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMin',PPGtoeMinTemp);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',0);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',Inf);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',0);
    else
        PPGtoeMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLoc');
        PPGtoeMax = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMax');
        PPGtoeMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMinLoc');
        PPGtoeMin = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMin');
        beatsMaxBefore = find(PPGtoeMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(PPGtoeMaxLoc>currentWindowStartIdxAbs & PPGtoeMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(PPGtoeMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(PPGtoeMinLoc>currentWindowStartIdxAbs & PPGtoeMinLoc<currentWindowEndIdxAbs));
%         fprintf(['PPGtoeMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(PPGtoeMaxLocTemp)) '\n'])
%         fprintf(['PPGtoeMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(PPGtoeMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLoc',[PPGtoeMaxLoc(1:beatsMaxBefore);PPGtoeMaxLocTemp;PPGtoeMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMax',[PPGtoeMax(1:beatsMaxBefore);PPGtoeMaxTemp;PPGtoeMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMinLoc',[PPGtoeMinLoc(1:beatsMinBefore);PPGtoeMinLocTemp;PPGtoeMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMin',[PPGtoeMin(1:beatsMinBefore);PPGtoeMinTemp;PPGtoeMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxLocOld',PPGtoeMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMaxOld',PPGtoeMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMinLocOld',PPGtoeMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoeMinOld',PPGtoeMin);
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBefore',min(beatsMaxBefore,beatsMinBefore));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsBetween',max(beatsMaxBetween,beatsMinBetween));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAdded',max(length(PPGtoeMaxLocTemp),length(PPGtoeMinLocTemp)));
%         setappdata(mPlots.Analysis.(eventTag).Parent,'beatsAfter',length(PPGtoeMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)));
    end
end

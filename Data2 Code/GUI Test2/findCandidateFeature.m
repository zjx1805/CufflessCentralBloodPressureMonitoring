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
    end
elseif strcmp(signalName,'BCGScale') == 1
    if isForBCG %% When BP/ECG changes, entire BCG changes
        signalUsed = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScalesig');
    end
    minPeakDistBCGScaleH = customParams('minPeakDistBCGScaleH'); minPeakProminenceBCGScaleH = customParams('minPeakProminenceBCGScaleH');
    minPeakDistBCGScaleI = customParams('minPeakDistBCGScaleI'); minPeakProminenceBCGScaleI = customParams('minPeakProminenceBCGScaleI');
    minPeakDistBCGScaleJ = customParams('minPeakDistBCGScaleJ'); minPeakProminenceBCGScaleJ = customParams('minPeakProminenceBCGScaleJ');
    minPeakDistBCGScaleK = customParams('minPeakDistBCGScaleK'); minPeakProminenceBCGScaleK = customParams('minPeakProminenceBCGScaleK');
    minPeakDistBCGScaleL = customParams('minPeakDistBCGScaleL'); minPeakProminenceBCGScaleL = customParams('minPeakProminenceBCGScaleL');
    minPeakHeightBCGScaleH = customParams('minPeakHeightBCGScaleH'); minPeakHeightBCGScaleI = customParams('minPeakHeightBCGScaleI');
    minPeakHeightBCGScaleJ = customParams('minPeakHeightBCGScaleJ'); minPeakHeightBCGScaleK = customParams('minPeakHeightBCGScaleK');
    minPeakHeightBCGScaleL = customParams('minPeakHeightBCGScaleL'); 
    [BCGScaleHTemp,BCGScaleHLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGScaleH,'MinPeakDistance',minPeakDistBCGScaleH*fs,'MinPeakProminence',minPeakProminenceBCGScaleH);
    [BCGScaleITemp,BCGScaleILocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBCGScaleI,'MinPeakDistance',minPeakDistBCGScaleI*fs,'MinPeakProminence',minPeakProminenceBCGScaleI);
    [BCGScaleJTemp,BCGScaleJLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGScaleJ,'MinPeakDistance',minPeakDistBCGScaleJ*fs,'MinPeakProminence',minPeakProminenceBCGScaleJ);
    [BCGScaleKTemp,BCGScaleKLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBCGScaleK,'MinPeakDistance',minPeakDistBCGScaleK*fs,'MinPeakProminence',minPeakProminenceBCGScaleK);
    [BCGScaleLTemp,BCGScaleLLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGScaleL,'MinPeakDistance',minPeakDistBCGScaleL*fs,'MinPeakProminence',minPeakProminenceBCGScaleL);
    BCGScaleITemp = -BCGScaleITemp; BCGScaleKTemp = -BCGScaleKTemp;
    if (isempty(BCGScaleHLocTemp) || isempty(BCGScaleILocTemp) || isempty(BCGScaleJLocTemp) || isempty(BCGScaleKLocTemp) || isempty(BCGScaleLLocTemp)) && ...
            ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        if isempty(BCGScaleILocTemp) || isempty(BCGScaleJLocTemp)
            BCGScaleHLocTemp=NaN(size(BPMaxLoc)); BCGScaleHTemp=NaN(size(BPMaxLoc)); BCGScaleILocTemp=NaN(size(BPMaxLoc)); BCGScaleITemp=NaN(size(BPMaxLoc));
            BCGScaleJLocTemp=NaN(size(BPMaxLoc)); BCGScaleJTemp=NaN(size(BPMaxLoc)); BCGScaleKLocTemp=NaN(size(BPMaxLoc)); BCGScaleKTemp=NaN(size(BPMaxLoc));
            BCGScaleLLocTemp=NaN(size(BPMaxLoc)); BCGScaleLTemp=NaN(size(BPMaxLoc)); 
        end
        if isempty(BCGScaleHLocTemp)
            BCGScaleHLocTemp=NaN(size(BPMaxLoc)); BCGScaleHTemp=NaN(size(BPMaxLoc));
        end
        if isempty(BCGScaleKLocTemp)
            BCGScaleKLocTemp=NaN(size(BPMaxLoc)); BCGScaleKTemp=NaN(size(BPMaxLoc));
        end
        if isempty(BCGScaleLLocTemp)
            BCGScaleLLocTemp=NaN(size(BPMaxLoc)); BCGScaleLTemp=NaN(size(BPMaxLoc));
        end
    else
        if isForBCG
            BCGScaleHLocTemp=startIdx+(BCGScaleHLocTemp-1); BCGScaleILocTemp=startIdx+(BCGScaleILocTemp-1); BCGScaleJLocTemp=startIdx+(BCGScaleJLocTemp-1);
            BCGScaleKLocTemp=startIdx+(BCGScaleKLocTemp-1); BCGScaleLLocTemp=startIdx+(BCGScaleLLocTemp-1);
        else
            BCGScaleHLocTemp=startIdx+currentWindowStartIdx-1+(BCGScaleHLocTemp-1); BCGScaleILocTemp=startIdx+currentWindowStartIdx-1+(BCGScaleILocTemp-1);
            BCGScaleJLocTemp=startIdx+currentWindowStartIdx-1+(BCGScaleJLocTemp-1); BCGScaleKLocTemp=startIdx+currentWindowStartIdx-1+(BCGScaleKLocTemp-1);
            BCGScaleLLocTemp=startIdx+currentWindowStartIdx-1+(BCGScaleLLocTemp-1);
        end
    end
    if isForBCG
        maskH = (BCGScaleHLocTemp>currentWindowStartIdxAbs & BCGScaleHLocTemp<currentWindowEndIdxAbs);
        maskI = (BCGScaleILocTemp>currentWindowStartIdxAbs & BCGScaleILocTemp<currentWindowEndIdxAbs);
        maskJ = (BCGScaleJLocTemp>currentWindowStartIdxAbs & BCGScaleJLocTemp<currentWindowEndIdxAbs);
        maskK = (BCGScaleKLocTemp>currentWindowStartIdxAbs & BCGScaleKLocTemp<currentWindowEndIdxAbs);
        maskL = (BCGScaleLLocTemp>currentWindowStartIdxAbs & BCGScaleLLocTemp<currentWindowEndIdxAbs);
        set(mPlots.Analysis.(eventTag).Features.BCGScaleHWave,'XData',(BCGScaleHLocTemp(maskH)-1)/fs,'YData',BCGScaleHTemp(maskH))
        set(mPlots.Analysis.(eventTag).Features.BCGScaleIWave,'XData',(BCGScaleILocTemp(maskI)-1)/fs,'YData',BCGScaleITemp(maskI))
        set(mPlots.Analysis.(eventTag).Features.BCGScaleJWave,'XData',(BCGScaleJLocTemp(maskJ)-1)/fs,'YData',BCGScaleJTemp(maskJ))
        set(mPlots.Analysis.(eventTag).Features.BCGScaleKWave,'XData',(BCGScaleKLocTemp(maskK)-1)/fs,'YData',BCGScaleKTemp(maskK))
        set(mPlots.Analysis.(eventTag).Features.BCGScaleLWave,'XData',(BCGScaleLLocTemp(maskL)-1)/fs,'YData',BCGScaleLTemp(maskL))
    else
        set(mPlots.Analysis.(eventTag).Features.BCGScaleHWave,'XData',(BCGScaleHLocTemp-1)/fs,'YData',BCGScaleHTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGScaleIWave,'XData',(BCGScaleILocTemp-1)/fs,'YData',BCGScaleITemp)
        set(mPlots.Analysis.(eventTag).Features.BCGScaleJWave,'XData',(BCGScaleJLocTemp-1)/fs,'YData',BCGScaleJTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGScaleKWave,'XData',(BCGScaleKLocTemp-1)/fs,'YData',BCGScaleKTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGScaleLWave,'XData',(BCGScaleLLocTemp-1)/fs,'YData',BCGScaleLTemp)
    end
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLoc') || isForBCG
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLoc',BCGScaleHLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWave',BCGScaleHTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLoc',BCGScaleILocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWave',BCGScaleITemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc',BCGScaleJLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWave',BCGScaleJTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLoc',BCGScaleKLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWave',BCGScaleKTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveLoc',BCGScaleLLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWave',BCGScaleLTemp);
        
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLocOld',BCGScaleHLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveOld',BCGScaleHTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLocOld',BCGScaleILocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveOld',BCGScaleITemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLocOld',BCGScaleJLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveOld',BCGScaleJTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLocOld',BCGScaleKLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveOld',BCGScaleKTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveLocOld',BCGScaleLLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveOld',BCGScaleLTemp);
    else
        BCGScaleHWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLoc');
        BCGScaleHWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWave');
        BCGScaleIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLoc');
        BCGScaleIWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWave');
        BCGScaleJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc');
        BCGScaleJWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWave');
        BCGScaleKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLoc');
        BCGScaleKWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWave');
        BCGScaleLWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveLoc');
        BCGScaleLWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWave');
        beatsHWaveBefore = find(BCGScaleHWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsHWaveBetween = length(find(BCGScaleHWaveLoc>currentWindowStartIdxAbs & BCGScaleHWaveLoc<currentWindowEndIdxAbs));
        beatsIWaveBefore = find(BCGScaleIWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsIWaveBetween = length(find(BCGScaleIWaveLoc>currentWindowStartIdxAbs & BCGScaleIWaveLoc<currentWindowEndIdxAbs));
        beatsJWaveBefore = find(BCGScaleJWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsJWaveBetween = length(find(BCGScaleJWaveLoc>currentWindowStartIdxAbs & BCGScaleJWaveLoc<currentWindowEndIdxAbs));
        beatsKWaveBefore = find(BCGScaleKWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsKWaveBetween = length(find(BCGScaleKWaveLoc>currentWindowStartIdxAbs & BCGScaleKWaveLoc<currentWindowEndIdxAbs));
        beatsLWaveBefore = find(BCGScaleLWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsLWaveBetween = length(find(BCGScaleLWaveLoc>currentWindowStartIdxAbs & BCGScaleLWaveLoc<currentWindowEndIdxAbs));
%         fprintf(['BCGMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(BCGMaxLocTemp)) '\n'])
%         fprintf(['BCGMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(BCGMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLoc',[BCGScaleHWaveLoc(1:beatsHWaveBefore);BCGScaleHLocTemp;BCGScaleHWaveLoc(beatsHWaveBefore+beatsHWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWave',[BCGScaleHWave(1:beatsHWaveBefore);BCGScaleHTemp;BCGScaleHWave(beatsHWaveBefore+beatsHWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLoc',[BCGScaleIWaveLoc(1:beatsIWaveBefore);BCGScaleILocTemp;BCGScaleIWaveLoc(beatsIWaveBefore+beatsIWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWave',[BCGScaleIWave(1:beatsIWaveBefore);BCGScaleITemp;BCGScaleIWave(beatsIWaveBefore+beatsIWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc',[BCGScaleJWaveLoc(1:beatsJWaveBefore);BCGScaleJLocTemp;BCGScaleJWaveLoc(beatsJWaveBefore+beatsJWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWave',[BCGScaleJWave(1:beatsJWaveBefore);BCGScaleJTemp;BCGScaleJWave(beatsJWaveBefore+beatsJWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLoc',[BCGScaleKWaveLoc(1:beatsKWaveBefore);BCGScaleKLocTemp;BCGScaleKWaveLoc(beatsKWaveBefore+beatsKWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWave',[BCGScaleKWave(1:beatsKWaveBefore);BCGScaleKTemp;BCGScaleKWave(beatsKWaveBefore+beatsKWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveLoc',[BCGScaleLWaveLoc(1:beatsLWaveBefore);BCGScaleLLocTemp;BCGScaleLWaveLoc(beatsLWaveBefore+beatsLWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWave',[BCGScaleLWave(1:beatsLWaveBefore);BCGScaleLTemp;BCGScaleLWave(beatsLWaveBefore+beatsLWaveBetween+1:end)]);

        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveLocOld',BCGScaleHWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleHWaveOld',BCGScaleHWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLocOld',BCGScaleIWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveOld',BCGScaleIWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLocOld',BCGScaleJWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveOld',BCGScaleJWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLocOld',BCGScaleKWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveOld',BCGScaleKWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveLocOld',BCGScaleLWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleLWaveOld',BCGScaleLWave);
    end
elseif strcmp(signalName,'BCGArm') == 1
    if isForBCG %% When BP/ECG changes, entire BCG changes
        signalUsed = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmsig');
    end
    minPeakDistBCGArmH = customParams('minPeakDistBCGArmH'); minPeakProminenceBCGArmH = customParams('minPeakProminenceBCGArmH');
    minPeakDistBCGArmI = customParams('minPeakDistBCGArmI'); minPeakProminenceBCGArmI = customParams('minPeakProminenceBCGArmI');
    minPeakDistBCGArmJ = customParams('minPeakDistBCGArmJ'); minPeakProminenceBCGArmJ = customParams('minPeakProminenceBCGArmJ');
    minPeakDistBCGArmK = customParams('minPeakDistBCGArmK'); minPeakProminenceBCGArmK = customParams('minPeakProminenceBCGArmK');
    minPeakDistBCGArmL = customParams('minPeakDistBCGArmL'); minPeakProminenceBCGArmL = customParams('minPeakProminenceBCGArmL');
    minPeakHeightBCGArmH = customParams('minPeakHeightBCGArmH'); minPeakHeightBCGArmI = customParams('minPeakHeightBCGArmI');
    minPeakHeightBCGArmJ = customParams('minPeakHeightBCGArmJ'); minPeakHeightBCGArmK = customParams('minPeakHeightBCGArmK');
    minPeakHeightBCGArmL = customParams('minPeakHeightBCGArmL'); 
    [BCGArmHTemp,BCGArmHLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGArmH,'MinPeakDistance',minPeakDistBCGArmH*fs,'MinPeakProminence',minPeakProminenceBCGArmH);
    [BCGArmITemp,BCGArmILocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBCGArmI,'MinPeakDistance',minPeakDistBCGArmI*fs,'MinPeakProminence',minPeakProminenceBCGArmI);
    [BCGArmJTemp,BCGArmJLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGArmJ,'MinPeakDistance',minPeakDistBCGArmJ*fs,'MinPeakProminence',minPeakProminenceBCGArmJ);
    [BCGArmKTemp,BCGArmKLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightBCGArmK,'MinPeakDistance',minPeakDistBCGArmK*fs,'MinPeakProminence',minPeakProminenceBCGArmK);
    [BCGArmLTemp,BCGArmLLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightBCGArmL,'MinPeakDistance',minPeakDistBCGArmL*fs,'MinPeakProminence',minPeakProminenceBCGArmL);
    BCGArmITemp = -BCGArmITemp; BCGArmKTemp = -BCGArmKTemp;
    if (isempty(BCGArmHLocTemp) || isempty(BCGArmILocTemp) || isempty(BCGArmJLocTemp) || isempty(BCGArmKLocTemp) || isempty(BCGArmLLocTemp)) && ...
            ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        if isempty(BCGArmILocTemp) || isempty(BCGArmJLocTemp)
            BCGArmHLocTemp=NaN(size(BPMaxLoc)); BCGArmHTemp=NaN(size(BPMaxLoc)); BCGArmILocTemp=NaN(size(BPMaxLoc)); BCGArmITemp=NaN(size(BPMaxLoc));
            BCGArmJLocTemp=NaN(size(BPMaxLoc)); BCGArmJTemp=NaN(size(BPMaxLoc)); BCGArmKLocTemp=NaN(size(BPMaxLoc)); BCGArmKTemp=NaN(size(BPMaxLoc));
            BCGArmLLocTemp=NaN(size(BPMaxLoc)); BCGArmLTemp=NaN(size(BPMaxLoc)); 
        end
        if isempty(BCGArmHLocTemp)
            BCGArmHLocTemp=NaN(size(BPMaxLoc)); BCGArmHTemp=NaN(size(BPMaxLoc));
        end
        if isempty(BCGArmKLocTemp)
            BCGArmKLocTemp=NaN(size(BPMaxLoc)); BCGArmKTemp=NaN(size(BPMaxLoc));
        end
        if isempty(BCGArmLLocTemp)
            BCGArmLLocTemp=NaN(size(BPMaxLoc)); BCGArmLTemp=NaN(size(BPMaxLoc));
        end
    else
        if isForBCG
            BCGArmHLocTemp=startIdx+(BCGArmHLocTemp-1); BCGArmILocTemp=startIdx+(BCGArmILocTemp-1); BCGArmJLocTemp=startIdx+(BCGArmJLocTemp-1);
            BCGArmKLocTemp=startIdx+(BCGArmKLocTemp-1); BCGArmLLocTemp=startIdx+(BCGArmLLocTemp-1);
        else
            BCGArmHLocTemp=startIdx+currentWindowStartIdx-1+(BCGArmHLocTemp-1); BCGArmILocTemp=startIdx+currentWindowStartIdx-1+(BCGArmILocTemp-1);
            BCGArmJLocTemp=startIdx+currentWindowStartIdx-1+(BCGArmJLocTemp-1); BCGArmKLocTemp=startIdx+currentWindowStartIdx-1+(BCGArmKLocTemp-1);
            BCGArmLLocTemp=startIdx+currentWindowStartIdx-1+(BCGArmLLocTemp-1);
        end
    end
    if isForBCG
        maskH = (BCGArmHLocTemp>currentWindowStartIdxAbs & BCGArmHLocTemp<currentWindowEndIdxAbs);
        maskI = (BCGArmILocTemp>currentWindowStartIdxAbs & BCGArmILocTemp<currentWindowEndIdxAbs);
        maskJ = (BCGArmJLocTemp>currentWindowStartIdxAbs & BCGArmJLocTemp<currentWindowEndIdxAbs);
        maskK = (BCGArmKLocTemp>currentWindowStartIdxAbs & BCGArmKLocTemp<currentWindowEndIdxAbs);
        maskL = (BCGArmLLocTemp>currentWindowStartIdxAbs & BCGArmLLocTemp<currentWindowEndIdxAbs);
        set(mPlots.Analysis.(eventTag).Features.BCGArmHWave,'XData',(BCGArmHLocTemp(maskH)-1)/fs,'YData',BCGArmHTemp(maskH))
        set(mPlots.Analysis.(eventTag).Features.BCGArmIWave,'XData',(BCGArmILocTemp(maskI)-1)/fs,'YData',BCGArmITemp(maskI))
        set(mPlots.Analysis.(eventTag).Features.BCGArmJWave,'XData',(BCGArmJLocTemp(maskJ)-1)/fs,'YData',BCGArmJTemp(maskJ))
        set(mPlots.Analysis.(eventTag).Features.BCGArmKWave,'XData',(BCGArmKLocTemp(maskK)-1)/fs,'YData',BCGArmKTemp(maskK))
        set(mPlots.Analysis.(eventTag).Features.BCGArmLWave,'XData',(BCGArmLLocTemp(maskL)-1)/fs,'YData',BCGArmLTemp(maskL))
    else
        set(mPlots.Analysis.(eventTag).Features.BCGArmHWave,'XData',(BCGArmHLocTemp-1)/fs,'YData',BCGArmHTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGArmIWave,'XData',(BCGArmILocTemp-1)/fs,'YData',BCGArmITemp)
        set(mPlots.Analysis.(eventTag).Features.BCGArmJWave,'XData',(BCGArmJLocTemp-1)/fs,'YData',BCGArmJTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGArmKWave,'XData',(BCGArmKLocTemp-1)/fs,'YData',BCGArmKTemp)
        set(mPlots.Analysis.(eventTag).Features.BCGArmLWave,'XData',(BCGArmLLocTemp-1)/fs,'YData',BCGArmLTemp)
    end
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLoc') || isForBCG
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLoc',BCGArmHLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWave',BCGArmHTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLoc',BCGArmILocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWave',BCGArmITemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc',BCGArmJLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWave',BCGArmJTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLoc',BCGArmKLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWave',BCGArmKTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveLoc',BCGArmLLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWave',BCGArmLTemp);
        
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLocOld',BCGArmHLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveOld',BCGArmHTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLocOld',BCGArmILocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveOld',BCGArmITemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLocOld',BCGArmJLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveOld',BCGArmJTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLocOld',BCGArmKLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveOld',BCGArmKTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveLocOld',BCGArmLLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveOld',BCGArmLTemp);
    else
        BCGArmHWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLoc');
        BCGArmHWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWave');
        BCGArmIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLoc');
        BCGArmIWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWave');
        BCGArmJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc');
        BCGArmJWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWave');
        BCGArmKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLoc');
        BCGArmKWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWave');
        BCGArmLWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveLoc');
        BCGArmLWave = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWave');
        beatsHWaveBefore = find(BCGArmHWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsHWaveBetween = length(find(BCGArmHWaveLoc>currentWindowStartIdxAbs & BCGArmHWaveLoc<currentWindowEndIdxAbs));
        beatsIWaveBefore = find(BCGArmIWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsIWaveBetween = length(find(BCGArmIWaveLoc>currentWindowStartIdxAbs & BCGArmIWaveLoc<currentWindowEndIdxAbs));
        beatsJWaveBefore = find(BCGArmJWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsJWaveBetween = length(find(BCGArmJWaveLoc>currentWindowStartIdxAbs & BCGArmJWaveLoc<currentWindowEndIdxAbs));
        beatsKWaveBefore = find(BCGArmKWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsKWaveBetween = length(find(BCGArmKWaveLoc>currentWindowStartIdxAbs & BCGArmKWaveLoc<currentWindowEndIdxAbs));
        beatsLWaveBefore = find(BCGArmLWaveLoc>currentWindowStartIdxAbs,1)-1;
        beatsLWaveBetween = length(find(BCGArmLWaveLoc>currentWindowStartIdxAbs & BCGArmLWaveLoc<currentWindowEndIdxAbs));
%         fprintf(['BCGMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(BCGMaxLocTemp)) '\n'])
%         fprintf(['BCGMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(BCGMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLoc',[BCGArmHWaveLoc(1:beatsHWaveBefore);BCGArmHLocTemp;BCGArmHWaveLoc(beatsHWaveBefore+beatsHWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWave',[BCGArmHWave(1:beatsHWaveBefore);BCGArmHTemp;BCGArmHWave(beatsHWaveBefore+beatsHWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLoc',[BCGArmIWaveLoc(1:beatsIWaveBefore);BCGArmILocTemp;BCGArmIWaveLoc(beatsIWaveBefore+beatsIWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWave',[BCGArmIWave(1:beatsIWaveBefore);BCGArmITemp;BCGArmIWave(beatsIWaveBefore+beatsIWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc',[BCGArmJWaveLoc(1:beatsJWaveBefore);BCGArmJLocTemp;BCGArmJWaveLoc(beatsJWaveBefore+beatsJWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWave',[BCGArmJWave(1:beatsJWaveBefore);BCGArmJTemp;BCGArmJWave(beatsJWaveBefore+beatsJWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLoc',[BCGArmKWaveLoc(1:beatsKWaveBefore);BCGArmKLocTemp;BCGArmKWaveLoc(beatsKWaveBefore+beatsKWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWave',[BCGArmKWave(1:beatsKWaveBefore);BCGArmKTemp;BCGArmKWave(beatsKWaveBefore+beatsKWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveLoc',[BCGArmLWaveLoc(1:beatsLWaveBefore);BCGArmLLocTemp;BCGArmLWaveLoc(beatsLWaveBefore+beatsLWaveBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWave',[BCGArmLWave(1:beatsLWaveBefore);BCGArmLTemp;BCGArmLWave(beatsLWaveBefore+beatsLWaveBetween+1:end)]);

        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveLocOld',BCGArmHWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmHWaveOld',BCGArmHWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLocOld',BCGArmIWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveOld',BCGArmIWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLocOld',BCGArmJWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveOld',BCGArmJWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLocOld',BCGArmKWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveOld',BCGArmKWave);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveLocOld',BCGArmLWaveLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmLWaveOld',BCGArmLWave);
    end
elseif strcmp(signalName,'PPGClip') == 1
    minPeakDistPPGClipMax = customParams('minPeakDistPPGClipMax'); minPeakProminencePPGClipMax = customParams('minPeakProminencePPGClipMax');
    minPeakDistPPGClipMin = customParams('minPeakDistPPGClipMin'); minPeakProminencePPGClipMin = customParams('minPeakProminencePPGClipMin');
    minPeakHeightPPGClipMax = customParams('minPeakHeightPPGClipMax'); minPeakHeightPPGClipMin = customParams('minPeakHeightPPGClipMin');
    [PPGClipMaxTemp,PPGClipMaxLocTemp]=findpeaks(signalUsed,'MinPeakHeight',minPeakHeightPPGClipMax,'MinPeakDistance',minPeakDistPPGClipMax*fs,'MinPeakProminence',minPeakProminencePPGClipMax);
    [PPGClipMinTemp,PPGClipMinLocTemp]=findpeaks(-signalUsed,'MinPeakHeight',minPeakHeightPPGClipMin,'MinPeakDistance',minPeakDistPPGClipMin*fs,'MinPeakProminence',minPeakProminencePPGClipMin);
    if (isempty(PPGClipMaxLocTemp) || isempty(PPGClipMinLocTemp)) && ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLoc')
        BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
        PPGClipMaxLocTemp=NaN(size(BPMaxLoc)); PPGClipMaxTemp=NaN(size(BPMaxLoc)); PPGClipMinLocTemp=NaN(size(BPMaxLoc)); PPGClipMinTemp=NaN(size(BPMaxLoc));
    else
        PPGClipMaxLocTemp=startIdx+currentWindowStartIdx-1+(PPGClipMaxLocTemp-1); PPGClipMinLocTemp=startIdx+currentWindowStartIdx-1+(PPGClipMinLocTemp-1); 
        PPGClipMinTemp = -PPGClipMinTemp;
    end
    set(mPlots.Analysis.(eventTag).Features.PPGClipMax,'XData',(PPGClipMaxLocTemp-1)/fs,'YData',PPGClipMaxTemp)
    set(mPlots.Analysis.(eventTag).Features.PPGClipMin,'XData',(PPGClipMinLocTemp-1)/fs,'YData',PPGClipMinTemp)
    if ~isappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLoc')
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLoc',PPGClipMaxLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMax',PPGClipMaxTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMinLoc',PPGClipMinLocTemp);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMin',PPGClipMinTemp);
    else
        PPGClipMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLoc');
        PPGClipMax = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMax');
        PPGClipMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMinLoc');
        PPGClipMin = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMin');
        beatsMaxBefore = find(PPGClipMaxLoc>currentWindowStartIdxAbs,1)-1;
        beatsMaxBetween = length(find(PPGClipMaxLoc>currentWindowStartIdxAbs & PPGClipMaxLoc<currentWindowEndIdxAbs));
        beatsMinBefore = find(PPGClipMinLoc>currentWindowStartIdxAbs,1)-1;
        beatsMinBetween = length(find(PPGClipMinLoc>currentWindowStartIdxAbs & PPGClipMinLoc<currentWindowEndIdxAbs));
%         fprintf(['PPGClipMax Update: ' num2str(beatsMaxBetween) ' replaced by ' num2str(length(PPGClipMaxLocTemp)) '\n'])
%         fprintf(['PPGClipMin Update: ' num2str(beatsMinBetween) ' replaced by ' num2str(length(PPGClipMinLocTemp)) '\n'])
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLoc',[PPGClipMaxLoc(1:beatsMaxBefore);PPGClipMaxLocTemp;PPGClipMaxLoc(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMax',[PPGClipMax(1:beatsMaxBefore);PPGClipMaxTemp;PPGClipMax(beatsMaxBefore+beatsMaxBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMinLoc',[PPGClipMinLoc(1:beatsMinBefore);PPGClipMinLocTemp;PPGClipMinLoc(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMin',[PPGClipMin(1:beatsMinBefore);PPGClipMinTemp;PPGClipMin(beatsMinBefore+beatsMinBetween+1:end)]);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxLocOld',PPGClipMaxLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMaxOld',PPGClipMax);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMinLocOld',PPGClipMinLoc);
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipMinOld',PPGClipMin);
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
    end
end

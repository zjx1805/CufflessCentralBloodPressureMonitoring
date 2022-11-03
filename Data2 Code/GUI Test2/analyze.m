function []=analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)

% Main analysis procedures. Each of the eight signals has its corresponding
% label that will be referenced as the entryCode when there is any updates
% to that signal or its corresponding features. The entryCode determines
% which part of the analysis procedures will be run and which will not. All
% feature info are obtained from the application data of the figure of that
% specific intervention. They are saved back to the application data after
% the modifications are applied so that other subfunctions can access the
% same version of the feature info.

customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
fs = mParams.Constant.fs;
SlidingWindowSize = mParams.Constant.SlidingWindowSize;
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
validEventNum = getappdata(mPlots.Result.Parent,'validEventNum');
locsToDelete = getappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete');
skipCalculation = getappdata(mPlots.Result.Parent,'skipCalculation');
skipFeature = getappdata(mPlots.Result.Parent,'skipFeature');
eventName = getappdata(mPlots.Analysis.(eventTag).Parent,'eventName');
updateButtonPushed = getappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed');
% selectedMode = mControls.Analysis.(eventTag).ModeButtonGroup.SelectedObject.String;
selectedSignal = mControls.Analysis.(eventTag).SignalButtonGroup.SelectedObject.String;

fprintf(['Entering analyze() with entryCode: ' num2str(entryCode) ' and eventTag: ' num2str(eventTag) '\n'])
if skipCalculation == 1
    fprintf('Calculation skipped!\n')
    setappdata(mPlots.Result.Parent,'skipCalculation',0)
else
    if skipFeature == 0
        if entryCode <= 1
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BP') == 1)
                BPsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BPsig');
                findCandidateFeature(BPsig,'BP',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete)% && strcmp(selectedMode,'Remove') == 1
                removeFeature('BPMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('BPMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BP') == 1)
                rangeLimit = customParams('maxP2VDurBP'); isBothBP = true;
                pairFeature('BPMax','BPMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
        end
        if entryCode <= 2
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'ECG') == 1 || entryCode < 2))
                ECGsig = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGsig');
                findCandidateFeature(ECGsig,'ECG',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete)% && strcmp(selectedMode,'Remove') == 1
                removeFeature('ECGMax',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'ECG') == 1 || entryCode < 2))
                rangeLimit = customParams('maxDurBPMin2ECGMax'); isBothBP = false;
                pairFeature('BPMin','ECGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            expMA('BCGScale',eventTag,mPlots)
            if entryCode ~= 0 % When BP/ECG changes, BCG also changes, and thus requires refinding the features
                BCGScalesig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScalesig');
                findCandidateFeature(BCGScalesig,'BCGScale',true,eventTag,mPlots,mParams)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGScaleHOffset = customParams('BCGScaleHOffset'); BCGScaleIOffset = customParams('BCGScaleIOffset'); 
                BCGScaleJOffset = customParams('BCGScaleJOffset'); BCGScaleKOffset = customParams('BCGScaleKOffset'); 
                BCGScaleLOffset = customParams('BCGScaleLOffset');  
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleIOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGScaleIOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleIWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGScaleJOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGScaleJOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleJWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGScaleIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLoc');
                BCGScaleJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleHOffset(1),(BCGScaleIWaveLoc-ECGMaxLoc)/fs+BCGScaleHOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleHWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleKOffset(1),(BPMaxLoc-BCGScaleJWaveLoc)/fs+BCGScaleKOffset(2)]; isBothBP = false;
                pairFeature('BCGScaleJWave','BCGScaleKWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGScaleKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleLOffset(1),(BPMaxLoc-BCGScaleKWaveLoc)/fs+BCGScaleLOffset(2)]; isBothBP = false;
                pairFeature('BCGScaleKWave','BCGScaleLWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            
            expMA('BCGArm',eventTag,mPlots)
            if entryCode ~= 0 % When BP/ECG changes, BCG also changes, and thus requires refinding the features
                BCGArmsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmsig');
                findCandidateFeature(BCGArmsig,'BCGArm',true,eventTag,mPlots,mParams)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGArmHOffset = customParams('BCGArmHOffset'); BCGArmIOffset = customParams('BCGArmIOffset'); 
                BCGArmJOffset = customParams('BCGArmJOffset'); BCGArmKOffset = customParams('BCGArmKOffset'); 
                BCGArmLOffset = customParams('BCGArmLOffset');  
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmIOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGArmIOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmIWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGArmJOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGArmJOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmJWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGArmIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLoc');
                BCGArmJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmHOffset(1),(BCGArmIWaveLoc-ECGMaxLoc)/fs+BCGArmHOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmHWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmKOffset(1),(BPMaxLoc-BCGArmJWaveLoc)/fs+BCGArmKOffset(2)]; isBothBP = false;
                pairFeature('BCGArmJWave','BCGArmKWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGArmKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmLOffset(1),(BPMaxLoc-BCGArmKWaveLoc)/fs+BCGArmLOffset(2)]; isBothBP = false;
                pairFeature('BCGArmKWave','BCGArmLWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            %     if updateButtonPushed == 1 && ~isempty(beatsInfo)
            %         rangeLimit = customParams('maxDurBPMin2ECGMax'); isBothBP = false;
            %         pairFeature('BPMin','ECGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            %     end
            
        end
        if entryCode <= 3
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCGScale') == 1)
                BCGScalesig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScalesig');
                findCandidateFeature(BCGScalesig,'BCGScale',false,eventTag,mPlots,mParams)
            end
            % if trigerred by BP/ECG, pairing for BCG has already been
            % called in the code block of ECG
            if ~isempty(locsToDelete) && strcmp(selectedSignal,'BCGScale') == 1 %&& strcmp(selectedMode,'Remove') == 1 && strcmp(selectedSignal,'BCGScale') == 1
                selectedFeature = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
                if strcmp(selectedFeature,'IWave') == 1 || strcmp(selectedFeature,'JWave') == 1
                    removeFeature('BCGScaleHWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGScaleIWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGScaleJWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGScaleKWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGScaleLWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                else
                    removeFeature(['BCGScale' selectedFeature],locsToDelete,eventTag,mPlots,mControls,mParams)
                end
            end
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCGScale') == 1)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGScaleHOffset = customParams('BCGScaleHOffset'); BCGScaleIOffset = customParams('BCGScaleIOffset'); 
                BCGScaleJOffset = customParams('BCGScaleJOffset'); BCGScaleKOffset = customParams('BCGScaleKOffset'); 
                BCGScaleLOffset = customParams('BCGScaleLOffset');  
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleIOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGScaleIOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleIWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGScaleJOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGScaleJOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleJWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGScaleIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleIWaveLoc');
                BCGScaleJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleJWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleHOffset(1),(BCGScaleIWaveLoc-ECGMaxLoc)/fs+BCGScaleHOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGScaleHWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleKOffset(1),(BPMaxLoc-BCGScaleJWaveLoc)/fs+BCGScaleKOffset(2)]; isBothBP = false;
                pairFeature('BCGScaleJWave','BCGScaleKWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGScaleKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleKWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGScaleLOffset(1),(BPMaxLoc-BCGScaleKWaveLoc)/fs+BCGScaleLOffset(2)]; isBothBP = false;
                pairFeature('BCGScaleKWave','BCGScaleLWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
        end
        if entryCode <= 3
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCGArm') == 1)
                BCGArmsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmsig');
                findCandidateFeature(BCGArmsig,'BCGArm',false,eventTag,mPlots,mParams)
            end
            % if trigerred by BP/ECG, pairing for BCG has already been
            % called in the code block of ECG
            if ~isempty(locsToDelete) && strcmp(selectedSignal,'BCGArm') == 1 %&& strcmp(selectedMode,'Remove') == 1 && strcmp(selectedSignal,'BCGArm') == 1
                selectedFeature = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
                if strcmp(selectedFeature,'IWave') == 1 || strcmp(selectedFeature,'JWave') == 1
                    removeFeature('BCGArmHWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGArmIWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGArmJWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGArmKWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                    removeFeature('BCGArmLWave',locsToDelete,eventTag,mPlots,mControls,mParams)
                else
                    removeFeature(['BCGArm' selectedFeature],locsToDelete,eventTag,mPlots,mControls,mParams)
                end
            end
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCGArm') == 1)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGArmHOffset = customParams('BCGArmHOffset'); BCGArmIOffset = customParams('BCGArmIOffset'); 
                BCGArmJOffset = customParams('BCGArmJOffset'); BCGArmKOffset = customParams('BCGArmKOffset'); 
                BCGArmLOffset = customParams('BCGArmLOffset');  
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmIOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGArmIOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmIWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGArmJOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGArmJOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmJWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGArmIWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmIWaveLoc');
                BCGArmJWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmJWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmHOffset(1),(BCGArmIWaveLoc-ECGMaxLoc)/fs+BCGArmHOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGArmHWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmKOffset(1),(BPMaxLoc-BCGArmJWaveLoc)/fs+BCGArmKOffset(2)]; isBothBP = false;
                pairFeature('BCGArmJWave','BCGArmKWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                BCGArmKWaveLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmKWaveLoc');
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGArmLOffset(1),(BPMaxLoc-BCGArmKWaveLoc)/fs+BCGArmLOffset(2)]; isBothBP = false;
                pairFeature('BCGArmKWave','BCGArmLWave',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
        end
        
        if entryCode <= 4
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGClip') == 1 || entryCode <= 3))
                PPGClipsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipsig');
                findCandidateFeature(PPGClipsig,'PPGClip',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && (strcmp(selectedSignal,'PPGClip') == 1 || entryCode <= 2) %&& strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'PPGClip') == 1 || entryCode <= 2)
                removeFeature('PPGClipMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('PPGClipMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGClip') == 1 || entryCode <= 3))
                rangeLimit = customParams('maxDurECGMax2PPGClipMax'); isBothBP = false;
                pairFeature('ECGMax','PPGClipMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = customParams('maxP2VDurPPGClip'); isBothBP = false;
                pairFeature('PPGClipMax','PPGClipMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findFoot('PPGClip',eventTag,mPlots,mControls,mParams)
        end
        
        
        
        setappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete',[])
        setappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed',0)
    end
    %%
    
    eventIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'eventIdx');
    validEventIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'validEventIdx');
    validEventNum = getappdata(mPlots.Result.Parent,'validEventNum');
    % PAT = getappdata(mPlots.Result.Parent,'PAT');
    % PTT = getappdata(mPlots.Result.Parent,'PTT');
    % IJInfo = getappdata(mPlots.Result.Parent,'IJInfo');
    
%     BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
%     BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
%     mControls.Adjust.(eventTag).BCGSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).BCGSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
%     mControls.Adjust.(eventTag).PPGfingerSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGfingerSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
%     mControls.Adjust.(eventTag).PPGearSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGearSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
%     mControls.Adjust.(eventTag).PPGfeetSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGfeetSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
%     mControls.Adjust.(eventTag).PPGtoeSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGtoeSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
%     set(mPlots.Adjust.([eventTag 'Plot']),'XData',(BPMinLoc-1)/fs,'YData',BPMin)
%     mControls.Adjust.([eventTag 'Tab']).Title = [eventTag ': ' eventName];
%     axis(mAxes.Adjust.([eventTag 'Sub']),[(BPMinLoc(1)-1)/fs,(BPMinLoc(end)-1)/fs,min(BPMin)-1,max(BPMin)+1])
    
    calcVar('ECGMaxLoc','PPGClipFootLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('ECGMaxLoc','PPGClipFootLoc','PP',eventTag,mPlots,mControls,mParams);
    %%% BCGScale
    calcVar('BCGScaleIWaveLoc','PPGClipFootLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWaveLoc','BCGScaleJWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleJWaveLoc','BCGScaleKWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWaveLoc','BCGScaleKWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWave','BCGScaleJWave','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleJWave','BCGScaleKWave','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWave','BCGScaleKWave','DP',eventTag,mPlots,mControls,mParams);
    
    calcVar('BCGScaleIWaveLoc','PPGClipFootLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWaveLoc','BCGScaleJWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleJWaveLoc','BCGScaleKWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWaveLoc','BCGScaleKWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWave','BCGScaleJWave','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleJWave','BCGScaleKWave','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGScaleIWave','BCGScaleKWave','PP',eventTag,mPlots,mControls,mParams);
    
    %%% BCG Arm
    calcVar('BCGArmIWaveLoc','PPGClipFootLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWaveLoc','BCGArmJWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmJWaveLoc','BCGArmKWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWaveLoc','BCGArmKWaveLoc','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWave','BCGArmJWave','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmJWave','BCGArmKWave','DP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWave','BCGArmKWave','DP',eventTag,mPlots,mControls,mParams);
    
    calcVar('BCGArmIWaveLoc','PPGClipFootLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWaveLoc','BCGArmJWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmJWaveLoc','BCGArmKWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWaveLoc','BCGArmKWaveLoc','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWave','BCGArmJWave','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmJWave','BCGArmKWave','PP',eventTag,mPlots,mControls,mParams);
    calcVar('BCGArmIWave','BCGArmKWave','PP',eventTag,mPlots,mControls,mParams);
    
end
setappdata(mPlots.Result.Parent,'skipCalculation',0)
setappdata(mPlots.Result.Parent,'skipFeature',0)
setappdata(mPlots.Analysis.(eventTag).Parent,'initialRun',0)
%%
% correlations = [];

PAT = getappdata(mPlots.Result.Parent,'PAT');
PTT = getappdata(mPlots.Result.Parent,'PTT');
SIGS = getappdata(mPlots.Result.Parent,'SIGS');
PATNames={'PPGClipECG','PPGIRECG','PPGGreenECG'};
PTTNames={'PPGClipBCGScale','PPGClipBCGWrist','PPGClipBCGArm','PPGClipBCGNeck',...
    'PPGIRBCGScale','PPGIRBCGWrist','PPGIRBCGArm','PPGIRBCGNeck',...
    'PPGGreenBCGScale','PPGGreenBCGWrist','PPGGreenBCGArm','PPGGreenBCGNeck'};
SIGSNames = getappdata(mPlots.Result.Parent,'SIGSNames');
BCGNames = getappdata(mPlots.Result.Parent,'BCGNames');
varNames = {'Interval','Amplitude'};
BPNames = getappdata(mPlots.Result.Parent,'BPNames');
for ii=1:length(PATNames)
    PATName=PATNames{ii};
    for jj = 1:2
        BPName = BPNames{jj};
        if strcmp(BPName,'DP') == 1
            BPCol = 3;
        elseif strcmp(BPName,'PP') == 1
            BPCol = 4;
        end
        if ~all(isnan(PAT.(BPName).(PATName).data(:,1))) && ~all(isnan(PAT.(BPName).(PATName).data(:,2)))
            temp=corrcoef(PAT.(BPName).(PATName).data(:,1),PAT.(BPName).(PATName).data(:,BPCol),'rows','complete');
            if length(temp)==1
                PAT.(BPName).(PATName).correlation = NaN;
            elseif sum(double(~isnan(PAT.(BPName).(PATName).data(:,1)))) <= 4 || sum(double(~isnan(PAT.(BPName).(PATName).data(:,2)))) <= 4
                PAT.(BPName).(PATName).correlation = NaN;
            else
                PAT.(BPName).(PATName).correlation = temp(1,2);
            end
        else
            PAT.(BPName).(PATName).correlation = NaN;
        end
    end
end
for ii=1:length(PTTNames)
    PTTName=PTTNames{ii};
    for jj = 1:2
        BPName = BPNames{jj};
        if strcmp(BPName,'DP') == 1
            BPCol = 3;
        elseif strcmp(BPName,'PP') == 1
            BPCol = 4;
        end
        if ~all(isnan(PTT.(BPName).(PTTName).data(:,1))) && ~all(isnan(PTT.(BPName).(PTTName).data(:,2)))
            temp=corrcoef(PTT.(BPName).(PTTName).data(:,1),PTT.(BPName).(PTTName).data(:,BPCol),'rows','complete');
            if length(temp)==1
                PTT.(BPName).(PTTName).correlation = NaN;
            elseif sum(double(~isnan(PTT.(BPName).(PTTName).data(:,1)))) <= 4 || sum(double(~isnan(PTT.(BPName).(PTTName).data(:,2)))) <= 4
                PTT.(BPName).(PTTName).correlation = NaN;
            else
                PTT.(BPName).(PTTName).correlation = temp(1,2);
            end
        else
            PTT.(BPName).(PTTName).correlation = NaN;
        end
    end
end
% tic
for ii = 1:length(SIGSNames)
    SIGSName = SIGSNames{ii};
    for jj=1:length(BCGNames)
        BCGName=BCGNames{jj};
        for kk = 1:length(BPNames)
            BPName = BPNames{kk};
            if strcmp(BPName,'DP') == 1
                BPCol = 3;
            elseif strcmp(BPName,'PP') == 1
                BPCol = 4;
            end
            for ll = 1:length(varNames)
                varName = varNames{ll};
                if ~all(isnan(SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,1))) && ~all(isnan(SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,2)))
                    temp=corrcoef(SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,1),SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,BPCol),'rows','complete');
                    if length(temp)==1
                        SIGS.(SIGSName).(BPName).(BCGName).(varName).correlation = NaN;
                    elseif sum(double(~isnan(SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,1)))) <= 4 || sum(double(~isnan(SIGS.(SIGSName).(BPName).(BCGName).(varName).data(:,2)))) <= 4
                        SIGS.(SIGSName).(BPName).(BCGName).(varName).correlation = NaN;
                    else
                        SIGS.(SIGSName).(BPName).(BCGName).(varName).correlation = temp(1,2);
                    end
                else
                    SIGS.(SIGSName).(BPName).(BCGName).(varName).correlation = NaN;
                end
            end
        end
    end
end
% toc
setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'SIGS',SIGS)
%%
eventList = getappdata(mPlots.Result.Parent,'eventList');
if length(eventList) == validEventNum
    BLcounter = 1;PEcounter = 1; eventListCopy=eventList;
    for ii = 1:length(eventList)
        if strcmp(eventList{ii},'BL') == 1
            eventList{ii} = ['BL' num2str(BLcounter)];
            BLcounter = BLcounter+1;
        end
        if strcmp(eventList{ii},'PE') == 1
            eventList{ii} = ['PE' num2str(PEcounter)];
            PEcounter = PEcounter+1;
        end
    end
end
% eventList
%%
% tic
if length(eventList) == validEventNum && entryCode == 0
    refreshResult(mAxes,mPlots)
    fprintf('Result changed!\n')
end
% toc
%%
% if length(eventList) == validEventNum
%     fprintf('Starting to save data!\n')
%     fieldnames(mPlots.Analysis)
% end

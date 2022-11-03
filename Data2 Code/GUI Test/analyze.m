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
selectedMode = mControls.Analysis.(eventTag).ModeButtonGroup.SelectedObject.String;
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
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1
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
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1
                removeFeature('ECGMax',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'ECG') == 1 || entryCode < 2))
                rangeLimit = customParams('maxDurBPMin2ECGMax'); isBothBP = false;
                pairFeature('BPMin','ECGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            expMA(eventTag,mPlots)
            if entryCode ~= 0 % When BP/ECG changes, BCG also changes, and thus requires refinding the features
                BCGsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig');
                findCandidateFeature(BCGsig,'BCG',true,eventTag,mPlots,mParams)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGMinOffset = customParams('BCGMinOffset'); BCGMaxOffset = customParams('BCGMaxOffset'); 
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGMaxOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGMaxOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMaxLoc),1)+BCGMinOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGMinOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            %     if updateButtonPushed == 1 && ~isempty(beatsInfo)
            %         rangeLimit = customParams('maxDurBPMin2ECGMax'); isBothBP = false;
            %         pairFeature('BPMin','ECGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            %     end
            
        end
        if entryCode <= 3
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'ICGdzdt') == 1 || entryCode < 3))
                ICGdzdtsig = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtsig');
                findCandidateFeature(ICGdzdtsig,'ICGdzdt',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'ICGdzdt') == 1 || entryCode < 3)
                removeFeature('ICGdzdtMax',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'ICGdzdt') == 1 || entryCode < 3))
                rangeLimit = customParams('maxDurECGMax2ICGdzdtMax'); isBothBP = false;
                pairFeature('ECGMax','ICGdzdtMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findICGBPoint(eventTag,mPlots,mControls,mParams)
        end
        if entryCode <= 3
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCG') == 1)
                BCGsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig');
                findCandidateFeature(BCGsig,'BCG',false,eventTag,mPlots,mParams)
            end
            % if trigerred by BP/ECG, pairing for BCG has already been
            % called in the code block of ECG
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && strcmp(selectedSignal,'BCG') == 1
                removeFeature('BCGMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('BCGMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && strcmp(selectedSignal,'BCG') == 1)
                BPMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMaxLoc');
                BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
                ECGMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGMaxLoc');
                BCGMinOffset = customParams('BCGMinOffset'); BCGMaxOffset = customParams('BCGMaxOffset'); 
                rangeLimit = [(BPMinLoc-ECGMaxLoc)/fs+BCGMaxOffset(1),(BPMaxLoc-ECGMaxLoc)/fs+BCGMaxOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = [zeros(length(BPMinLoc),1)+BCGMinOffset(1),(BPMinLoc-ECGMaxLoc)/fs+BCGMinOffset(2)]; isBothBP = false;
                pairFeature('ECGMax','BCGMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
        end
        if entryCode <= 4
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGfinger') == 1 || entryCode <= 3))
                PPGfingersig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingersig');
                findCandidateFeature(PPGfingersig,'PPGfinger',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'PPGfinger') == 1 || entryCode <= 2)
                removeFeature('PPGfingerMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('PPGfingerMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGfinger') == 1 || entryCode <= 3))
                rangeLimit = customParams('maxDurECGMax2PPGfingerMax'); isBothBP = false;
                pairFeature('ECGMax','PPGfingerMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = customParams('maxP2VDurPPGfinger'); isBothBP = false;
                pairFeature('PPGfingerMax','PPGfingerMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findFoot('PPGfinger',eventTag,mPlots,mControls,mParams)
        end
        if entryCode <= 4
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGear') == 1 || entryCode <= 3))
                PPGearsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearsig');
                findCandidateFeature(PPGearsig,'PPGear',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'PPGear') == 1 || entryCode <= 2)
                removeFeature('PPGearMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('PPGearMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGear') == 1 || entryCode <= 3))
                rangeLimit = customParams('maxDurECGMax2PPGearMax'); isBothBP = false;
                pairFeature('ECGMax','PPGearMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = customParams('maxP2VDurPPGear'); isBothBP = false;
                pairFeature('PPGearMax','PPGearMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findFoot('PPGear',eventTag,mPlots,mControls,mParams)
        end
        if entryCode <= 4
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGfeet') == 1 || entryCode <= 3))
                PPGfeetsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetsig');
                findCandidateFeature(PPGfeetsig,'PPGfeet',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'PPGfeet') == 1 || entryCode <= 2)
                removeFeature('PPGfeetMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('PPGfeetMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGfeet') == 1 || entryCode <= 3))
                rangeLimit = customParams('maxDurECGMax2PPGfeetMax'); isBothBP = false;
                pairFeature('ECGMax','PPGfeetMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = customParams('maxP2VDurPPGfeet'); isBothBP = false;
                pairFeature('PPGfeetMax','PPGfeetMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findFoot('PPGfeet',eventTag,mPlots,mControls,mParams)
        end
        if entryCode <= 4
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGtoe') == 1 || entryCode <= 3))
                PPGtoesig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoesig');
                findCandidateFeature(PPGtoesig,'PPGtoe',false,eventTag,mPlots,mParams)
            end
            if ~isempty(locsToDelete) && strcmp(selectedMode,'Remove') == 1 && (strcmp(selectedSignal,'PPGtoe') == 1 || entryCode <= 2)
                removeFeature('PPGtoeMax',locsToDelete,eventTag,mPlots,mControls,mParams)
                removeFeature('PPGtoeMin',locsToDelete,eventTag,mPlots,mControls,mParams)
            end
            if entryCode == 0 || (updateButtonPushed == 1 && (strcmp(selectedSignal,'PPGtoe') == 1 || entryCode <= 3))
                rangeLimit = customParams('maxDurECGMax2PPGtoeMax'); isBothBP = false;
                pairFeature('ECGMax','PPGtoeMax',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
                rangeLimit = customParams('maxP2VDurPPGtoe'); isBothBP = false;
                pairFeature('PPGtoeMax','PPGtoeMin',rangeLimit,isBothBP,eventTag,mPlots,mControls,mParams)
            end
            findFoot('PPGtoe',eventTag,mPlots,mControls,mParams)
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
    
    BPMinLoc = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMinLoc');
    BPMin = getappdata(mPlots.Analysis.(eventTag).Parent,'BPMin');
    mControls.Adjust.(eventTag).BCGSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).BCGSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
    mControls.Adjust.(eventTag).PPGfingerSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGfingerSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
    mControls.Adjust.(eventTag).PPGearSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGearSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
    mControls.Adjust.(eventTag).PPGfeetSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGfeetSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
    mControls.Adjust.(eventTag).PPGtoeSlider.Max = length(BPMinLoc)-(SlidingWindowSize-1); mControls.Adjust.(eventTag).PPGtoeSlider.SliderStep = [1/length(BPMinLoc),10/length(BPMinLoc)];
    set(mPlots.Adjust.([eventTag 'Plot']),'XData',(BPMinLoc-1)/fs,'YData',BPMin)
    mControls.Adjust.([eventTag 'Tab']).Title = [eventTag ': ' eventName];
    axis(mAxes.Adjust.([eventTag 'Sub']),[(BPMinLoc(1)-1)/fs,(BPMinLoc(end)-1)/fs,min(BPMin)-1,max(BPMin)+1])
    
    calcTime('ECGMaxLoc','PPGfingerFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ECGMaxLoc','PPGearFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ECGMaxLoc','PPGtoeFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ECGMaxLoc','PPGfeetFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ICGdzdtBPointLoc','PPGfingerFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ICGdzdtBPointLoc','PPGearFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ICGdzdtBPointLoc','PPGtoeFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('ICGdzdtBPointLoc','PPGfeetFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('BCGMinLoc','PPGfingerFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('BCGMinLoc','PPGearFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('BCGMinLoc','PPGtoeFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('BCGMinLoc','PPGfeetFootLoc',eventTag,mPlots,mControls,mParams);
    calcTime('BCGMinLoc','BCGMaxLoc',eventTag,mPlots,mControls,mParams);
    
end
setappdata(mPlots.Result.Parent,'skipCalculation',0)
setappdata(mPlots.Result.Parent,'skipFeature',0)
setappdata(mPlots.Analysis.(eventTag).Parent,'initialRun',0)
%%
% correlations = [];

PAT = getappdata(mPlots.Result.Parent,'PAT');
PTT = getappdata(mPlots.Result.Parent,'PTT');
IJInfo = getappdata(mPlots.Result.Parent,'IJInfo');
PATnames={'PPGfingerECG','PPGearECG','PPGtoeECG','PPGfeetECG'};
PTTnames={'PPGfingerICG','PPGearICG','PPGtoeICG','PPGfeetICG','PPGfingerBCG','PPGearBCG','PPGtoeBCG','PPGfeetBCG'};
for ii=1:length(PATnames)
    PATname=PATnames{ii};
    if ~all(isnan(PAT.(PATname).data(:,1))) && ~all(isnan(PAT.(PATname).data(:,2)))
        temp=corrcoef(PAT.(PATname).data(:,1),PAT.(PATname).data(:,2),'rows','complete');
        temp2=corrcoef(PAT.(PATname).data(:,1),PAT.(PATname).data(:,3),'rows','complete');
        if length(temp)==1 || length(temp2)==1
            PAT.(PATname).correlation = [NaN,NaN];
        elseif sum(double(~isnan(PAT.(PATname).data(:,1)))) <= 4 || sum(double(~isnan(PAT.(PATname).data(:,2)))) <= 4
            PAT.(PATname).correlation = [NaN,NaN];
        else
            PAT.(PATname).correlation = [temp(1,2),temp2(1,2)];
        end
    else
        PAT.(PATname).correlation = [NaN,NaN];
    end
    %     correlations = [correlations;PAT.(PATname).correlation];
end
for ii=1:length(PTTnames)
    PTTname=PTTnames{ii};
    if ~all(isnan(PTT.(PTTname).data(:,1))) && ~all(isnan(PTT.(PTTname).data(:,2)))
        temp=corrcoef(PTT.(PTTname).data(:,1),PTT.(PTTname).data(:,2),'rows','complete');
        temp2=corrcoef(PTT.(PTTname).data(:,1),PTT.(PTTname).data(:,3),'rows','complete');
        if length(temp)==1 || length(temp2)==1
            PTT.(PTTname).correlation = [NaN,NaN];
        elseif sum(double(~isnan(PTT.(PTTname).data(:,1)))) <= 4 || sum(double(~isnan(PTT.(PTTname).data(:,2)))) <= 4
            PTT.(PTTname).correlation = [NaN,NaN];
        else
            PTT.(PTTname).correlation = [temp(1,2),temp2(1,2)];
        end
    else
        PTT.(PTTname).correlation = [NaN,NaN];
    end
    %     correlations = [correlations;PTT.(PTTname).correlation];
end
if ~all(isnan(IJInfo.data(:,1))) && ~all(isnan(IJInfo.data(:,2)))
    temp=corrcoef(IJInfo.data(:,1),IJInfo.data(:,2),'rows','complete');
    temp2=corrcoef(IJInfo.data(:,1),IJInfo.data(:,3),'rows','complete');
    if length(temp)==1 || length(temp2)==1
        IJInfo.correlation = [NaN,NaN];
    elseif sum(double(~isnan(IJInfo.data(:,1)))) <= 4 || sum(double(~isnan(IJInfo.data(:,2)))) <= 4
        IJInfo.correlation = [NaN,NaN];
    else
        IJInfo.correlation = [temp(1,2),temp2(1,2)];
    end
else
    IJInfo.correlation = [NaN,NaN];
end
% correlations = [correlations;IJInfo.correlation];

setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'IJInfo',IJInfo)
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
tic
if length(eventList) == validEventNum
    fprintf('Result changed!\n')
    PAT = getappdata(mPlots.Result.Parent,'PAT');
    PTT = getappdata(mPlots.Result.Parent,'PTT');
    IJInfo = getappdata(mPlots.Result.Parent,'IJInfo');
    
    % subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.03], [0.06 0.06], [0.04 0.04]);
    % clear subplot;
    % figure(100);maximize(gcf);set(gcf,'Color','w');legendFontSize=7.5;grid on;grid minor
    legendFontSize=7.5;
    set(mPlots.Result.PPGfingerECGSP,'XData',PAT.('PPGfingerECG').data(:,1)*1000,'YData',PAT.('PPGfingerECG').data(:,2));
    title(mAxes.Result.PPGfingerECGSP,['r=' num2str(PAT.('PPGfingerECG').correlation(1))])
    newPos = reshape([PAT.('PPGfingerECG').data(:,1)'*1000;PAT.('PPGfingerECG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerECGSPText.Position] = newPos{:}; [mPlots.Result.PPGfingerECGSPText.String] = eventList{:};
    % htxt=text(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfingerECGDP,'XData',PAT.('PPGfingerECG').data(:,1)*1000,'YData',PAT.('PPGfingerECG').data(:,3));
    title(mAxes.Result.PPGfingerECGDP,['r=' num2str(PAT.('PPGfingerECG').correlation(2))])
    newPos = reshape([PAT.('PPGfingerECG').data(:,1)'*1000;PAT.('PPGfingerECG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerECGDPText.Position] = newPos{:}; [mPlots.Result.PPGfingerECGDPText.String] = eventList{:};
    % htxt=text(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearECGSP,'XData',PAT.('PPGearECG').data(:,1)*1000,'YData',PAT.('PPGearECG').data(:,2));
    title(mAxes.Result.PPGearECGSP,['r=' num2str(PAT.('PPGearECG').correlation(1))])
    newPos = reshape([PAT.('PPGearECG').data(:,1)'*1000;PAT.('PPGearECG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearECGSPText.Position] = newPos{:}; [mPlots.Result.PPGearECGSPText.String] = eventList{:};
    % htxt=text(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearECGDP,'XData',PAT.('PPGearECG').data(:,1)*1000,'YData',PAT.('PPGearECG').data(:,3));
    title(mAxes.Result.PPGearECGDP,['r=' num2str(PAT.('PPGearECG').correlation(2))])
    newPos = reshape([PAT.('PPGearECG').data(:,1)'*1000;PAT.('PPGearECG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearECGDPText.Position] = newPos{:}; [mPlots.Result.PPGearECGDPText.String] = eventList{:};
    % htxt=text(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeECGSP,'XData',PAT.('PPGtoeECG').data(:,1)*1000,'YData',PAT.('PPGtoeECG').data(:,2));
    title(mAxes.Result.PPGtoeECGSP,['r=' num2str(PAT.('PPGtoeECG').correlation(1))])
    newPos = reshape([PAT.('PPGtoeECG').data(:,1)'*1000;PAT.('PPGtoeECG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeECGSPText.Position] = newPos{:}; [mPlots.Result.PPGtoeECGSPText.String] = eventList{:};
    % htxt=text(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeECGDP,'XData',PAT.('PPGtoeECG').data(:,1)*1000,'YData',PAT.('PPGtoeECG').data(:,3));
    title(mAxes.Result.PPGtoeECGDP,['r=' num2str(PAT.('PPGtoeECG').correlation(2))])
    newPos = reshape([PAT.('PPGtoeECG').data(:,1)'*1000;PAT.('PPGtoeECG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeECGDPText.Position] = newPos{:}; [mPlots.Result.PPGtoeECGDPText.String] = eventList{:};
    % htxt=text(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetECGSP,'XData',PAT.('PPGfeetECG').data(:,1)*1000,'YData',PAT.('PPGfeetECG').data(:,2));
    title(mAxes.Result.PPGfeetECGSP,['r=' num2str(PAT.('PPGfeetECG').correlation(1))])
    newPos = reshape([PAT.('PPGfeetECG').data(:,1)'*1000;PAT.('PPGfeetECG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetECGSPText.Position] = newPos{:}; [mPlots.Result.PPGfeetECGSPText.String] = eventList{:};
    % htxt=text(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetECGDP,'XData',PAT.('PPGfeetECG').data(:,1)*1000,'YData',PAT.('PPGfeetECG').data(:,3));
    title(mAxes.Result.PPGfeetECGDP,['r=' num2str(PAT.('PPGfeetECG').correlation(2))])
    newPos = reshape([PAT.('PPGfeetECG').data(:,1)'*1000;PAT.('PPGfeetECG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetECGDPText.Position] = newPos{:}; [mPlots.Result.PPGfeetECGDPText.String] = eventList{:};
    % htxt=text(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,3)*1.01,eventList,'fontsize',7);
    
    set(mPlots.Result.PPGfingerICGSP,'XData',PTT.('PPGfingerICG').data(:,1)*1000,'YData',PTT.('PPGfingerICG').data(:,2));
    title(mAxes.Result.PPGfingerICGSP,['r=' num2str(PTT.('PPGfingerICG').correlation(1))])
    newPos = reshape([PTT.('PPGfingerICG').data(:,1)'*1000;PTT.('PPGfingerICG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerICGSPText.Position] = newPos{:}; [mPlots.Result.PPGfingerICGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfingerICGDP,'XData',PTT.('PPGfingerICG').data(:,1)*1000,'YData',PTT.('PPGfingerICG').data(:,3));
    title(mAxes.Result.PPGfingerICGDP,['r=' num2str(PTT.('PPGfingerICG').correlation(2))])
    newPos = reshape([PTT.('PPGfingerICG').data(:,1)'*1000;PTT.('PPGfingerICG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerICGDPText.Position] = newPos{:}; [mPlots.Result.PPGfingerICGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearICGSP,'XData',PTT.('PPGearICG').data(:,1)*1000,'YData',PTT.('PPGearICG').data(:,2));
    title(mAxes.Result.PPGearICGSP,['r=' num2str(PTT.('PPGearICG').correlation(1))])
    newPos = reshape([PTT.('PPGearICG').data(:,1)'*1000;PTT.('PPGearICG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearICGSPText.Position] = newPos{:}; [mPlots.Result.PPGearICGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearICGDP,'XData',PTT.('PPGearICG').data(:,1)*1000,'YData',PTT.('PPGearICG').data(:,3));
    title(mAxes.Result.PPGearICGDP,['r=' num2str(PTT.('PPGearICG').correlation(2))])
    newPos = reshape([PTT.('PPGearICG').data(:,1)'*1000;PTT.('PPGearICG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearICGDPText.Position] = newPos{:}; [mPlots.Result.PPGearICGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeICGSP,'XData',PTT.('PPGtoeICG').data(:,1)*1000,'YData',PTT.('PPGtoeICG').data(:,2));
    title(mAxes.Result.PPGtoeICGSP,['r=' num2str(PTT.('PPGtoeICG').correlation(1))])
    newPos = reshape([PTT.('PPGtoeICG').data(:,1)'*1000;PTT.('PPGtoeICG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeICGSPText.Position] = newPos{:}; [mPlots.Result.PPGtoeICGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeICGDP,'XData',PTT.('PPGtoeICG').data(:,1)*1000,'YData',PTT.('PPGtoeICG').data(:,3));
    title(mAxes.Result.PPGtoeICGDP,['r=' num2str(PTT.('PPGtoeICG').correlation(2))])
    newPos = reshape([PTT.('PPGtoeICG').data(:,1)'*1000;PTT.('PPGtoeICG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeICGDPText.Position] = newPos{:}; [mPlots.Result.PPGtoeICGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetICGSP,'XData',PTT.('PPGfeetICG').data(:,1)*1000,'YData',PTT.('PPGfeetICG').data(:,2));
    title(mAxes.Result.PPGfeetICGSP,['r=' num2str(PTT.('PPGfeetICG').correlation(1))])
    newPos = reshape([PTT.('PPGfeetICG').data(:,1)'*1000;PTT.('PPGfeetICG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetICGSPText.Position] = newPos{:}; [mPlots.Result.PPGfeetICGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetICGDP,'XData',PTT.('PPGfeetICG').data(:,1)*1000,'YData',PTT.('PPGfeetICG').data(:,3));
    title(mAxes.Result.PPGfeetICGDP,['r=' num2str(PTT.('PPGfeetICG').correlation(2))])
    newPos = reshape([PTT.('PPGfeetICG').data(:,1)'*1000;PTT.('PPGfeetICG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetICGDPText.Position] = newPos{:}; [mPlots.Result.PPGfeetICGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,3)*1.01,eventList,'fontsize',7);
    
    set(mPlots.Result.PPGfingerBCGSP,'XData',PTT.('PPGfingerBCG').data(:,1)*1000,'YData',PTT.('PPGfingerBCG').data(:,2));
    title(mAxes.Result.PPGfingerBCGSP,['r=' num2str(PTT.('PPGfingerBCG').correlation(1))])
    newPos = reshape([PTT.('PPGfingerBCG').data(:,1)'*1000;PTT.('PPGfingerBCG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerBCGSPText.Position] = newPos{:}; [mPlots.Result.PPGfingerBCGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfingerBCGDP,'XData',PTT.('PPGfingerBCG').data(:,1)*1000,'YData',PTT.('PPGfingerBCG').data(:,3));
    title(mAxes.Result.PPGfingerBCGDP,['r=' num2str(PTT.('PPGfingerBCG').correlation(2))])
    newPos = reshape([PTT.('PPGfingerBCG').data(:,1)'*1000;PTT.('PPGfingerBCG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfingerBCGDPText.Position] = newPos{:}; [mPlots.Result.PPGfingerBCGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearBCGSP,'XData',PTT.('PPGearBCG').data(:,1)*1000,'YData',PTT.('PPGearBCG').data(:,2));
    title(mAxes.Result.PPGearBCGSP,['r=' num2str(PTT.('PPGearBCG').correlation(1))])
    newPos = reshape([PTT.('PPGearBCG').data(:,1)'*1000;PTT.('PPGearBCG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearBCGSPText.Position] = newPos{:}; [mPlots.Result.PPGearBCGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGearBCGDP,'XData',PTT.('PPGearBCG').data(:,1)*1000,'YData',PTT.('PPGearBCG').data(:,3));
    title(mAxes.Result.PPGearBCGDP,['r=' num2str(PTT.('PPGearBCG').correlation(2))])
    newPos = reshape([PTT.('PPGearBCG').data(:,1)'*1000;PTT.('PPGearBCG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGearBCGDPText.Position] = newPos{:}; [mPlots.Result.PPGearBCGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeBCGSP,'XData',PTT.('PPGtoeBCG').data(:,1)*1000,'YData',PTT.('PPGtoeBCG').data(:,2));
    title(mAxes.Result.PPGtoeBCGSP,['r=' num2str(PTT.('PPGtoeBCG').correlation(1))])
    newPos = reshape([PTT.('PPGtoeBCG').data(:,1)'*1000;PTT.('PPGtoeBCG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeBCGSPText.Position] = newPos{:}; [mPlots.Result.PPGtoeBCGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGtoeBCGDP,'XData',PTT.('PPGtoeBCG').data(:,1)*1000,'YData',PTT.('PPGtoeBCG').data(:,3));
    title(mAxes.Result.PPGtoeBCGDP,['r=' num2str(PTT.('PPGtoeBCG').correlation(2))])
    newPos = reshape([PTT.('PPGtoeBCG').data(:,1)'*1000;PTT.('PPGtoeBCG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGtoeBCGDPText.Position] = newPos{:}; [mPlots.Result.PPGtoeBCGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,3)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetBCGSP,'XData',PTT.('PPGfeetBCG').data(:,1)*1000,'YData',PTT.('PPGfeetBCG').data(:,2));
    title(mAxes.Result.PPGfeetBCGSP,['r=' num2str(PTT.('PPGfeetBCG').correlation(1))])
    newPos = reshape([PTT.('PPGfeetBCG').data(:,1)'*1000;PTT.('PPGfeetBCG').data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetBCGSPText.Position] = newPos{:}; [mPlots.Result.PPGfeetBCGSPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.PPGfeetBCGDP,'XData',PTT.('PPGfeetBCG').data(:,1)*1000,'YData',PTT.('PPGfeetBCG').data(:,3));
    title(mAxes.Result.PPGfeetBCGDP,['r=' num2str(PTT.('PPGfeetBCG').correlation(2))])
    newPos = reshape([PTT.('PPGfeetBCG').data(:,1)'*1000;PTT.('PPGfeetBCG').data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.PPGfeetBCGDPText.Position] = newPos{:}; [mPlots.Result.PPGfeetBCGDPText.String] = eventList{:};
    % htxt=text(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,3)*1.01,eventList,'fontsize',7);
    
    set(mPlots.Result.IJSP,'XData',IJInfo.data(:,1)*1000,'YData',IJInfo.data(:,2));
    title(mAxes.Result.IJSP,['r=' num2str(IJInfo.correlation(1))])
    newPos = reshape([IJInfo.data(:,1)'*1000;IJInfo.data(:,2)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.IJSPText.Position] = newPos{:}; [mPlots.Result.IJSPText.String] = eventList{:};
    % htxt=text(IJInfo.data(:,1)*1000,IJInfo.data(:,2)*1.01,eventList,'fontsize',7);
    set(mPlots.Result.IJDP,'XData',IJInfo.data(:,1)*1000,'YData',IJInfo.data(:,3));
    title(mAxes.Result.IJDP,['r=' num2str(IJInfo.correlation(2))])
    newPos = reshape([IJInfo.data(:,1)'*1000;IJInfo.data(:,3)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.IJDPText.Position] = newPos{:}; [mPlots.Result.IJDPText.String] = eventList{:};
    % htxt=text(IJInfo.data(:,1)*1000,IJInfo.data(:,3)*1.01,eventList,'fontsize',7);
    
    set(mPlots.Result.PPGfingerEventECGSP,'XData',1:length(PAT.('PPGfingerECG').data(:,2)),'YData',PAT.('PPGfingerECG').data(:,2));hold on;%ylabel('SP [mmHg]')
    set(mPlots.Result.PPGfingerEventICGSP,'XData',1:length(PTT.('PPGfingerICG').data(:,2)),'YData',PTT.('PPGfingerICG').data(:,2));
    set(mPlots.Result.PPGfingerEventBCGSP,'XData',1:length(PTT.('PPGfingerBCG').data(:,2)),'YData',PTT.('PPGfingerBCG').data(:,2));
    set(mAxes.Result.PPGfingerEventSP,'xtick',1:length(PAT.('PPGfingerECG').data(:,2)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGfingerEventSP,90);
    %     h=legend(mAxes.Result.PPGfingerEventSP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGfingerEventECGDP,'XData',1:length(PAT.('PPGfingerECG').data(:,3)),'YData',PAT.('PPGfingerECG').data(:,3));hold on;%ylabel('DP [mmHg]')
    set(mPlots.Result.PPGfingerEventICGDP,'XData',1:length(PTT.('PPGfingerICG').data(:,3)),'YData',PTT.('PPGfingerICG').data(:,3));
    set(mPlots.Result.PPGfingerEventBCGDP,'XData',1:length(PTT.('PPGfingerBCG').data(:,3)),'YData',PTT.('PPGfingerBCG').data(:,3));
    set(mAxes.Result.PPGfingerEventDP,'xtick',1:length(PAT.('PPGfingerECG').data(:,3)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGfingerEventDP,90);
    %     h=legend(mAxes.Result.PPGfingerEventDP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGearEventECGSP,'XData',1:length(PAT.('PPGearECG').data(:,2)),'YData',PAT.('PPGearECG').data(:,2));hold on;%ylabel('SP [mmHg]')
    set(mPlots.Result.PPGearEventICGSP,'XData',1:length(PTT.('PPGearICG').data(:,2)),'YData',PTT.('PPGearICG').data(:,2));
    set(mPlots.Result.PPGearEventBCGSP,'XData',1:length(PTT.('PPGearBCG').data(:,2)),'YData',PTT.('PPGearBCG').data(:,2));
    set(mAxes.Result.PPGearEventSP,'xtick',1:length(PAT.('PPGearECG').data(:,2)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGearEventSP,90);
    %     h=legend(mAxes.Result.PPGearEventSP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGearEventECGDP,'XData',1:length(PAT.('PPGearECG').data(:,3)),'YData',PAT.('PPGearECG').data(:,3));hold on;%ylabel('DP [mmHg]')
    set(mPlots.Result.PPGearEventICGDP,'XData',1:length(PTT.('PPGearICG').data(:,3)),'YData',PTT.('PPGearICG').data(:,3));
    set(mPlots.Result.PPGearEventBCGDP,'XData',1:length(PTT.('PPGearBCG').data(:,3)),'YData',PTT.('PPGearBCG').data(:,3));
    set(mAxes.Result.PPGearEventDP,'xtick',1:length(PAT.('PPGearECG').data(:,3)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGearEventDP,90);
    %     h=legend(mAxes.Result.PPGearEventDP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGtoeEventECGSP,'XData',1:length(PAT.('PPGtoeECG').data(:,2)),'YData',PAT.('PPGtoeECG').data(:,2));hold on;%ylabel('SP [mmHg]')
    set(mPlots.Result.PPGtoeEventICGSP,'XData',1:length(PTT.('PPGtoeICG').data(:,2)),'YData',PTT.('PPGtoeICG').data(:,2));
    set(mPlots.Result.PPGtoeEventBCGSP,'XData',1:length(PTT.('PPGtoeBCG').data(:,2)),'YData',PTT.('PPGtoeBCG').data(:,2));
    set(mAxes.Result.PPGtoeEventSP,'xtick',1:length(PAT.('PPGtoeECG').data(:,2)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGtoeEventSP,90);
    %     h=legend(mAxes.Result.PPGtoeEventSP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGtoeEventECGDP,'XData',1:length(PAT.('PPGtoeECG').data(:,3)),'YData',PAT.('PPGtoeECG').data(:,3));hold on;%ylabel('DP [mmHg]')
    set(mPlots.Result.PPGtoeEventICGDP,'XData',1:length(PTT.('PPGtoeICG').data(:,3)),'YData',PTT.('PPGtoeICG').data(:,3));
    set(mPlots.Result.PPGtoeEventBCGDP,'XData',1:length(PTT.('PPGtoeBCG').data(:,3)),'YData',PTT.('PPGtoeBCG').data(:,3));
    set(mAxes.Result.PPGtoeEventDP,'xtick',1:length(PAT.('PPGtoeECG').data(:,3)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGtoeEventDP,90);
    %     h=legend(mAxes.Result.PPGtoeEventDP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGfeetEventECGSP,'XData',1:length(PAT.('PPGfeetECG').data(:,2)),'YData',PAT.('PPGfeetECG').data(:,2));hold on;%ylabel('SP [mmHg]')
    set(mPlots.Result.PPGfeetEventICGSP,'XData',1:length(PTT.('PPGfeetICG').data(:,2)),'YData',PTT.('PPGfeetICG').data(:,2));
    set(mPlots.Result.PPGfeetEventBCGSP,'XData',1:length(PTT.('PPGfeetBCG').data(:,2)),'YData',PTT.('PPGfeetBCG').data(:,2));
    set(mAxes.Result.PPGfeetEventSP,'xtick',1:length(PAT.('PPGfeetECG').data(:,2)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGfeetEventSP,90);
    %     h=legend(mAxes.Result.PPGfeetEventSP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
    set(mPlots.Result.PPGfeetEventECGDP,'XData',1:length(PAT.('PPGfeetECG').data(:,3)),'YData',PAT.('PPGfeetECG').data(:,3));hold on;%ylabel('DP [mmHg]')
    set(mPlots.Result.PPGfeetEventICGDP,'XData',1:length(PTT.('PPGfeetICG').data(:,3)),'YData',PTT.('PPGfeetICG').data(:,3));
    set(mPlots.Result.PPGfeetEventBCGDP,'XData',1:length(PTT.('PPGfeetBCG').data(:,3)),'YData',PTT.('PPGfeetBCG').data(:,3));
    set(mAxes.Result.PPGfeetEventDP,'xtick',1:length(PAT.('PPGfeetECG').data(:,3)),'xticklabel',eventList);xtickangle(mAxes.Result.PPGfeetEventDP,90);
    %     h=legend(mAxes.Result.PPGfeetEventDP,'w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
    %     set(h,'Box','off');
end
toc
%%
% if length(eventList) == validEventNum
%     fprintf('Starting to save data!\n')
%     fieldnames(mPlots.Analysis)
% end
%%
% nns = {'BPMaxLoc','BPMinLoc','ECGMaxLoc','ICGdzdtMaxLoc','BCGMaxLoc','BCGMaxLoc','PPGfingerMaxLoc','PPGfingerMinLoc','PPGearMaxLoc','PPGearMinLoc','PPGfeetMaxLoc','PPGfeetMinLoc',...
%     'PPGtoeMaxLoc','PPGtoeMinLoc'};
% for ii = 1:length(nns)
%     nn = nns{ii};
%     nndata = getappdata(mPlots.Analysis.Event3.Parent,nn);
%     nndataNoNaN = nndata(~isnan(nndata));
%     [uniqueA,i,j] = unique(nndataNoNaN,'first');
%     indexToDupes = find(not(ismember(1:numel(nndataNoNaN),i)));
%     fprintf(['Name: ' nn ', diff = ' num2str(length(nndataNoNaN)-length(uniqueA)) '\n'])
%     if ~isempty(indexToDupes)
%         nndataNoNaN(indexToDupes)
%     end
% end

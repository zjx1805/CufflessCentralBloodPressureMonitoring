% This code takes the result from the GUI output. It looks through the
% SP/DP/PP extracted from the GUI, remove the unreasonable ones and then
% recalculate the correlation. The beats are removed if:
% (1) PP is less than 15% of the SP
% (2) DP changes abruptly (this is detected using a 20-beat moving average
% window with a threshold value of 1.7, see isoutlier function in Matlab
% for details)
% The removed beats are shown in red in the plot
% The meeting ppt (Meeting20171110.pptx in ../../../../Meeting folder) is
% about this topic

clear all;close all;clc;
load ../mParams
fs = 1000;
allIndexes = [8,9,10,12,13,14,19,20,21,22,24,27,28,29,30,31,33,34,36,37,601,801];
VariableNames = arrayfun(@(a) ['Sub' num2str(a)],allIndexes,'UniformOutput',false);
VariableNames{end+1} = 'Mean';
VariableNames{end+1} = 'Std';
featureNames = {...
    'BPMaxLoc','BPMax','BPMinLoc','BPMin','ECGMaxLoc','ECGMax','ICGdzdtMaxLoc','ICGdzdtMax','ICGdzdtBPoint','ICGdzdtBPointLoc',...
    'BCGMaxLoc','BCGMax','BCGMinLoc','BCGMin','PPGfingerMaxLoc','PPGfingerMax','PPGfingerMinLoc','PPGfingerMin','PPGfingerFoot','PPGfingerFootLoc',...
    'PPGearMaxLoc','PPGearMax','PPGearMinLoc','PPGearMin','PPGearFoot','PPGearFootLoc',... 
    'PPGfeetMaxLoc','PPGfeetMax','PPGfeetMinLoc','PPGfeetMin','PPGfeetFoot','PPGfeetFootLoc',...
    'PPGtoeMaxLoc','PPGtoeMax','PPGtoeMinLoc','PPGtoeMin','PPGtoeFoot','PPGtoeFootLoc'};
for ii = 1:length(allIndexes)
    currentIdx = allIndexes(ii);
    load(['Subject' num2str(currentIdx) 'Data.mat'])
    
    PAT = mResults.Result.PAT;
    PTT = mResults.Result.PTT;
    IJInfo = mResults.Result.IJInfo;
    SPTotalOld(1:13,currentIdx)=[PAT.PPGfingerECG.correlation(1);PAT.PPGearECG.correlation(1);PAT.PPGfeetECG.correlation(1);PAT.PPGtoeECG.correlation(1);
        PTT.PPGfingerICG.correlation(1);PTT.PPGearICG.correlation(1);PTT.PPGfeetICG.correlation(1);PTT.PPGtoeICG.correlation(1);
        PTT.PPGfingerBCG.correlation(1);PTT.PPGearBCG.correlation(1);PTT.PPGfeetBCG.correlation(1);PTT.PPGtoeBCG.correlation(1);
        IJInfo.correlation(1)];
    DPTotalOld(1:13,currentIdx)=[PAT.PPGfingerECG.correlation(2);PAT.PPGearECG.correlation(2);PAT.PPGfeetECG.correlation(2);PAT.PPGtoeECG.correlation(2);
        PTT.PPGfingerICG.correlation(2);PTT.PPGearICG.correlation(2);PTT.PPGfeetICG.correlation(2);PTT.PPGtoeICG.correlation(2);
        PTT.PPGfingerBCG.correlation(2);PTT.PPGearBCG.correlation(2);PTT.PPGfeetBCG.correlation(2);PTT.PPGtoeBCG.correlation(2);
        IJInfo.correlation(2)];
    
    clear PAT PTT IJInfo
    
    subjectTag = ['Subject' num2str(currentIdx)];
    validEventNum = mResults.Result.validEventNum;
    eventList = mResults.Result.eventList;
    Features.(subjectTag).validEventNum = validEventNum;
    Features.(subjectTag).eventList = eventList;
    for jj = 1:validEventNum
        eventTag = ['Event' num2str(jj)];
        eventName = eventList{jj};
        Features.(subjectTag).(eventTag).eventName = eventName;
        for kk = 1:length(featureNames)
            featureName = featureNames{kk};
            Features.(subjectTag).(eventTag).(featureName) = mResults.Analysis.(eventTag).(featureName);
            Features.(subjectTag).(eventTag).(featureName) = mResults.Analysis.(eventTag).(featureName);
        end
    end
end
SPTotalOld = SPTotalOld(:,allIndexes);
DPTotalOld = DPTotalOld(:,allIndexes);
VariableNames = arrayfun(@(a) ['Sub' num2str(a)],allIndexes,'UniformOutput',false);
VariableNames{end+1} = 'Mean';
VariableNames{end+1} = 'Std';
RowNames = {'finger PAT','ear PAT','foot PAT','toe PAT','finger PTT(ICG)','ear PAT(ICG)','foot PAT(ICG)','toe PAT(ICG)',...
    'finger PTT(BCG)','ear PTT(BCG)','foot PTT(BCG)','toe PTT(BCG)','IJ Interval'};
SPTotalOldStat = SPTotalOld; 
SPTotalOldStat(:,end+1) = nanmean(SPTotalOld,2);
SPTotalOldStat(:,end+1) = nanstd(SPTotalOld,1,2);
SPTotalOldDisplay = array2table(SPTotalOldStat,'RowNames',RowNames,'VariableNames',VariableNames);

DPTotalOldStat = DPTotalOld; 
DPTotalOldStat(:,end+1) = nanmean(DPTotalOld,2);
DPTotalOldStat(:,end+1) = nanstd(DPTotalOld,1,2);
DPTotalOldDisplay = array2table(DPTotalOldStat,'RowNames',RowNames,'VariableNames',VariableNames);


PATNames={'PPGfingerECG','PPGearECG','PPGtoeECG','PPGfeetECG'};
PTTNames={'PPGfingerICG','PPGearICG','PPGtoeICG','PPGfeetICG','PPGfingerBCG','PPGearBCG','PPGtoeBCG','PPGfeetBCG'};
for ii = 1:length(allIndexes)
    currentIdx = allIndexes(ii);
    subjectTag = ['Subject' num2str(currentIdx)];
    eventList = Features.(subjectTag).eventList;
    for jj = 1:length(PATNames)
        PATName = PATNames{jj};
        PAT.(subjectTag).(PATName).data = NaN(length(eventList),6);
        PAT.(subjectTag).(PATName).correlation = NaN;
    end
    for jj = 1:length(PTTNames)
        PTTName = PTTNames{jj};
        PTT.(subjectTag).(PTTName).data = NaN(length(eventList),6);
        PTT.(subjectTag).(PTTName).correlation = NaN;
    end
    IJ.(subjectTag).data = NaN(length(eventList),6);
    IJ.(subjectTag).correlation = NaN;
end
    
subplot = @(m,n,p) subtightplot (m, n, p, 0.08, 0.06, 0.05);
fig1 = figure(1);maximize(gcf);set(gcf,'Color','w');
subjectTabs = uitabgroup('Parent',fig1);
setappdata(subjectTabs,'PAT',PAT);
setappdata(subjectTabs,'PTT',PTT);
setappdata(subjectTabs,'IJ',IJ);
for ii = 1:length(allIndexes)
    currentIdx = allIndexes(ii);
    subjectTag = ['Subject' num2str(currentIdx)];
    fprintf(['Working on ' subjectTag '\n'])
    subjectTab.(subjectTag) = uitab('Parent',subjectTabs,'Title',subjectTag,'BackgroundColor','w');
    mAxes.(subjectTag).Host = axes('Parent',subjectTab.(subjectTag));
    eventList = Features.(subjectTag).eventList;
    BLcounter = 1;PEcounter = 1; eventListCopy=eventList;
    for jj = 1:length(eventList)
        if strcmp(eventList{jj},'BL') == 1
            eventList{jj} = ['BL' num2str(BLcounter)];
            BLcounter = BLcounter+1;
        end
        if strcmp(eventList{jj},'PE') == 1
            eventList{jj} = ['PE' num2str(PEcounter)];
            PEcounter = PEcounter+1;
        end
    end
    
    for jj = 1:Features.(['Subject' num2str(currentIdx)]).validEventNum
        eventTag = ['Event' num2str(jj)];
        mAxes.(subjectTag).(eventTag) = subplot(5,2,jj);
        mPlots.(subjectTag).(eventTag).normalPlot = plot((Features.(subjectTag).(eventTag).BPMinLoc-1)/fs,Features.(subjectTag).(eventTag).BPMin,'bo-');
        hold on; grid on; grid minor; xlabel('Time [sec]'); ylabel('DP [mmHg]'); title([eventTag,': ',eventList{jj}])
        BPmask = isoutlier(Features.(subjectTag).(eventTag).BPMin,'movmedian',20,'ThresholdFactor',1.7) | ...
            (Features.(subjectTag).(eventTag).BPMax-Features.(subjectTag).(eventTag).BPMin)<0.15*Features.(subjectTag).(eventTag).BPMax;
        mPlots.(subjectTag).(eventTag).excludePlot = plot((Features.(subjectTag).(eventTag).BPMinLoc(BPmask)-1)/fs,Features.(subjectTag).(eventTag).BPMin(BPmask),'ro');
        
        calcTimeBadBP('ECGMaxLoc','PPGfingerFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ECGMaxLoc','PPGearFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ECGMaxLoc','PPGtoeFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ECGMaxLoc','PPGfeetFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ICGdzdtBPointLoc','PPGfingerFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ICGdzdtBPointLoc','PPGearFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ICGdzdtBPointLoc','PPGtoeFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('ICGdzdtBPointLoc','PPGfeetFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('BCGMinLoc','PPGfingerFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('BCGMinLoc','PPGearFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('BCGMinLoc','PPGtoeFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('BCGMinLoc','PPGfeetFootLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        calcTimeBadBP('BCGMinLoc','BCGMaxLoc',eventTag,subjectTag,BPmask,Features,subjectTabs,mParams);
        
    end
    
    PAT = getappdata(subjectTabs,'PAT');
    PTT = getappdata(subjectTabs,'PTT');
    IJ = getappdata(subjectTabs,'IJ');
    PATnames={'PPGfingerECG','PPGearECG','PPGtoeECG','PPGfeetECG'};
    PTTnames={'PPGfingerICG','PPGearICG','PPGtoeICG','PPGfeetICG','PPGfingerBCG','PPGearBCG','PPGtoeBCG','PPGfeetBCG'};
    for jj=1:length(PATnames)
        PATname=PATnames{jj};
        if ~all(isnan(PAT.(subjectTag).(PATname).data(:,1))) && ~all(isnan(PAT.(subjectTag).(PATname).data(:,2)))
            temp=corrcoef(PAT.(subjectTag).(PATname).data(:,1),PAT.(subjectTag).(PATname).data(:,3),'rows','complete');
            if length(temp)==1
                PAT.(subjectTag).(PATname).correlation = NaN;
            elseif sum(double(~isnan(PAT.(subjectTag).(PATname).data(:,1)))) <= 4 || sum(double(~isnan(PAT.(subjectTag).(PATname).data(:,2)))) <= 4
                PAT.(subjectTag).(PATname).correlation = NaN;
            else
                PAT.(subjectTag).(PATname).correlation = temp(1,2);
            end
        else
            PAT.(subjectTag).(PATname).correlation = NaN;
        end
    end
    for jj=1:length(PTTnames)
        PTTname=PTTnames{jj};
        if ~all(isnan(PTT.(subjectTag).(PTTname).data(:,1))) && ~all(isnan(PTT.(subjectTag).(PTTname).data(:,2)))
            temp=corrcoef(PTT.(subjectTag).(PTTname).data(:,1),PTT.(subjectTag).(PTTname).data(:,3),'rows','complete');
            if length(temp)==1
                PTT.(subjectTag).(PTTname).correlation = NaN;
            elseif sum(double(~isnan(PTT.(subjectTag).(PTTname).data(:,1)))) <= 4 || sum(double(~isnan(PTT.(subjectTag).(PTTname).data(:,2)))) <= 4
                PTT.(subjectTag).(PTTname).correlation = NaN;
            else
                PTT.(subjectTag).(PTTname).correlation = temp(1,2);
            end
        else
            PTT.(subjectTag).(PTTname).correlation = [NaN,NaN];
        end
    end
    if ~all(isnan(IJ.(subjectTag).data(:,1))) && ~all(isnan(IJ.(subjectTag).data(:,2)))
        temp=corrcoef(IJ.(subjectTag).data(:,1),IJ.(subjectTag).data(:,3),'rows','complete');
        if length(temp)==1
            IJ.(subjectTag).correlation = NaN;
        elseif sum(double(~isnan(IJ.(subjectTag).data(:,1)))) <= 4 || sum(double(~isnan(IJ.(subjectTag).data(:,2)))) <= 4
            IJ.(subjectTag).correlation = NaN;
        else
            IJ.(subjectTag).correlation = temp(1,2);
        end
    else
        IJ.(subjectTag).correlation = NaN;
    end
    
    setappdata(subjectTabs,'PAT',PAT)
    setappdata(subjectTabs,'PTT',PTT)
    setappdata(subjectTabs,'IJ',IJ)
    
end
PAT = getappdata(subjectTabs,'PAT');
PTT = getappdata(subjectTabs,'PTT');
IJ = getappdata(subjectTabs,'IJ');
for ii = 1:length(allIndexes)
    currentIdx = allIndexes(ii);
    subjectTag = ['Subject' num2str(currentIdx)];
    DPTotalNew(1:13,currentIdx)=...
        [PAT.(subjectTag).PPGfingerECG.correlation(1);PAT.(subjectTag).PPGearECG.correlation(1);PAT.(subjectTag).PPGfeetECG.correlation(1);PAT.(subjectTag).PPGtoeECG.correlation(1);
        PTT.(subjectTag).PPGfingerICG.correlation(1);PTT.(subjectTag).PPGearICG.correlation(1);PTT.(subjectTag).PPGfeetICG.correlation(1);PTT.(subjectTag).PPGtoeICG.correlation(1);
        PTT.(subjectTag).PPGfingerBCG.correlation(1);PTT.(subjectTag).PPGearBCG.correlation(1);PTT.(subjectTag).PPGfeetBCG.correlation(1);PTT.(subjectTag).PPGtoeBCG.correlation(1);
        IJ.(subjectTag).correlation(1)];
end
DPTotalNew = DPTotalNew(:,allIndexes);
DPTotalNewStat = DPTotalNew; 
DPTotalNewStat(:,end+1) = nanmean(DPTotalNew,2);
DPTotalNewStat(:,end+1) = nanstd(DPTotalNew,1,2);
DPTotalNewDisplay = array2table(DPTotalNewStat,'RowNames',RowNames,'VariableNames',VariableNames);
DPdiffStat = DPTotalNewStat - DPTotalOldStat;
DPdiffDisplay = array2table(DPdiffStat,'RowNames',RowNames,'VariableNames',VariableNames);

%%
idx = 11;
compareSubjectIdx = allIndexes(idx);
compareSubjectTag = ['Subject' num2str(compareSubjectIdx)];
compareXData = PAT.(compareSubjectTag).PPGfingerECG.data(:,1)*1000;
compareYData = PAT.(compareSubjectTag).PPGfingerECG.data(:,3);
compareCorr = PAT.(compareSubjectTag).PPGfingerECG.correlation;
compareEventList = Features.(compareSubjectTag).eventList;
compareValidEventNum = Features.(compareSubjectTag).validEventNum;
BLcounter = 1;PEcounter = 1; 
for jj = 1:length(compareEventList)
    if strcmp(compareEventList{jj},'BL') == 1
        compareEventList{jj} = ['BL' num2str(BLcounter)];
        BLcounter = BLcounter+1;
    end
    if strcmp(compareEventList{jj},'PE') == 1
        compareEventList{jj} = ['PE' num2str(PEcounter)];
        PEcounter = PEcounter+1;
    end
end

compareFig = figure(2);
compareAxe = axes('Parent',compareFig);
comparePlot = plot(NaN,NaN,'bo');grid on;grid minor;
comparePlotText = text(NaN(compareValidEventNum,1),NaN(compareValidEventNum,1),'','fontsize',7);
set(comparePlot,'XData',compareXData,'YData',compareYData);
title(compareAxe,['r=' num2str(compareCorr)])
newPos = reshape([compareXData';compareYData'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(compareEventList))*2);
[comparePlotText.Position] = newPos{:}; [comparePlotText.String] = compareEventList{:};
function []=plotSep(startTime,idxInfo,BP,BPMaxLoc,BPMax,BPMinLoc,BPMin,sig1,sig1Name,sig1MaxLoc,sig1Max,sig1MinLoc,sig1Min,sig1Feature,sig1StartTime,...
    sig2,sig2Name,sig2MaxLoc,sig2Max,sig2MinLoc,sig2Min,sig2Feature,sig2StartTime,BCGMinLoc2,BCGMin2,ECG,ECGMaxLoc,ECGMax,...
    eventIdx,interventionName,fileName,featureName)

featureStartIdx = idxInfo(5); featureEndIdx = idxInfo(6);
if ~isnan(featureStartIdx) && ~isnan(featureEndIdx)
    if isempty(sig2MinLoc)
        dataStartTime = min([BPMinLoc(featureStartIdx-1),sig1MinLoc(featureStartIdx-1)]);
    else
        dataStartTime = min([BPMinLoc(featureStartIdx-1),sig1MinLoc(featureStartIdx-1),sig2MinLoc(featureStartIdx-1)]);
    end
    dataEndTime = max([BPMaxLoc(featureEndIdx+1),sig1MaxLoc(featureEndIdx+1),sig2MaxLoc(featureEndIdx+1)]);
    fs = 1000;
    dataRange = round(dataStartTime*fs):round(dataEndTime*fs);
    time = (dataStartTime:1/fs:dataEndTime) + startTime;
    % [dataStartTime,dataEndTime]
    % length(time)
    % length(dataRange)
    horzOffset = 0.02;
    figure(200);maximize(gcf);set(gcf,'Color','w');clf;
    subplot(711);plot(time,BP(dataRange),'b');hold on
    plot(BPMaxLoc(featureStartIdx:featureEndIdx)+startTime,BPMax(featureStartIdx:featureEndIdx),'go')
    plot(BPMinLoc(featureStartIdx:featureEndIdx)+startTime,-BPMin(featureStartIdx:featureEndIdx),'ro')
    htxt=text(BPMaxLoc(featureStartIdx:featureEndIdx)+startTime+horzOffset,0.95*BPMax(featureStartIdx:featureEndIdx),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
    set(htxt,'Clipping','on')
    ylabel('BP [mmHg]');title(['Subject ' fileName(18:20) '  Event ' num2str(eventIdx) ': ' interventionName '  Feature name: ' featureName]);grid on;grid minor;axis tight
    
    subplot(712);plot(time,sig1(dataRange),'b');hold on
    if ~isempty(sig1MaxLoc)
        plot(sig1MaxLoc(featureStartIdx:featureEndIdx)+startTime,sig1Max(featureStartIdx:featureEndIdx),'go')
        htxt=text(sig1MaxLoc(featureStartIdx:featureEndIdx)+startTime+horzOffset,0.95*sig1Max(featureStartIdx:featureEndIdx),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
        set(htxt,'Clipping','on')
    end
    if ~isempty(sig1MinLoc)
        plot(sig1MinLoc(featureStartIdx:featureEndIdx)+startTime,-sig1Min(featureStartIdx:featureEndIdx),'ro')
    end
    if ~isempty(sig1Feature)
        plot(sig1Feature(featureStartIdx:featureEndIdx,1)+sig1StartTime,sig1Feature(featureStartIdx:featureEndIdx,2),'b^')
        htxt=text(sig1Feature(featureStartIdx:featureEndIdx,1)+sig1StartTime+horzOffset,0.95*sig1Feature(featureStartIdx:featureEndIdx,2),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
        set(htxt,'Clipping','on')
    end
    ylabel(sig1Name);grid on;grid minor;axis tight
    
    subplot(713);plot(time,sig2(dataRange),'b');hold on
    if ~isempty(sig2MaxLoc)
        plot(sig2MaxLoc(featureStartIdx:featureEndIdx)+startTime,sig2Max(featureStartIdx:featureEndIdx),'go')
        htxt=text(sig2MaxLoc(featureStartIdx:featureEndIdx)+startTime+horzOffset,0.95*sig2Max(featureStartIdx:featureEndIdx),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
        set(htxt,'Clipping','on')
    end
    if ~isempty(sig2MinLoc)
        if strcmp(sig2Name,'BCG') == 1
            plot(sig2MinLoc(featureStartIdx:featureEndIdx)+startTime,sig2Min(featureStartIdx:featureEndIdx),'ro')
            plot(BCGMinLoc2(featureStartIdx:featureEndIdx)+startTime,BCGMin2(featureStartIdx:featureEndIdx),'rx')
        else
            plot(sig2MinLoc(featureStartIdx:featureEndIdx)+startTime,sig2Min(featureStartIdx:featureEndIdx),'ro')
        end
    end
    if ~isempty(sig2Feature)
        if strcmp(sig2Name,'ICG') == 1
            plot(sig2Feature(featureStartIdx:featureEndIdx,1)+sig2StartTime,sig2Feature(featureStartIdx:featureEndIdx,2),'b^')
            htxt=text(sig2Feature(featureStartIdx:featureEndIdx,1)+sig2StartTime+horzOffset,0.95*sig2Feature(featureStartIdx:featureEndIdx,2),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
            set(htxt,'Clipping','on')
        end
    end
    ylabel(sig2Name);grid on;grid minor;axis tight
    
    if strcmp(sig2Name,'ECG') ~= 1
        subplot(714);plot(time,ECG(dataRange),'b');hold on
        plot(ECGMaxLoc(featureStartIdx:featureEndIdx)+startTime,ECGMax(featureStartIdx:featureEndIdx),'go')
        htxt=text(ECGMaxLoc(featureStartIdx:featureEndIdx)+startTime+horzOffset,0.95*ECGMax(featureStartIdx:featureEndIdx),cellstr(num2str((featureStartIdx:featureEndIdx)')),'fontsize',7);
        set(htxt,'Clipping','on')
        ylabel('ECG');grid on;grid minor;axis tight
    end
    export_fig(['../../Data2ResultDetail\Subject' fileName(18:20) 'Event' num2str(eventIdx) interventionName ' ' featureName '.png'])
end
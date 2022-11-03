% Earlier version of test20170818.m for feature extraction. Also no longer
% used after GUI (GUI Test folder) is developed.

clear all; close all; clc
addpath('../export_fig')
[~,~,subjectParamXLS] = xlsread('../../Data2\subjectParamXLS');
fileList={'../../Data2\standing--WAV_005-2016-08-10',... %1 bad ECG/ICG
    '../../Data2\wave_006-standing',... %2 bad
    '../../Data2\wave_007-standing',... %3 bad
    '../../Data2\wave_008-standing',... %4 ok [0,1266]~[0,21.1]
    '../../Data2\wave_009-standing',... %5 ok [0,1250]~[0,20.83]
    '../../Data2\wave_010-standing',... %6 [0,1140]~[0,19] ? (High SP) /positive IJ-DP correlation
    '../../Data2\WAVE-011-Standing',... %7 [0,1000]~[0,16.67] bad ECG/BCG/ICG
    '../../Data2\WAVE_012-Standing',... %8 [600,1700]~[10,28.3] BCG might have issues /positive IJ-DP correlation
    '../../Data2\WAVE_013-Standing',... %9 [1190,2400]~[19.83,40] ok
    '../../Data2\WAVE_014-Standing',... %10 [740,2000]~[12.33,33.33] ok
    '../../Data2\WAVE_015-Standing',... %11 no filega
    '../../Data2\WAVE_016-Standing',... %12 no file
    '../../Data2\WAVE_017-Standing',... %13 bad BP
    '../../Data2\WAVE_018-Standing',... %14 no file
    '../../Data2\WAVE_019-Standing',... %15 [340,1800]~[5.67,30] ok
    '../../Data2\WAVE_020-Standing',... %16 [0,1300;2260,2680;2960,3080;3240,3320]~[0,21.67;37.67,44.67;49.33,51.33;54,55.33] ok /positive IJ-DP correlation
    '../../Data2\WAVE_021-Standing',... %17 [0,1800]~[0,30] ok
    '../../Data2\WAVE_022-Standing'}; %18 [0,1600]~[0,26.67] SB data not good
fileIndex = 15;
fileName = fileList{fileIndex};
dataRaw = load(fileName);
data = dataRaw.data;
BPNexfinTemp = data(:,11);
data = data(1:end-250,:);
data(:,11) = BPNexfinTemp(251:end,1);
BPCuff = data(:,1)*100;
BPOsc = data(:,2);
ECG1 = data(:,3);
ECG = data(:,13);
if fileIndex ==15 %sub19
    ECG = -ECG;
elseif fileIndex == 16 %sub20
    ECG=-ECG;
elseif fileIndex == 17 %sub21
    ECG=-ECG;
end
BCG = data(:,4);
if fileIndex == 8
    BCG=-BCG;
end
ICGz = data(:,5);
PPGfoot = data(:,6);
PPGtoe = data(:,7);
PPGear = data(:,8);
PPGfingerClip = data(:,9);
PPGfingerWrap = data(:,10);
BPNexfin = data(:,11)*100;
ICGdzdt = data(:,12);
time=0:0.001:0.001*(length(data)-1);
totalLength=length(data);
fs=1000; % sampling frequency

%%% Filter the signal
[u,v]=butter(1,30/(fs/2));
ECGFiltered=filtfilt(u,v,ECG);
ECG1Filtered=filtfilt(u,v,ECG1);
[u,v]=butter(1,20/(fs/2));
BPNexfinFiltered=filtfilt(u,v,BPNexfin);
% ECG2Filtered=filtfilt(u,v,ECG2);
[u,v]=butter(1,[0.5,10]/(fs/2));
PPGearFiltered=filtfilt(u,v,PPGear);
PPGtoeFiltered=filtfilt(u,v,PPGtoe);
PPGfingerClipFiltered=filtfilt(u,v,PPGfingerClip);
PPGfingerWrapFiltered=filtfilt(u,v,PPGfingerWrap);
BCGFiltered=filtfilt(u,v,BCG);
% [u,v]=butter(5,0.5/(fs/2),'high');
% ICGintegralFiltered=filtfilt(u,v,ICG_integral);
% [u,v]=butter(5,20/(fs/2),'low');
% ICGintegralFiltered=filtfilt(u,v,ICGintegralFiltered);
[u,v]=butter(1,[0.5,20]/(fs/2));
ICGdzdtFiltered=filtfilt(u,v,ICGdzdt);
rate = 25;
dictName2Idx=containers.Map({'BL','SB','MA','CP','PE'},[0,1,2,3,4]);
dictIdx2Name=containers.Map([0,1,2,3,4],{'BL','SB','MA','CP','PE'});
interventionNames={'BL','SB','MA','CP','PE'};

figure(1)
drawnow;
% set(get(handle(gcf),'JavaFrame'),'Maximized',1);
% set(gcf, 'Position', get(0,'Screensize'));
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
maximize(gcf)
set(gcf,'Color','w')
ax1=subplot(7,1,1);
plot(time(1:rate:end),BPNexfin(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),BPNexfinFiltered(1:rate:end))
ylabel('BP Nexfin');ylim([0,200])
ax2=subplot(7,1,2);
plot(time(1:rate:end),PPGtoe(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGtoeFiltered(1:rate:end))
ylabel('PPG toe')
ax3=subplot(7,1,3);
plot(time(1:rate:end),ECG(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),ECGFiltered(1:rate:end))
ylabel('ECG')
ax4=subplot(7,1,4);
plot(time(1:rate:end),ICGdzdt(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),ICGdzdtFiltered(1:rate:end))
ylabel('ICGdzdt')
ax5=subplot(7,1,5);
plot(time(1:rate:end),PPGear(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGearFiltered(1:rate:end))
ylabel('PPGear')
ax6=subplot(7,1,6);
plot(time(1:rate:end),PPGfingerClip(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGfingerClipFiltered(1:rate:end))
ylabel('PPGfinger')
ax7=subplot(7,1,7);
plot(time(1:rate:end),BCG(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),BCGFiltered(1:rate:end));
% plot(time,PPGfingerClipFiltered)
ylabel('BCG')
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'x')

% figure(2)
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% set(gcf,'Color','w')
% subplot(7,1,1);
% plot(time(1:rate:end),ECG1(1:rate:end));hold on
% plot(time(1:rate:end),ECG1Filtered(1:rate:end))

% [PPGtoe_feet_idx, PPGtoe_peak_idx] = ppg_foot(PPGtoeFiltered, fs, 'tan');
% [PPGfinger_feet_idx, PPGfinger_peak_idx] = ppg_foot(PPGfingerClipFiltered, fs, 'tan');
% figure(1)
% subplot(712)
% plot(PPGtoe_feet_idx/fs,PPGtoeFiltered(PPGtoe_feet_idx),'go','MarkerSize',6)
% subplot(716)
% plot(PPGfinger_feet_idx/fs,PPGfingerClipFiltered(PPGfinger_feet_idx),'go','MarkerSize',6)

%%
eventIdx = 1;eventData = {};figIdx = 2;windowSize=120;peakstdThreshold=1.5; %% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! windowSize has changed from 90 to 120!!!!!!!!!!!!!!!!!
IJInfoDetail.data=[];IJInfoDetail.idx=[];JKInfoDetail.data=[];JKInfoDetail.idx=[];
BPMinMinPeakHeight=-120;BPMaxMinPeakHeight=70;minPeakProminenceBPMax=10;minPeakProminenceBPMin=5;
maxP2VDurBP=[0.2,0];maxP2VDurPPGfinger=[0.2,0];maxP2VDurPPGear=[0.3,0];maxP2VDurPPGtoe=[0.3,0];maxP2VDurBCG=[0.25,0];maxP2VDurBCG2=[0,0.3];
maxDurECGMax2BPMin=[0.2,0];maxDurECGMax2BCGMax=[0.06,0.3];maxDurECGMax2PPGtoeMax=[0,0.4];maxDurECGMax2PPGfingerMax=[0,0.6];maxDurECGMax2PPGearMax=[0,0.4];
minPeakProminencePPGfinger=0.4;minPeakProminencePPGear=0.1;minPeakProminencePPGtoe=0.2;minPeakProminenceBCG=0.08;minPeakProminenceECG=0.2;minPeakProminenceBCGMin=0.0003;
minPeakDist=0.4;minPeakDistBCG=0.1;minPeakDistBPMax=0.4;minPeakDistBPMin=minPeakDistBPMax;minPeakDistPPGtoeMax=0.4;minPeakDistPPGtoeMin=minPeakDistPPGtoeMax;
PAT.('PPGfingerECG').data=[];PAT.('PPGearECG').data=[];PAT.('PPGtoeECG').data=[];
PTT.('PPGfingerICG').data=[];PTT.('PPGearICG').data=[];PTT.('PPGtoeICG').data=[];
PTT.('PPGfingerBCG').data=[];PTT.('PPGearBCG').data=[];PTT.('PPGtoeBCG').data=[];
PAT.('PPGfingerECG').BPInfo=[];PAT.('PPGearECG').BPInfo=[];PAT.('PPGtoeECG').BPInfo=[];
PTT.('PPGfingerICG').BPInfo=[];PTT.('PPGearICG').BPInfo=[];PTT.('PPGtoeICG').BPInfo=[];
PTT.('PPGfingerBCG').BPInfo=[];PTT.('PPGearBCG').BPInfo=[];PTT.('PPGtoeBCG').BPInfo=[];
IJInfo.data=[];IJInfo.BPInfo=[];
% if fileIndex ==5 %sub9
%     minPeakProminenceBCG=0.05;
% elseif fileIndex == 6 %sub10
%     maxP2VDurBP=[0.35,0];maxP2VDurPPGfinger=[0.35,0];maxDurBPMin2ECGMax=[0,0.5];minPeakProminenceBCG=0.035;
% elseif fileIndex == 8 %sub12
%     minPeakProminencePPGfinger=0.08;minPeakProminenceBCG=0.05;
% elseif fileIndex ==10 %sub14
%     minPeakProminencePPGear=0.004;maxDurBPMin2ECGMax=[0,0.4];
% elseif fileIndex ==15 %sub19
% elseif fileIndex == 16 %sub20
%     minPeakProminenceECG=0.1;
% end

if fileIndex == 4 %sub8
    minPeakProminencePPGtoe=0.05;maxDurECGMax2PPGtoeMax=[0,0.6];minPeakDistBPMax=0.3;minPeakDistPPGtoeMax=0.4;maxDurECGMax2BCGMax=[0.03,0.45];
    BPMinMinPeakHeight=-150;minPeakProminenceBPMax=5;minPeakProminenceBPMin=1;maxDurECGMax2BPMin=[0.3,0];minPeakDistPPGtoeMin=0.1;
elseif fileIndex ==5 %sub9
    minPeakProminenceBCG=0.05;maxDurECGMax2BPMin=[0.2,0];maxP2VDurPPGfinger=[0.3,0];minPeakProminenceECG=0.1;
    minPeakProminenceBPMax=5;minPeakProminenceBPMin=5;
elseif fileIndex == 6 %sub10
    maxP2VDurBP=[0.35,0];maxDurECGMax2BPMin=[0.2,0];minPeakProminenceBCG=0.035;
    maxP2VDurPPGfinger=[0.45,0];maxP2VDurPPGear=[0.45,0];maxP2VDurPPGtoe=[0.45,0];
elseif fileIndex == 8 %sub12
    minPeakProminencePPGfinger=0.08;maxP2VDurPPGfinger=[0.3,0];minPeakProminenceBCG=0.05;maxDurECGMax2BCGMax=[0.06,0.5];minPeakDistBCG=0.1;
    BPMinMinPeakHeight=-150;BPMaxMinPeakHeight=50;maxP2VDurBP=[0.3,0];
elseif fileIndex == 9 %sub13 ok
    maxP2VDurBCG=[0.3,0];minPeakDistBCG=0.1;BPMinMinPeakHeight=-150;
elseif fileIndex ==10 %sub14 ok
    maxDurECGMax2PPGtoeMax=[0,0.5];minPeakDistBCG=0.1;maxDurECGMax2BCGMax=[0.03,0.3];minPeakProminencePPGear=0.004;maxP2VDurPPGear=[0.25,0];maxDurECGMax2BPMin=[0.2,0];
    maxP2VDurPPGfinger=[0.3,0];minPeakProminencePPGfinger=0.2;maxP2VDurPPGtoe=[0.25,0];minPeakProminenceBPMin=3;
    maxP2VDurBCG=[0.25,0.08];
elseif fileIndex ==15 %sub19 ok
    minPeakDist = 0.3;minPeakDistBPMax=0.4;minPeakDistBPMin=0.1;maxP2VDurBP=[0.25,0];minPeakProminenceBPMin=2;BPMaxMinPeakHeight=50;
    minPeakProminenceECG=0.1;maxDurECGMax2BPMin=[0.2,0];maxDurECGMax2PPGfingerMax=[0,0.6];maxP2VDurPPGfinger=[0.32,0];maxP2VDurPPGtoe=[0.35,0];maxP2VDurPPGear=[0.35,0];
    minPeakDistBCG=0.1;minPeakProminenceBCG=0.02;maxDurECGMax2BCGMax=[0.03,0.4];
elseif fileIndex == 16 %sub20 ok
    minPeakProminenceECG=0.05;maxDurECGMax2BPMin=[0.2,0];minPeakDist=0.3;maxP2VDurPPGfinger=[0.35,0];maxP2VDurBP=[0.4,0];
    minPeakDistBCG=0.1;maxDurECGMax2BCGMax=[0.03,0.4];minPeakProminencePPGtoe=0.08;minPeakProminenceBCGMin=0.01;
    BPMinMinPeakHeight=-150;
elseif fileIndex == 17 %sub21
    minPeakDistBCG=0.1;minPeakProminenceECG=0.1;minPeakProminencePPGfinger=0.15;maxDurECGMax2BCGMax=[0.03,0.4];minPeakProminencePPGtoe=0.1;
    maxP2VDurBCG=[0.25,0.07];
elseif fileIndex ==18 %sub22
    minPeakDistBCG=0.1;minPeakProminenceECG=0.07;maxDurECGMax2BPMin=[0.3,0];minPeakProminencePPGfinger=0.15;maxP2VDurPPGfinger=[0.3,0];maxDurECGMax2PPGfingerMax=[0,0.7];
    minPeakProminenceBPMin=3;minPeakDistBPMin=0.1;maxDurECGMax2PPGtoeMax=[0,0.45];minPeakDistPPGtoeMax=0.2;
    BPMaxMinPeakHeight=30;
end
ToFstr={'False','True'};eventList={};
% eventIdx=6;
while ~isnan(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4}) %eventIdx<=4 %
    name = ['event' num2str(eventIdx)];
    eventData.(name).eventName = subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4};
    eventData.(name).startTime = round(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+1}*60);
    eventData.(name).endTime = round(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+2}*60);
    eventData.(name).note = subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+3};
    interventionName = eventData.(name).eventName; interventionIdx = dictName2Idx(interventionName);
    if eventData.(name).note == 'Y'
        eventList = horzcat(eventList,interventionName);
        startTime = eventData.(name).startTime;
        endTime = eventData.(name).endTime;
%         figure(figIdx);drawnow;set(get(handle(gcf),'JavaFrame'),'Maximized',1);set(gcf,'Color','w');clf
        figure(figIdx);maximize(gcf);set(gcf,'Color','w');clf
%         set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        timesig = (startTime:1/fs:endTime);
        dataRange = startTime*fs:endTime*fs;
        BPsig = BPNexfinFiltered(dataRange);
        ECGsig = ECGFiltered(dataRange);
        BCGsig = BCGFiltered(dataRange);
        ICGdzdtsig = ICGdzdtFiltered(dataRange);
        PPGfingersig = PPGfingerClipFiltered(dataRange);
        PPGearsig = PPGearFiltered(dataRange);
        PPGtoesig = PPGtoeFiltered(dataRange);
        ax11=subplot(711);plot(timesig,ECGsig);ylabel('ECG');title(['Intervention=' eventData.(name).eventName]);hold on;grid on;grid minor;
        [ECGMax,ECGMaxLoc]=findpeaks(ECGsig,fs,'MinPeakHeight',0,'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminenceECG);
        fECGMax=plot(startTime+ECGMaxLoc,ECGMax,'go');
        ax12=subplot(712);plot(timesig,ICGdzdtsig);ylabel('ICG dzdt');hold on;grid on;grid minor;
        [ICGdzdtMax,ICGdzdtMaxLoc]=findpeaks(ICGdzdtsig,fs,'MinPeakHeight',0,'MinPeakDistance',minPeakDist,'MinPeakProminence',0.2);
        fICGMax=plot(startTime+ICGdzdtMaxLoc,ICGdzdtMax,'go');
        ax13=subplot(713);plot(timesig,BPsig);ylabel('BP');hold on;grid on;grid minor;
        [BPMax,BPMaxLoc]=findpeaks(BPsig,fs,'MinPeakHeight',BPMaxMinPeakHeight,'MinPeakDistance',minPeakDistBPMax,'MinPeakProminence',minPeakProminenceBPMax);
        [BPMin,BPMinLoc]=findpeaks(-BPsig,fs,'MinPeakHeight',BPMinMinPeakHeight,'MinPeakDistance',minPeakDistBPMin,'MinPeakProminence',minPeakProminenceBPMin);
        fBPMax=plot(startTime+BPMaxLoc,BPMax,'go');
        fBPMin=plot(startTime+BPMinLoc,-BPMin,'ro');
        [temptime,peakstdval]=peakstd(BPsig,BPMaxLoc,fs,windowSize,startTime);
%         ax14=subplot(714);plot(temptime,peakstdval,'o-');ylabel('peakstd');hold on
        BCGsig=expMA(BCGsig,fix(ECGMaxLoc*fs));
        ax14=subplot(714);plot(timesig,BCGsig);ylabel('BCG');hold on;grid on;grid minor;
        [BCGMax,BCGMaxLoc]=findpeaks(BCGsig,fs,'MinPeakHeight',mean(BCGsig)-0.1,'MinPeakDistance',minPeakDistBCG,'MinPeakProminence',minPeakProminenceBCG);
%         [BCGMin,BCGMinLoc]=findpeaks(-BCGsig,fs,'MinPeakHeight',mean(BCGsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',0.04);
        BCGMax2=BCGMax;BCGMaxLoc2=BCGMaxLoc;
        fBCGMax=plot(startTime+BCGMaxLoc,BCGMax,'go');
        fBCGMax2=plot(startTime+BCGMaxLoc2,BCGMax2,'gx');
%         fBCGMin=plot(startTime+BCGMinLoc,-BCGMin,'ro');
%         plot(timesig,BCGsig2)
        ax15=subplot(715);plot(timesig,PPGfingersig);ylabel('PPG finger');hold on;grid on;grid minor;
        [PPGfingerMax,PPGfingerMaxLoc]=findpeaks(PPGfingersig,fs,'MinPeakHeight',mean(PPGfingersig)-0.5,'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGfinger);
        [PPGfingerMin,PPGfingerMinLoc]=findpeaks(-PPGfingersig,fs,'MinPeakHeight',-mean(PPGfingersig)-0.5,'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGfinger);
        if isempty(PPGfingerMaxLoc) || isempty(PPGfingerMinLoc)
            PPGfingerMaxLoc=NaN(size(BPMaxLoc));PPGfingerMax=NaN(size(BPMaxLoc));PPGfingerMinLoc=NaN(size(BPMaxLoc));PPGfingerMin=NaN(size(BPMaxLoc));
        end
        fPPGfingerMax=plot(startTime+PPGfingerMaxLoc,PPGfingerMax,'go');
        fPPGfingerMin=plot(startTime+PPGfingerMinLoc,-PPGfingerMin,'ro');
        ax16=subplot(716);plot(timesig,PPGearsig);ylabel('PPG ear');hold on;grid on;grid minor;
        [PPGearMax,PPGearMaxLoc]=findpeaks(PPGearsig,fs,'MinPeakHeight',mean(PPGearsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGear);
        [PPGearMin,PPGearMinLoc]=findpeaks(-PPGearsig,fs,'MinPeakHeight',-mean(PPGearsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGear);
        if isempty(PPGearMaxLoc) || isempty(PPGearMinLoc)
            PPGearMaxLoc=NaN(size(BPMaxLoc));PPGearMax=NaN(size(BPMaxLoc));PPGearMinLoc=NaN(size(BPMaxLoc));PPGearMin=NaN(size(BPMaxLoc));
        end
        fPPGearMax=plot(startTime+PPGearMaxLoc,PPGearMax,'go');
        fPPGearMin=plot(startTime+PPGearMinLoc,-PPGearMin,'ro');
        ax17=subplot(717);plot(timesig,PPGtoesig);ylabel('PPGtoe');hold on;grid on;grid minor;
        [PPGtoeMax,PPGtoeMaxLoc]=findpeaks(PPGtoesig,fs,'MinPeakHeight',mean(PPGtoesig),'MinPeakDistance',minPeakDistPPGtoeMax,'MinPeakProminence',minPeakProminencePPGtoe);
        [PPGtoeMin,PPGtoeMinLoc]=findpeaks(-PPGtoesig,fs,'MinPeakHeight',-mean(PPGtoesig),'MinPeakDistance',minPeakDistPPGtoeMin,'MinPeakProminence',minPeakProminencePPGtoe);
        if isempty(PPGtoeMaxLoc) || isempty(PPGtoeMinLoc)
            PPGtoeMaxLoc=NaN(size(BPMaxLoc));PPGtoeMax=NaN(size(BPMaxLoc));PPGtoeMinLoc=NaN(size(BPMaxLoc));PPGtoeMin=NaN(size(BPMaxLoc));
        end
        fPPGtoeMax=plot(startTime+PPGtoeMaxLoc,PPGtoeMax,'go');
        fPPGtoeMin=plot(startTime+PPGtoeMinLoc,-PPGtoeMin,'ro');
        linkaxes([ax11,ax12,ax13,ax14,ax15,ax16,ax17],'x')
        %BCGsig = 
        
        %% PPGfinger Max/Min
        [PPGfingerMaxExcludeMask,PPGfingerMinIncludeMask,~]=alignSignal(PPGfingerMaxLoc,PPGfingerMinLoc,maxP2VDurPPGfinger,'left');
        PPGfingerMaxLoc(PPGfingerMaxExcludeMask==1)=[];
        PPGfingerMax(PPGfingerMaxExcludeMask==1)=[];
        PPGfingerMinLoc=PPGfingerMinLoc(PPGfingerMinIncludeMask==1);
        PPGfingerMin=PPGfingerMin(PPGfingerMinIncludeMask==1);
        fPPGfingerMax.XData = startTime+PPGfingerMaxLoc; fPPGfingerMax.YData = PPGfingerMax;
        fPPGfingerMin.XData = startTime+PPGfingerMinLoc; fPPGfingerMin.YData = -PPGfingerMin;
        
        %% PPGear Max/Min
        [PPGearMaxExcludeMask,PPGearMinIncludeMask,~]=alignSignal(PPGearMaxLoc,PPGearMinLoc,maxP2VDurPPGear,'left');
        PPGearMaxLoc(PPGearMaxExcludeMask==1)=[];
        PPGearMax(PPGearMaxExcludeMask==1)=[];
        PPGearMinLoc=PPGearMinLoc(PPGearMinIncludeMask==1);
        PPGearMin=PPGearMin(PPGearMinIncludeMask==1);
        if isempty(PPGearMaxLoc)
            PPGearMaxLoc=NaN(size(BPMaxLoc));PPGearMax=NaN(size(BPMaxLoc));PPGearMinLoc=NaN(size(BPMaxLoc));PPGearMin=NaN(size(BPMaxLoc));
        end
        fPPGearMax.XData = startTime+PPGearMaxLoc; fPPGearMax.YData = PPGearMax;
        fPPGearMin.XData = startTime+PPGearMinLoc; fPPGearMin.YData = -PPGearMin;
        
        %% PPGtoe Max/Min
        [PPGtoeMaxExcludeMask,PPGtoeMinIncludeMask,~]=alignSignal(PPGtoeMaxLoc,PPGtoeMinLoc,maxP2VDurPPGtoe,'left');
        PPGtoeMaxLoc(PPGtoeMaxExcludeMask==1)=[];
        PPGtoeMax(PPGtoeMaxExcludeMask==1)=[];
        PPGtoeMinLoc=PPGtoeMinLoc(PPGtoeMinIncludeMask==1);
        PPGtoeMin=PPGtoeMin(PPGtoeMinIncludeMask==1);
        if isempty(PPGtoeMaxLoc)
            PPGtoeMaxLoc=NaN(size(BPMaxLoc));PPGtoeMax=NaN(size(BPMaxLoc));PPGtoeMinLoc=NaN(size(BPMaxLoc));PPGtoeMin=NaN(size(BPMaxLoc));
        end
        fPPGtoeMax.XData = startTime+PPGtoeMaxLoc; fPPGtoeMax.YData = PPGtoeMax;
        fPPGtoeMin.XData = startTime+PPGtoeMinLoc; fPPGtoeMin.YData = -PPGtoeMin;
        
        %% BP Max/Min
        BPMax(peakstdval<peakstdThreshold)=[];
        BPMaxLoc(peakstdval<peakstdThreshold)=[];
        fBPMax.XData = startTime+BPMaxLoc; fBPMax.YData = BPMax;
        
        [BPMaxExcludeMask,BPMinIncludeMask,~]=alignSignal(BPMaxLoc,BPMinLoc,maxP2VDurBP,'left');
        BPMaxLoc(BPMaxExcludeMask==1)=[];
        BPMax(BPMaxExcludeMask==1)=[];
        BPMinLoc=BPMinLoc(BPMinIncludeMask==1);
        BPMin=BPMin(BPMinIncludeMask==1);
%         fprintf(['Length of Min and Max are equal for Fig ' num2str(figIdx) ': ' ToFstr{double(length(BPMaxLoc)==length(BPMinLoc))+1} '\n'])
        fBPMax.XData = startTime+BPMaxLoc; fBPMax.YData = BPMax;
        fBPMin.XData = startTime+BPMinLoc; fBPMin.YData = -BPMin;
        subplot(713);htxt=text(startTime+BPMaxLoc,1.05*BPMax,cellstr(num2str((1:length(BPMax))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% BPMin->ECGMax
        [ECGNaNMask,ECGMaxIncludeMask,ECGMap]=alignSignal(BPMinLoc,ECGMaxLoc,maxDurECGMax2BPMin,'left');
        ECGMax=expandSignal(ECGMax,ECGMaxIncludeMask,ECGMap);
        ECGMaxLoc=expandSignal(ECGMaxLoc,ECGMaxIncludeMask,ECGMap);
        fprintf(['Length difference of ECGMax and BPMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(BPMaxLoc(~isnan(BPMaxLoc)))) '\n'])
        fECGMax.XData = startTime+ECGMaxLoc; fECGMax.YData = ECGMax;
        subplot(711);htxt=text(startTime+ECGMaxLoc,1.05*ECGMax,cellstr(num2str((1:length(ECGMax))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% BCG IJ
        [~,BCGMaxIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMaxLoc,maxDurECGMax2BCGMax,'right');
        BCGMax=expandSignal(BCGMax,BCGMaxIncludeMask,BCGMap);
        BCGMaxLoc=expandSignal(BCGMaxLoc,BCGMaxIncludeMask,BCGMap);
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
                    tempExclude = [tempExclude,ii];
                else
                    BCGMinLoc(ii)=(tempStart+minLoc-1)/fs;BCGMin(ii)=BCGsig(tempStart+minLoc-1);
                end
            end
        end
        BCGMaxLoc(tempExclude)=[];BCGMax(tempExclude)=[];
        fBCGMax.XData = startTime+BCGMaxLoc; fBCGMax.YData = BCGMax;
        
        [BCGMaxExcludeMask,BCGMinIncludeMask,~]=alignSignal(BCGMaxLoc,BCGMinLoc,maxP2VDurBCG,'left');
        BCGMaxLoc(BCGMaxExcludeMask==1)=[];
        BCGMax(BCGMaxExcludeMask==1)=[];
        BCGMinLoc=BCGMinLoc(BCGMinIncludeMask==1);
        BCGMin=BCGMin(BCGMinIncludeMask==1);
%         BCGMinLocChanged=BCGMinLocChanged(BCGMinIncludeMask==1);
%         BCGMinChanged=BCGMinChanged(BCGMinIncludeMask==1);
        [~,BCGMaxIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMaxLoc,maxDurECGMax2BCGMax,'right');
        BCGMax=expandSignal(BCGMax,BCGMaxIncludeMask,BCGMap);
        BCGMaxLoc=expandSignal(BCGMaxLoc,BCGMaxIncludeMask,BCGMap);
        BCGMin=expandSignal(BCGMin,BCGMaxIncludeMask,BCGMap);
        BCGMinLoc=expandSignal(BCGMinLoc,BCGMaxIncludeMask,BCGMap);
%         BCGMinChanged=expandSignal(BCGMinChanged,BCGMaxIncludeMask,BCGMap);
%         BCGMinLocChanged=expandSignal(BCGMinLocChanged,BCGMaxIncludeMask,BCGMap);
        minGap = 30; maxPercent = 10;
        [BCGMinLocRefined,BCGMinRefined,BCGMinLocChanged,BCGMinChanged]=refineValley(BCGsig,BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,fs,minGap,maxPercent);
        BCGMinLoc = BCGMinLocRefined; BCGMin = BCGMinRefined;
        subplot(714);plot(startTime+BCGMinLoc,BCGMin,'ro')
        fBCGMax.XData = startTime+BCGMaxLoc; fBCGMax.YData = BCGMax;
%         plot(startTime+BCGMinLocChanged,BCGMinChanged,'rs')
        subplot(714);htxt=text(startTime+BCGMaxLoc,1.05*BCGMax,cellstr(num2str((1:length(BCGMax))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% BCG JK
%         [~,BCGMaxIncludeMask2,BCGMap2]=alignSignal(ECGMaxLoc,BCGMaxLoc2,maxDurECGMax2BCGMax,'right');
%         BCGMax2=expandSignal(BCGMax2,BCGMaxIncludeMask2,BCGMap2);
%         BCGMaxLoc2=expandSignal(BCGMaxLoc2,BCGMaxIncludeMask2,BCGMap2);
        BCGMax2=BCGMax; BCGMaxLoc2=BCGMaxLoc;
        BCGMinLoc2=NaN(size(BCGMaxLoc2));BCGMin2=NaN(size(BCGMaxLoc2));
        for ii = 1:min(length(ECGMaxLoc),length(BCGMaxLoc2))-1
            if ~isnan(BCGMaxLoc2(ii)) && BCGMaxLoc2(ii)-ECGMaxLoc(ii)>20/fs
                tempStart=round(BCGMaxLoc2(ii)*fs)+1;tempEnd=min([round(ECGMaxLoc(ii+1)*fs)+1,round(tempStart+0.25*fs)]);
                if tempEnd-tempStart+1<=10
                    minLoc = [];
                else
                    [~,minLocs]=findpeaks(-BCGsig(tempStart:tempEnd),'MinPeakHeight',-2,'MinPeakDistance',0.01,'MinPeakProminence',0.002);
                    if isempty(minLocs)
                        minLoc = [];
                    else
                        minLoc = minLocs(1);
                    end
                end
                if isempty(minLoc) || minLoc >= length(tempStart:tempEnd)-10 
                    tempExclude = [tempExclude,ii];
                else
                    BCGMinLoc2(ii)=(tempStart+minLoc-1)/fs;BCGMin2(ii)=BCGsig(tempStart+minLoc-1);
                end
            end
        end
%         BCGMaxLoc2(tempExclude)=[];BCGMax2(tempExclude)=[];
%         fBCGMax2.XData = startTime+BCGMaxLoc2; fBCGMax2.YData = BCGMax2;
%         [BCGMaxExcludeMask2,BCGMinIncludeMask2,~]=alignSignal(BCGMaxLoc2,BCGMinLoc2,maxP2VDurBCG2,'right');
%         BCGMaxLoc2(BCGMaxExcludeMask2==1)=[];
%         BCGMax2(BCGMaxExcludeMask2==1)=[];
%         BCGMinLoc2=BCGMinLoc2(BCGMinIncludeMask2==1);
%         BCGMin2=BCGMin2(BCGMinIncludeMask2==1);
%         fBCGMax2.XData = startTime+BCGMaxLoc2; fBCGMax2.YData = BCGMax2;
%         [~,BCGMaxIncludeMask2,BCGMap2]=alignSignal(ECGMaxLoc,BCGMaxLoc2,maxDurECGMax2BCGMax,'right');
%         BCGMax2=expandSignal(BCGMax2,BCGMaxIncludeMask2,BCGMap2);
%         BCGMaxLoc2=expandSignal(BCGMaxLoc2,BCGMaxIncludeMask2,BCGMap2);
%         BCGMin2=expandSignal(BCGMin2,BCGMaxIncludeMask2,BCGMap2);
%         BCGMinLoc2=expandSignal(BCGMinLoc2,BCGMaxIncludeMask2,BCGMap2);
        subplot(714);plot(startTime+BCGMinLoc2,BCGMin2,'rx')
        fBCGMax2.XData = startTime+BCGMaxLoc2; fBCGMax2.YData = BCGMax2;
        subplot(714);htxt=text(startTime+BCGMinLoc2,0.95*BCGMin2,cellstr(num2str((1:length(BCGMin2))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGfingerMax
        [~,PPGfingerMaxIncludeMask,PPGfingerMap]=alignSignal(ECGMaxLoc,PPGfingerMaxLoc,maxDurECGMax2PPGfingerMax,'right');
        PPGfingerMax=expandSignal(PPGfingerMax,PPGfingerMaxIncludeMask,PPGfingerMap);
        PPGfingerMaxLoc=expandSignal(PPGfingerMaxLoc,PPGfingerMaxIncludeMask,PPGfingerMap);
        PPGfingerMin=expandSignal(PPGfingerMin,PPGfingerMaxIncludeMask,PPGfingerMap);
        PPGfingerMinLoc=expandSignal(PPGfingerMinLoc,PPGfingerMaxIncludeMask,PPGfingerMap);
        fprintf(['Length difference of ECGMax and PPGfingerMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfingerMaxLoc(~isnan(PPGfingerMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGfingerMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfingerMinLoc(~isnan(PPGfingerMinLoc)))) '\n'])
        fPPGfingerMax.XData = startTime+PPGfingerMaxLoc; fPPGfingerMax.YData = PPGfingerMax;
        fPPGfingerMin.XData = startTime+PPGfingerMinLoc; fPPGfingerMin.YData = -PPGfingerMin;
        subplot(715);htxt=text(startTime+PPGfingerMaxLoc,1.05*PPGfingerMax,cellstr(num2str((1:length(PPGfingerMax))')),'fontsize',7);set(htxt,'Clipping','on')
        PPGfingerfoot=findFoot(PPGfingersig,PPGfingerMin,PPGfingerMaxLoc,PPGfingerMinLoc,ECGMaxLoc,startTime,fs);
        subplot(715);plot(PPGfingerfoot(:,1),PPGfingerfoot(:,2),'b^');
        subplot(715);htxt=text(PPGfingerfoot(:,1),0.95*PPGfingerfoot(:,2),cellstr(num2str((1:length(PPGfingerfoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGearMax
        [~,PPGearMaxIncludeMask,PPGearMap]=alignSignal(ECGMaxLoc,PPGearMaxLoc,maxDurECGMax2PPGearMax,'right');
        PPGearMax=expandSignal(PPGearMax,PPGearMaxIncludeMask,PPGearMap);
        PPGearMaxLoc=expandSignal(PPGearMaxLoc,PPGearMaxIncludeMask,PPGearMap);
        PPGearMin=expandSignal(PPGearMin,PPGearMaxIncludeMask,PPGearMap);
        PPGearMinLoc=expandSignal(PPGearMinLoc,PPGearMaxIncludeMask,PPGearMap);
        fprintf(['Length difference of ECGMax and PPGearMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGearMaxLoc(~isnan(PPGearMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGearMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGearMinLoc(~isnan(PPGearMinLoc)))) '\n'])
        fPPGearMax.XData = startTime+PPGearMaxLoc; fPPGearMax.YData = PPGearMax;
        fPPGearMin.XData = startTime+PPGearMinLoc; fPPGearMin.YData = -PPGearMin;
        subplot(716);htxt=text(startTime+PPGearMaxLoc,1.05*PPGearMax,cellstr(num2str((1:length(PPGearMax))')),'fontsize',7);set(htxt,'Clipping','on')
        PPGearfoot=findFoot(PPGearsig,PPGearMin,PPGearMaxLoc,PPGearMinLoc,ECGMaxLoc,startTime,fs);
        subplot(716);plot(PPGearfoot(:,1),PPGearfoot(:,2),'b^');
        subplot(716);htxt=text(PPGearfoot(:,1),0.95*PPGearfoot(:,2),cellstr(num2str((1:length(PPGearfoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGtoeMax
        [~,PPGtoeMaxIncludeMask,PPGtoeMap]=alignSignal(ECGMaxLoc,PPGtoeMaxLoc,maxDurECGMax2PPGtoeMax,'right');
        PPGtoeMax=expandSignal(PPGtoeMax,PPGtoeMaxIncludeMask,PPGtoeMap);
        PPGtoeMaxLoc=expandSignal(PPGtoeMaxLoc,PPGtoeMaxIncludeMask,PPGtoeMap);
        PPGtoeMin=expandSignal(PPGtoeMin,PPGtoeMaxIncludeMask,PPGtoeMap);
        PPGtoeMinLoc=expandSignal(PPGtoeMinLoc,PPGtoeMaxIncludeMask,PPGtoeMap);
        fprintf(['Length difference of ECGMax and PPGtoeMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGtoeMaxLoc(~isnan(PPGtoeMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGtoeMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGtoeMinLoc(~isnan(PPGtoeMinLoc)))) '\n'])
        fPPGtoeMax.XData = startTime+PPGtoeMaxLoc; fPPGtoeMax.YData = PPGtoeMax;
        fPPGtoeMin.XData = startTime+PPGtoeMinLoc; fPPGtoeMin.YData = -PPGtoeMin;
        subplot(717);htxt=text(startTime+PPGtoeMaxLoc,1.05*PPGtoeMax,cellstr(num2str((1:length(PPGtoeMax))')),'fontsize',7);set(htxt,'Clipping','on')
        PPGtoefoot=findFoot(PPGtoesig,PPGtoeMin,PPGtoeMaxLoc,PPGtoeMinLoc,ECGMaxLoc,startTime,fs);
        subplot(717);plot(PPGtoefoot(:,1),PPGtoefoot(:,2),'b^');
        subplot(717);htxt=text(PPGtoefoot(:,1),0.95*PPGtoefoot(:,2),cellstr(num2str((1:length(PPGtoefoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> ICGMax
        [~,ICGdzdtMaxIncludeMask,ICGdzdtMap]=alignSignal(ECGMaxLoc,ICGdzdtMaxLoc,[0,0.3],'right');
        ICGdzdtMax=expandSignal(ICGdzdtMax,ICGdzdtMaxIncludeMask,ICGdzdtMap);
        ICGdzdtMaxLoc=expandSignal(ICGdzdtMaxLoc,ICGdzdtMaxIncludeMask,ICGdzdtMap);
        fICGMax.XData = startTime+ICGdzdtMaxLoc; fICGMax.YData = ICGdzdtMax;
        subplot(712);htxt=text(startTime+ICGdzdtMaxLoc,1.05*ICGdzdtMax,cellstr(num2str((1:length(ICGdzdtMax))')),'fontsize',7);set(htxt,'Clipping','on')
        fprintf(['Length difference of ECGMax and ICGdzdtMax for Fig ' num2str(figIdx) ': ' num2str(length(BPMaxLoc)-length(ICGdzdtMaxLoc)) '\n'])
        
        ICGBpoint = NaN(length(ICGdzdtMaxLoc),2);
        for idx = 1:min(length(ECGMaxLoc),length(ICGdzdtMaxLoc))
            tempTime = (startTime + (ECGMaxLoc(idx):1/fs:ICGdzdtMaxLoc(idx)))';
            tempTimeRel = (ECGMaxLoc(idx):1/fs:ICGdzdtMaxLoc(idx))';
            if isnan(tempTime)
                continue
            else
                tempIdxs = fix(tempTimeRel*fs); 
                [xi,yi]=polyxpoly(tempTime,zeros(size(tempTime)),tempTime,ICGdzdtsig(tempIdxs));
                if isempty(xi)
                    continue
                else
                    ICGBpoint(idx,:)=[xi(end),yi(end)];
                end
            end
        end
        subplot(712);plot(ICGBpoint(:,1),ICGBpoint(:,2),'b^')
        subplot(712);htxt=text(ICGBpoint(:,1),1.05*ICGBpoint(:,2),cellstr(num2str((1:length(ICGBpoint))')),'fontsize',7);set(htxt,'Clipping','on')
        
        export_fig(['../../Data2Result\Subject' fileName(18:20) 'Event' num2str(eventIdx) 'Sep.png'])
%         savefig(['../../Data2Result\Subject' fileName(18:20) 'Event' num2str(eventIdx) 'Sep.fig'])
        
        [temp,BPInfo]=calcTime(ECGMaxLoc(:,1),PPGfingerfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PAT.('PPGfingerECG').data = [PAT.('PPGfingerECG').data;temp];
        PAT.('PPGfingerECG').BPInfo = [PAT.('PPGfingerECG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfingersig,'PPGfinger',PPGfingerMaxLoc,PPGfingerMax,PPGfingerMinLoc,PPGfingerMin,PPGfingerfoot,0,...
            ECGsig,'ECG',ECGMaxLoc,ECGMax,[],[],[],0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfingerECG')
        [temp,BPInfo]=calcTime(ECGMaxLoc(:,1),PPGearfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PAT.('PPGearECG').data = [PAT.('PPGearECG').data;temp];
        PAT.('PPGearECG').BPInfo = [PAT.('PPGearECG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGearsig,'PPGear',PPGearMaxLoc,PPGearMax,PPGearMinLoc,PPGearMin,PPGearfoot,0,...
            ECGsig,'ECG',ECGMaxLoc,ECGMax,[],[],[],0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGearECG')
        [temp,BPInfo]=calcTime(ECGMaxLoc(:,1),PPGtoefoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PAT.('PPGtoeECG').data = [PAT.('PPGtoeECG').data;temp];
        PAT.('PPGtoeECG').BPInfo = [PAT.('PPGtoeECG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGtoesig,'PPGtoe',PPGtoeMaxLoc,PPGtoeMax,PPGtoeMinLoc,PPGtoeMin,PPGtoefoot,0,...
            ECGsig,'ECG',ECGMaxLoc,ECGMax,[],[],[],0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGtoeECG')
        [temp,BPInfo]=calcTime(ICGBpoint(:,1),PPGfingerfoot(:,1),[],BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGfingerICG').data = [PTT.('PPGfingerICG').data;temp];
        PTT.('PPGfingerICG').BPInfo = [PTT.('PPGfingerICG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfingersig,'PPGfinger',PPGfingerMaxLoc,PPGfingerMax,PPGfingerMinLoc,PPGfingerMin,PPGfingerfoot,0,...
            ICGdzdtsig,'ICG',ICGdzdtMaxLoc,ICGdzdtMax,[],[],ICGBpoint,0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfingerICG')
        [temp,BPInfo]=calcTime(ICGBpoint(:,1),PPGearfoot(:,1),[],BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGearICG').data = [PTT.('PPGearICG').data;temp];
        PTT.('PPGearICG').BPInfo = [PTT.('PPGearICG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGearsig,'PPGear',PPGearMaxLoc,PPGearMax,PPGearMinLoc,PPGearMin,PPGearfoot,0,...
            ICGdzdtsig,'ICG',ICGdzdtMaxLoc,ICGdzdtMax,[],[],ICGBpoint,0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGearICG')
        [temp,BPInfo]=calcTime(ICGBpoint(:,1),PPGtoefoot(:,1),[],BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGtoeICG').data = [PTT.('PPGtoeICG').data;temp];
        PTT.('PPGtoeICG').BPInfo = [PTT.('PPGtoeICG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGtoesig,'PPGtoe',PPGtoeMaxLoc,PPGtoeMax,PPGtoeMinLoc,PPGtoeMin,PPGtoefoot,0,...
            ICGdzdtsig,'ICG',ICGdzdtMaxLoc,ICGdzdtMax,[],[],ICGBpoint,0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGtoeICG')
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),PPGfingerfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGfingerBCG').data = [PTT.('PPGfingerBCG').data;temp];
        PTT.('PPGfingerBCG').BPInfo = [PTT.('PPGfingerBCG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfingersig,'PPGfinger',PPGfingerMaxLoc,PPGfingerMax,PPGfingerMinLoc,PPGfingerMin,PPGfingerfoot,0,...
            BCGsig,'BCG',BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,[],0,BCGMinLoc2,BCGMin2,ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfingerBCG')
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),PPGearfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGearBCG').data = [PTT.('PPGearBCG').data;temp];
        PTT.('PPGearBCG').BPInfo = [PTT.('PPGearBCG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGearsig,'PPGear',PPGearMaxLoc,PPGearMax,PPGearMinLoc,PPGearMin,PPGearfoot,0,...
            BCGsig,'BCG',BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,[],0,BCGMinLoc2,BCGMin2,ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGearBCG')
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),PPGtoefoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGtoeBCG').data = [PTT.('PPGtoeBCG').data;temp];
        PTT.('PPGtoeBCG').BPInfo = [PTT.('PPGtoeBCG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGtoesig,'PPGtoe',PPGtoeMaxLoc,PPGtoeMax,PPGtoeMinLoc,PPGtoeMin,PPGtoefoot,0,...
            BCGsig,'BCG',BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,[],0,BCGMinLoc2,BCGMin2,ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGtoeBCG')
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),BCGMaxLoc(:,1),0,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        IJInfo.data = [IJInfo.data;temp];
        IJInfo.BPInfo = [IJInfo.BPInfo;eventIdx*ones(1,6);BPInfo];
        
        
        
        [tempBPInfo,~]=extractBP(BPMaxLoc,BCGMinLoc,BCGMaxLoc,BPMax,BPMin,5,10,interventionIdx,'fixed-length');
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
%             loc = calcPercentile(tempBPInfo(:,4),[0,5],'continuous');
            [~,loc]=min(tempBPInfo(:,4));
            idxRange = tempBPInfo(loc,1):tempBPInfo(loc,2);
        else
%             loc = calcPercentile(tempBPInfo(:,4),[95,100],'continuous');
            [~,loc]=max(tempBPInfo(:,4));
            idxRange = tempBPInfo(loc,1):tempBPInfo(loc,2);
        end
        IJInfoDetail.idx = [IJInfoDetail.idx;size(IJInfoDetail.data,1)+2,size(IJInfoDetail.data,1)+2+length(idxRange)-1,idxRange(1),idxRange(end)];
        IJInfoDetail.data = [IJInfoDetail.data;eventIdx,eventIdx;BCGMaxLoc(idxRange,1)-BCGMinLoc(idxRange,1),-BPMin(idxRange,1)];
        
        [tempBPInfo,~]=extractBP(BPMaxLoc,BCGMinLoc2,BCGMaxLoc2,BPMax,BPMin,5,10,interventionIdx,'fixed-length');
        if strcmp(interventionName,'BL')==1 || strcmp(interventionName,'SB')==1
%             loc = calcPercentile(tempBPInfo(:,4),[0,5],'continuous');
            [~,loc]=min(tempBPInfo(:,4));
            idxRange = tempBPInfo(loc,1):tempBPInfo(loc,2);
        else
%             loc = calcPercentile(tempBPInfo(:,4),[95,100],'continuous');
            [~,loc]=max(tempBPInfo(:,4));
            idxRange = tempBPInfo(loc,1):tempBPInfo(loc,2);
        end
        JKInfoDetail.idx = [JKInfoDetail.idx;size(JKInfoDetail.data,1)+2,size(JKInfoDetail.data,1)+2+length(idxRange)-1,idxRange(1),idxRange(end)];
        JKInfoDetail.data = [JKInfoDetail.data;eventIdx,eventIdx;BCGMax2(idxRange,1)-BCGMin2(idxRange,1),BPMax(idxRange,1)+BPMin(idxRange,1)];
        
%         figure(200);maximize(gcf);set(gcf,'Color','w');clf
        
        
        figIdx = figIdx+1;
    end
    
    
    
    eventIdx = eventIdx+1;
    
end

% subjectInfoTbl=array2table(subjectInfo,'VariableNames',{'SP','DP','ItvnIdx','PTTfinger','PTTear','PTTtoe','PATfinger','PATear','PATtoe'});
% figure(100);maximize(gcf);set(gcf,'Color','w')
% subplot(451);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTfinger'},'bo');xlabel('SP');ylabel('PTT finger')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTfinger'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(452);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTfinger'},'bo');xlabel('DP');ylabel('PTT finger')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTfinger'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(453);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATfinger'},'bo');xlabel('SP');ylabel('PAT finger')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATfinger'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(454);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATfinger'},'bo');xlabel('DP');ylabel('PAT finger')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATfinger'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% 
% subplot(456);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTear'},'bo');xlabel('SP');ylabel('PTT ear')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTear'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(457);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTear'},'bo');xlabel('DP');ylabel('PTT ear')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PTTear'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(458);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATear'},'bo');xlabel('SP');ylabel('PAT ear')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'SP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATear'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')
% subplot(459);plot(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATear'},'bo');xlabel('DP');ylabel('PAT ear')
% htxt=text(subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'DP'},subjectInfoTbl{subjectInfoTbl{:,'SP'}~=0,'PATear'}*1.01,eventList,'fontsize',7);set(htxt,'Clipping','on')

correlations = [];
PATnames={'PPGfingerECG','PPGearECG','PPGtoeECG'};
PTTnames={'PPGfingerICG','PPGearICG','PPGtoeICG','PPGfingerBCG','PPGearBCG','PPGtoeBCG'};
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
    correlations = [correlations;PAT.(PATname).correlation];
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
    correlations = [correlations;PTT.(PTTname).correlation];
end
if ~all(isnan(IJInfo.data(:,1))) && ~all(isnan(IJInfo.data(:,2)))
    temp=corrcoef(IJInfo.data(:,1),IJInfo.data(:,2),'rows','complete');
    temp2=corrcoef(IJInfo.data(:,1),IJInfo.data(:,3),'rows','complete');
    if length(temp)==1 || length(temp2)==1
        IJInfo.correlation = [0,0];
    else
        IJInfo.correlation = [temp(1,2),temp2(1,2)];
    end
else
    IJInfo.correlation = [0,0];
end
correlations = [correlations;IJInfo.correlation];
%%
% eventList = eventListCopy;
BLcounter = 1;eventListCopy=eventList;
for ii = 1:length(eventList)
    if strcmp(eventList{ii},'BL') == 1
        eventList{ii} = ['BL' num2str(BLcounter)];
        BLcounter = BLcounter+1;
    end
end
% eventList
%%
figure(102);maximize(gcf);set(gcf,'Color','w');legendFontSize=7.5;grid on;grid minor
subplot(561);plot(PAT.('PPGfingerECG').data(:,1),PAT.('PPGfingerECG').data(:,2),'bo');xlabel('PATfinger/ECG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGfingerECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGfingerECG').data(:,1),PAT.('PPGfingerECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(562);plot(PAT.('PPGfingerECG').data(:,1),PAT.('PPGfingerECG').data(:,3),'bo');xlabel('PATfinger/ECG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGfingerECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGfingerECG').data(:,1),PAT.('PPGfingerECG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(563);plot(PAT.('PPGearECG').data(:,1),PAT.('PPGearECG').data(:,2),'bo');xlabel('PATear/ECG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGearECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGearECG').data(:,1),PAT.('PPGearECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(564);plot(PAT.('PPGearECG').data(:,1),PAT.('PPGearECG').data(:,3),'bo');xlabel('PATear/ECG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGearECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGearECG').data(:,1),PAT.('PPGearECG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(565);plot(PAT.('PPGtoeECG').data(:,1),PAT.('PPGtoeECG').data(:,2),'bo');xlabel('PATtoe/ECG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGtoeECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGtoeECG').data(:,1),PAT.('PPGtoeECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(566);plot(PAT.('PPGtoeECG').data(:,1),PAT.('PPGtoeECG').data(:,3),'bo');xlabel('PATtoe/ECG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGtoeECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGtoeECG').data(:,1),PAT.('PPGtoeECG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(567);plot(PTT.('PPGfingerICG').data(:,1),PTT.('PPGfingerICG').data(:,2),'bo');xlabel('PTTfinger/ICG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfingerICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfingerICG').data(:,1),PTT.('PPGfingerICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(568);plot(PTT.('PPGfingerICG').data(:,1),PTT.('PPGfingerICG').data(:,3),'bo');xlabel('PTTfinger/ICG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfingerICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfingerICG').data(:,1),PTT.('PPGfingerICG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(569);plot(PTT.('PPGearICG').data(:,1),PTT.('PPGearICG').data(:,2),'bo');xlabel('PTTear/ICG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGearICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGearICG').data(:,1),PTT.('PPGearICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,10);plot(PTT.('PPGearICG').data(:,1),PTT.('PPGearICG').data(:,3),'bo');xlabel('PTTear/ICG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGearICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGearICG').data(:,1),PTT.('PPGearICG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,6,11);plot(PTT.('PPGtoeICG').data(:,1),PTT.('PPGtoeICG').data(:,2),'bo');xlabel('PTTtoe/ICG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGtoeICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGtoeICG').data(:,1),PTT.('PPGtoeICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,12);plot(PTT.('PPGtoeICG').data(:,1),PTT.('PPGtoeICG').data(:,3),'bo');xlabel('PTTtoe/ICG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGtoeICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGtoeICG').data(:,1),PTT.('PPGtoeICG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,6,13);plot(PTT.('PPGfingerBCG').data(:,1),PTT.('PPGfingerBCG').data(:,2),'bo');xlabel('PTTfinger/BCG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfingerBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfingerBCG').data(:,1),PTT.('PPGfingerBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,14);plot(PTT.('PPGfingerBCG').data(:,1),PTT.('PPGfingerBCG').data(:,3),'bo');xlabel('PTTfinger/BCG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfingerBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfingerBCG').data(:,1),PTT.('PPGfingerBCG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,6,15);plot(PTT.('PPGearBCG').data(:,1),PTT.('PPGearBCG').data(:,2),'bo');xlabel('PTTear/BCG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGearBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGearBCG').data(:,1),PTT.('PPGearBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,16);plot(PTT.('PPGearBCG').data(:,1),PTT.('PPGearBCG').data(:,3),'bo');xlabel('PTTear/BCG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGearBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGearBCG').data(:,1),PTT.('PPGearBCG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,6,17);plot(PTT.('PPGtoeBCG').data(:,1),PTT.('PPGtoeBCG').data(:,2),'bo');xlabel('PTTtoe/BCG [sec]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGtoeBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGtoeBCG').data(:,1),PTT.('PPGtoeBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,18);plot(PTT.('PPGtoeBCG').data(:,1),PTT.('PPGtoeBCG').data(:,3),'bo');xlabel('PTTtoe/BCG [sec]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGtoeBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGtoeBCG').data(:,1),PTT.('PPGtoeBCG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,6,19);plot(IJInfo.data(:,1),IJInfo.data(:,2),'bo');xlabel('I-J Interval [sec]');ylabel('SP [mmHg]');title(['r=' num2str(IJInfo.correlation(1))])
grid on;grid minor
htxt=text(IJInfo.data(:,1),IJInfo.data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,6,20);plot(IJInfo.data(:,1),IJInfo.data(:,3),'bo');xlabel('I-J Interval [sec]');ylabel('DP [mmHg]');title(['r=' num2str(IJInfo.correlation(2))])
grid on;grid minor
htxt=text(IJInfo.data(:,1),IJInfo.data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,6,25);plot(1:length(PAT.('PPGfingerECG').data(:,2)),PAT.('PPGfingerECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGfingerICG').data(:,2)),PTT.('PPGfingerICG').data(:,2),'o-');
plot(1:length(PTT.('PPGfingerBCG').data(:,2)),PTT.('PPGfingerBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfingerECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,6,26);plot(1:length(PAT.('PPGfingerECG').data(:,3)),PAT.('PPGfingerECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGfingerICG').data(:,3)),PTT.('PPGfingerICG').data(:,3),'o-');
plot(1:length(PTT.('PPGfingerBCG').data(:,3)),PTT.('PPGfingerBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfingerECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,6,27);plot(1:length(PAT.('PPGearECG').data(:,2)),PAT.('PPGearECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGearICG').data(:,2)),PTT.('PPGearICG').data(:,2),'o-');
plot(1:length(PTT.('PPGearBCG').data(:,2)),PTT.('PPGearBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGearECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,6,28);plot(1:length(PAT.('PPGearECG').data(:,3)),PAT.('PPGearECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGearICG').data(:,3)),PTT.('PPGearICG').data(:,3),'o-');
plot(1:length(PTT.('PPGearBCG').data(:,3)),PTT.('PPGearBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGearECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,6,29);plot(1:length(PAT.('PPGtoeECG').data(:,2)),PAT.('PPGtoeECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGtoeICG').data(:,2)),PTT.('PPGtoeICG').data(:,2),'o-');
plot(1:length(PTT.('PPGtoeBCG').data(:,2)),PTT.('PPGtoeBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGtoeECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,6,30);plot(1:length(PAT.('PPGtoeECG').data(:,3)),PAT.('PPGtoeECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGtoeICG').data(:,3)),PTT.('PPGtoeICG').data(:,3),'o-');
plot(1:length(PTT.('PPGtoeBCG').data(:,3)),PTT.('PPGtoeBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGtoeECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
export_fig(['../../Data2Result\Subject' fileName(18:20) 'Total.png'])
%%
if exist(['../../Data2Result\TotalCorrelation.mat'],'file')
    load '../../Data2Result\TotalCorrelation.mat'
end
TotalCorrelation(1:10,1:2,str2double(fileName(18:20))) = correlations;
save(['../../Data2Result\TotalCorrelation.mat'],'TotalCorrelation')
%%
notZeros = any(TotalCorrelation,1);
notZeros = double(squeeze(notZeros))';
notZeros([10,12,20],:)=0;
totalSubjectNum = sum(double(notZeros(:,1)~=0));
[nanmean(TotalCorrelation(:,:,notZeros(:,1)==1),3),nanstd(TotalCorrelation(:,:,notZeros(:,1)==1),0,3)./sqrt(sum(double(TotalCorrelation~=0 & ~isnan(TotalCorrelation)),3))]

%%
figure(103);maximize(gcf);set(gcf,'Color','w')
tempIdx=1;
for ii = 1:length(eventList)
    tempRangeIJ=IJInfoDetail.idx(ii,1):IJInfoDetail.idx(ii,2);
    idxRange = IJInfoDetail.idx(ii,3):IJInfoDetail.idx(ii,4);
    subplot(4,5,tempIdx);plot(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),'o')
    subplot(4,5,tempIdx);text(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),cellstr(num2str((idxRange)')),'fontsize',7)
    if ~all(isnan(IJInfoDetail.data(tempRangeIJ,1))) && ~all(isnan(IJInfoDetail.data(tempRangeIJ,2)))
        temp=corrcoef(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),'rows','complete');
        if length(temp)==1
            IJcorrelation = 0;
        else
            IJcorrelation = temp(1,2);
        end
    else
        IJcorrelation = 0;
    end
    xlabel('I-J Interval [sec]');ylabel('DP [mmHg]');title([eventList{ii} ', r=' num2str(IJcorrelation)])
    
    
    tempRangeJK=JKInfoDetail.idx(ii,1):JKInfoDetail.idx(ii,2);
    idxRange = JKInfoDetail.idx(ii,3):JKInfoDetail.idx(ii,4);
    subplot(4,5,10+tempIdx);plot(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),'o')
    subplot(4,5,10+tempIdx);text(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),cellstr(num2str((idxRange)')),'fontsize',7)
    if ~all(isnan(JKInfoDetail.data(tempRangeJK,1))) && ~all(isnan(JKInfoDetail.data(tempRangeJK,2)))
        temp=corrcoef(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),'rows','complete');
        if length(temp)==1
            JKcorrelation = 0;
        else
            JKcorrelation = temp(1,2);
        end
    else
        JKcorrelation = 0;
    end
    xlabel('J-K Amplitude');ylabel('PP [mmHg]');title([eventList{ii} ', r=' num2str(JKcorrelation)])
    tempIdx = tempIdx+1;
end
export_fig(['../../Data2Result\Subject' fileName(18:20) 'IJ_JK Info.png'])
% save(['../../Data2Result\Subject' fileName(18:20) '_PAT'],'PAT')
% save(['../../Data2Result\Subject' fileName(18:20) '_PTT'],'PTT')
% save(['../../Data2Result\Subject' fileName(18:20) '_IJInfo'],'IJInfo')
% save(['../../Data2Result\Subject' fileName(18:20) '_JKInfo'],'JKInfo')

% subplot(455);arrow([0,1;1,1],[1,2;2,2])


% figure(20)
% for ii=1:minLen
%     plot(BPMax(ii),PAT(ii),'bo');
%     axis([85 140 0.19 0.3])
%     hold on
%     pause(0.2)
% end


% figure(100)
% peakstd=zeros(size(BPMaxLoc));
% for ii=1:length(BPMaxLoc)
%     locIdx=fix((BPMaxLoc(ii))*fs);
%     peakstd(ii)=std(BPsig(max(1,locIdx)-90:min(locIdx,length(BPsig))+90));
% end
% plot(peakstd)
    
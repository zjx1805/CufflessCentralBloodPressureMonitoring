% Study the correlation between PAT/scale PTT/ICG-based PTT and DP/SP.
% Since the parameters used for feature extraction is fixed, there are
% inevitably some bad features or missing features. So I developed the GUI
% (GUI Test folder) to solve this issue by allowing different parameters at
% different locations. Thus, this code is no longer used.

clear all; close all; clc
addpath('../export_fig')
[~,~,subjectParamXLS] = xlsread('../../Data2\subjectParamXLS');
fileList={'../../Data2\standing--WAV_005-2016-08-10';... %1 bad ECG/ICG
    '../../Data2\wave_006-standing';... %2 bad
    '../../Data2\wave_007-standing';... %3 bad
    '../../Data2\wave_008-standing';... %4 ok [0,1266]~[0,21.1]
    '../../Data2\wave_009-standing';... %5 ok [0,1250]~[0,20.83]
    '../../Data2\wave_010-standing';... %6 [0,1140]~[0,19] ? (High SP) /positive IJ-DP correlation
    '../../Data2\WAVE-011-Standing';... %7 [0,1000]~[0,16.67] bad ECG/BCG/ICG
    '../../Data2\WAVE_012-Standing';... %8 [600,1700]~[10,28.3] BCG might have issues /positive IJ-DP correlation
    '../../Data2\WAVE_013-Standing';... %9 [1190,2400]~[19.83,40] ok
    '../../Data2\WAVE_014-Standing';... %10 [740,2000]~[12.33,33.33] ok
    '../../Data2\WAVE_015-Standing';... %11 no file
    '../../Data2\WAVE_016-Standing';... %12 no file
    '../../Data2\WAVE_017-Standing';... %13 bad BP
    '../../Data2\WAVE_018-Standing';... %14 no file
    '../../Data2\WAVE_019-Standing';... %15 [340,1800]~[5.67,30] ok
    '../../Data2\WAVE_020-Standing';... %16 [0,1300;2260,2680;2960,3080;3240,3320]~[0,21.67;37.67,44.67;49.33,51.33;54,55.33] ok /positive IJ-DP correlation
    '../../Data2\WAVE_021-Standing';... %17 [0,1800]~[0,30] ok
    '../../Data2\WAVE_022-Standing';... %18 [0,1600]~[0,26.67] SB data not good
    '../../Data2\WAVE_023-Standing-Segment-1';... %19 Only[0~400]sec usable
    '../../Data2\WAVE_024-Standing';...   %20 [300,1280]~[5,21.33]
    '../../Data2\WAVE_025-Standing';...   %21 [300,1420]~[5,23.67]
    '../../Data2\WAVE_026-Standing';     %22 [280,1520]~[4.67,25.33]
    '../../Data2\WAVE_027-Standing';       %23 [290,1350]~[4.833,22.5]
    '../../Data2\WAVE_028-Standing';     %24 [300,1030]~[5,17.167]
    '../../Data2\WAVE_029-Standing';     %25 [270,1480;3580,3740]~[4.5,24.67;59.67,62.33]
    '../../Data2\WAVE_030-Standing';     %26 [200,1420]~[3.33,23.67]
    '../../Data2\WAVE_031-Standing';     %27 [30,1220]~[0.5,20.33]
    '../../Data2\WAVE_033-Standing';     %28 [0,1420]~[0,23.67]
    '../../Data2\WAVE_034-Standing';     %29 [290,1440;3530,3712]~[4.833,24;58.83,61.87]
    };
    
fileIndex = 29;
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
elseif fileIndex == 21 %sub25
    ECG=-ECG;
elseif fileIndex == 23 %sub27
    ECG = -ECG;
end
BCG = data(:,4);
ICGz = data(:,5);
PPGfeet = data(:,6);
if fileIndex == 20 %sub24
    PPGfeet = -PPGfeet;
elseif fileIndex == 21 %sub25
    PPGfeet = -PPGfeet;  
% elseif fileIndex == 23 %sub27
%     PPGfeet = -PPGfeet;
elseif fileIndex == 24 %sub28
    PPGfeet = -PPGfeet;
elseif fileIndex == 25 %sub29
    PPGfeet = -PPGfeet;
elseif fileIndex == 26 %sub30
    PPGfeet = -PPGfeet;
elseif fileIndex == 28 %sub33
    PPGfeet = -PPGfeet;
end
PPGtoe = data(:,7);
PPGear = data(:,8);
PPGfingerClip = data(:,9);
PPGfingerWrap = data(:,10);
BPNexfin = data(:,11)*100;
ICGdzdt = data(:,12);
if fileIndex == 21
    ICGdzdt = -ICGdzdt;
end
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
PPGfeetFiltered=filtfilt(u,v,PPGfeet);
PPGfingerClipFiltered=filtfilt(u,v,PPGfingerClip);
PPGfingerWrapFiltered=filtfilt(u,v,PPGfingerWrap);
BCGFiltered=filtfilt(u,v,BCG);
% [u,v]=butter(5,0.5/(fs/2),'high');
% ICGintegralFiltered=filtfilt(u,v,ICG_integral);
% [u,v]=butter(5,20/(fs/2),'low');
% ICGintegralFiltered=filtfilt(u,v,ICGintegralFiltered);
[u,v]=butter(1,[0.5,20]/(fs/2));
ICGdzdtFiltered=filtfilt(u,v,ICGdzdt);
rate = 10;
dictName2Idx=containers.Map({'BL','SB','MA','CP','PE'},[0,1,2,3,4]);
dictIdx2Name=containers.Map([0,1,2,3,4],{'BL','SB','MA','CP','PE'});
interventionNames={'BL','SB','MA','CP','PE'};

figure(1)

% set(get(handle(gcf),'JavaFrame'),'Maximized',1);
% set(gcf, 'Position', get(0,'Screensize'));
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
maximize(gcf)
set(gcf,'Color','w')
ax1=subplot(8,1,1);
plot(time(1:rate:end),BPNexfin(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),BPNexfinFiltered(1:rate:end))
ylabel('BP Nexfin');ylim([0,200])
ax2=subplot(8,1,2);
plot(time(1:rate:end),PPGtoe(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGtoeFiltered(1:rate:end))
ylabel('PPG toe')
ax3=subplot(8,1,3);
plot(time(1:rate:end),ECG(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),ECGFiltered(1:rate:end))
ylabel('ECG')
ax4=subplot(8,1,4);
plot(time(1:rate:end),ICGdzdt(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),ICGdzdtFiltered(1:rate:end))
ylabel('ICGdzdt')
ax5=subplot(8,1,5);
plot(time(1:rate:end),PPGear(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGearFiltered(1:rate:end))
ylabel('PPGear')
ax6=subplot(8,1,6);
plot(time(1:rate:end),PPGfingerClip(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGfingerClipFiltered(1:rate:end))
ylabel('PPGfinger')
ax7=subplot(8,1,7);
plot(time(1:rate:end),BCG(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),BCGFiltered(1:rate:end));
ylabel('BCG')
ax8=subplot(8,1,8);
plot(time(1:rate:end),PPGfeet(1:rate:end));hold on;grid on;grid minor;
plot(time(1:rate:end),PPGfeetFiltered(1:rate:end));
ylabel('PPGfoot')
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8],'x')

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
minPeakHeightBPMin=-120;minPeakHeightBPMax=70;minPeakProminenceBPMax=10;minPeakProminenceBPMin=5;
maxP2VDurBP=[-0.2,0];maxDurECGMax2BPMin=[-0.2,0];minPeakDistBPMax=0.4;minPeakDistBPMin=0.4;
minPeakProminenceECG=0.2;
maxP2VDurBCG=[-0.25,0];maxP2VDurBCG2=[0,0.3];maxDurECGMax2BCGMax=[0.06,0.3];minPeakProminenceBCGMax=0.08;minPeakProminenceBCGMin=0.0003;
minPeakDistBCG=0.1;

maxP2VDurPPGfinger=[-0.2,0];maxDurECGMax2PPGfingerMax=[0,0.6];minPeakProminencePPGfingerMax=0.4;minPeakProminencePPGfingerMin=0.4;
minPeakDistPPGfingerMax=0.4;minPeakDistPPGfingerMin=0.4;

maxP2VDurPPGear=[-0.3,0];maxDurECGMax2PPGearMax=[0,0.4];minPeakProminencePPGearMax=0.1;minPeakProminencePPGearMin=0.1;

maxP2VDurPPGtoe=[-0.3,0];maxDurECGMax2PPGtoeMax=[0,0.4];minPeakProminencePPGtoeMax=0.2;minPeakProminencePPGtoeMin=0.2;
minPeakDistPPGtoeMax=0.4;minPeakDistPPGtoeMin=0.4;

maxP2VDurPPGfeet=[-0.4,0];maxDurECGMax2PPGfeetMax=[0,0.4];minPeakProminencePPGfeetMax=0.2;minPeakProminencePPGfeetMin=0.2;
minPeakDistPPGfeetMax=0.4;minPeakDistPPGfeetMin=0.4;

minPeakDist=0.4;
minPeakProminenceICG=0.2;

PAT.('PPGfingerECG').data=[];PAT.('PPGearECG').data=[];PAT.('PPGtoeECG').data=[];PAT.('PPGfeetECG').data=[];
PTT.('PPGfingerICG').data=[];PTT.('PPGearICG').data=[];PTT.('PPGtoeICG').data=[];PTT.('PPGfeetICG').data=[];
PTT.('PPGfingerBCG').data=[];PTT.('PPGearBCG').data=[];PTT.('PPGtoeBCG').data=[];PTT.('PPGfeetBCG').data=[];
PAT.('PPGfingerECG').BPInfo=[];PAT.('PPGearECG').BPInfo=[];PAT.('PPGtoeECG').BPInfo=[];PAT.('PPGfeetECG').BPInfo=[];
PTT.('PPGfingerICG').BPInfo=[];PTT.('PPGearICG').BPInfo=[];PTT.('PPGtoeICG').BPInfo=[];PTT.('PPGfeetICG').BPInfo=[];
PTT.('PPGfingerBCG').BPInfo=[];PTT.('PPGearBCG').BPInfo=[];PTT.('PPGtoeBCG').BPInfo=[];PTT.('PPGfeetBCG').BPInfo=[];
IJInfo.data=[];IJInfo.BPInfo=[];

if fileIndex == 4 %sub8
    minPeakProminencePPGtoeMax=0.1;maxDurECGMax2PPGtoeMax=[0,0.6];minPeakDistBPMax=0.3;minPeakDistPPGtoeMax=0.4;maxDurECGMax2BCGMax=[0.03,0.45];
    minPeakHeightBPMin=-150;minPeakProminenceBPMax=5;minPeakProminenceBPMin=1;maxDurECGMax2BPMin=[-0.3,0];minPeakDistPPGtoeMin=0.1;minPeakProminenceBCGMax=0.1;
elseif fileIndex ==5 %sub9
    minPeakProminenceBCGMax=0.05;maxDurECGMax2BPMin=[-0.2,0];maxP2VDurPPGfinger=[-0.3,0];minPeakProminenceECG=0.1;
    minPeakProminenceBPMax=5;minPeakProminenceBPMin=5;
elseif fileIndex == 6 %sub10
    maxP2VDurBP=[-0.35,0];maxDurECGMax2BPMin=[-0.2,0];minPeakProminenceBCGMax=0.05;minPeakDistBCG=0.1;
    maxP2VDurPPGfinger=[-0.45,0];maxP2VDurPPGear=[-0.45,0];maxP2VDurPPGtoe=[-0.45,0];
    minPeakProminenceBCGMin=0.003;
elseif fileIndex == 8 %sub12
    minPeakProminencePPGfingerMax=0.08;minPeakProminencePPGfingerMin=0.08;maxP2VDurPPGfinger=[-0.3,0];minPeakDistPPGfingerMin=0.2;
    minPeakProminenceBCGMax=0.04;maxDurECGMax2BCGMax=[0.06,0.5];minPeakDistBCG=0.1;
    minPeakHeightBPMin=-150;minPeakHeightBPMax=50;maxP2VDurBP=[-0.3,0];
elseif fileIndex == 9 %sub13 ok
    maxP2VDurBCG=[-0.3,0];minPeakDistBCG=0.1;minPeakHeightBPMin=-150;maxP2VDurPPGear=[-0.2,0];
    minPeakProminencePPGfingerMax=0.4;minPeakProminencePPGfingerMin=0.4;
elseif fileIndex ==10 %sub14 ok
    maxDurECGMax2PPGtoeMax=[0,0.5];minPeakDistBCG=0.1;maxDurECGMax2BCGMax=[0.03,0.3];minPeakProminencePPGearMax=0.004;maxP2VDurPPGear=[-0.25,0];maxDurECGMax2BPMin=[-0.2,0];
    maxP2VDurPPGfinger=[-0.3,0];minPeakProminencePPGfingerMax=0.2;minPeakProminencePPGfingerMin=0.2;maxP2VDurPPGtoe=[-0.25,0];minPeakProminenceBPMin=3;
    maxP2VDurBCG=[-0.25,-0.08];
elseif fileIndex ==15 %sub19 ok
    minPeakDist = 0.3;minPeakDistBPMax=0.4;minPeakDistBPMin=0.1;maxP2VDurBP=[-0.25,0];minPeakProminenceBPMin=2;minPeakHeightBPMax=50;
    minPeakProminenceECG=0.1;maxDurECGMax2BPMin=[-0.2,0];maxDurECGMax2PPGfingerMax=[0,0.6];maxP2VDurPPGfinger=[-0.32,0];maxP2VDurPPGtoe=[-0.35,0];maxP2VDurPPGear=[-0.35,0];
    minPeakDistBCG=0.1;minPeakProminenceBCGMax=0.02;maxDurECGMax2BCGMax=[0.03,0.4];
elseif fileIndex == 16 %sub20 ok
    minPeakProminenceECG=0.05;maxDurECGMax2BPMin=[-0.2,0];minPeakDist=0.3;maxP2VDurPPGfinger=[-0.35,0];maxP2VDurBP=[-0.4,0];
    minPeakDistBCG=0.1;maxDurECGMax2BCGMax=[0.03,0.4];minPeakProminencePPGtoeMax=0.08;minPeakProminenceBCGMin=0.01;
    minPeakHeightBPMin=-150;
elseif fileIndex == 17 %sub21
    minPeakDistBCG=0.1;minPeakProminenceECG=0.1;maxDurECGMax2BCGMax=[0.03,0.4];
    minPeakProminencePPGfingerMax=0.1;minPeakProminencePPGfingerMin=0.1;minPeakDistPPGfingerMax=0.2;minPeakDistPPGfingerMin=0.2;
    minPeakProminencePPGtoeMax=0.05;maxP2VDurPPGtoe=[-0.2,0];
    maxP2VDurBCG=[-0.25,-0.07];
elseif fileIndex ==18 %sub22
    minPeakDistBCG=0.1;minPeakProminenceECG=0.07;maxDurECGMax2BPMin=[-0.35,0];minPeakProminenceBPMin=5;minPeakProminenceBPMax=10;minPeakDistBPMin=0.1;
    minPeakHeightBPMax=30;maxP2VDurBP=[-0.3,0];
    minPeakProminencePPGfingerMax=0.15;minPeakProminencePPGfingerMin=0.15;maxP2VDurPPGfinger=[-0.3,0];maxDurECGMax2PPGfingerMax=[0,0.7];minPeakDistPPGfingerMin=0.3;
    minPeakProminencePPGearMax=0.08;
    maxDurECGMax2PPGtoeMax=[0.1,0.45];minPeakDistPPGtoeMax=0.2;maxP2VDurPPGtoe=[-0.3,0];minPeakDistPPGtoeMin=0.1;minPeakProminencePPGtoeMin=0.07;
    minPeakDistPPGfeetMin=0.1;minPeakProminencePPGfeetMin=0.1;maxP2VDurPPGfeet=[-0.2,0];
elseif fileIndex == 20 %sub24
    minPeakProminenceECG=0.05;minPeakProminenceBCGMax=0.04;minPeakProminencePPGfingerMax=0.3;minPeakProminencePPGfingerMin=0.05;minPeakProminenceBPMax=5;
    minPeakDist=0.25;
    maxP2VDurPPGfinger=[-0.4,0];maxDurECGMax2PPGearMax=[0,0.5];maxP2VDurBP=[-0.3,0];maxDurECGMax2PPGfeetMax=[0,0.5];
    minPeakHeightBPMin=-160;
elseif fileIndex == 21 %sub25
    minPeakProminenceECG=0.1;minPeakDist=0.1;
    minPeakProminencePPGfingerMax=0.05;minPeakProminencePPGfingerMin=0.3;maxP2VDurPPGfinger=[-0.3,0];
elseif fileIndex == 22 %sub26
    maxP2VDurBP=[-0.3,0];minPeakProminencePPGfingerMax=0.5;minPeakProminencePPGfingerMin=0.5;maxP2VDurPPGfinger=[-0.3,0];
end
ToFstr={'False','True'};eventList={};
% eventIdx=2;
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
        PPGfeetsig = PPGfeetFiltered(dataRange);
        ax11=subplot(811);plot(timesig,ECGsig);ylabel('ECG');title(['Intervention=' eventData.(name).eventName]);hold on;grid on;grid minor;
        [ECGMax,ECGMaxLoc]=findpeaks(ECGsig,fs,'MinPeakHeight',0,'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminenceECG);
        fECGMax=plot(startTime+ECGMaxLoc,ECGMax,'go');
        ax12=subplot(812);plot(timesig,ICGdzdtsig);ylabel('ICG dzdt');hold on;grid on;grid minor;
        [ICGdzdtMax,ICGdzdtMaxLoc]=findpeaks(ICGdzdtsig,fs,'MinPeakHeight',0,'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminenceICG);
        fICGMax=plot(startTime+ICGdzdtMaxLoc,ICGdzdtMax,'go');
        ax13=subplot(813);plot(timesig,BPsig);ylabel('BP');hold on;grid on;grid minor;
        [BPMax,BPMaxLoc]=findpeaks(BPsig,fs,'MinPeakHeight',minPeakHeightBPMax,'MinPeakDistance',minPeakDistBPMax,'MinPeakProminence',minPeakProminenceBPMax);
        [BPMin,BPMinLoc]=findpeaks(-BPsig,fs,'MinPeakHeight',minPeakHeightBPMin,'MinPeakDistance',minPeakDistBPMin,'MinPeakProminence',minPeakProminenceBPMin);
        fBPMax=plot(startTime+BPMaxLoc,BPMax,'go');
        fBPMin=plot(startTime+BPMinLoc,-BPMin,'ro');
        [temptime,peakstdval]=peakstd(BPsig,BPMaxLoc,fs,windowSize,startTime);
%         ax14=subplot(714);plot(temptime,peakstdval,'o-');ylabel('peakstd');hold on
%         BCGsig=expMA(BCGsig,fix(ECGMaxLoc*fs));
%         figure(1);subplot(817);plot(timesig,BCGsig,'c')
%         figure(figIdx)
%         ax14=subplot(814);plot(timesig,BCGsig);ylabel('BCG');hold on;grid on;grid minor;
%         [BCGMax,BCGMaxLoc]=findpeaks(BCGsig,fs,'MinPeakHeight',mean(BCGsig)-0.1,'MinPeakDistance',minPeakDistBCG,'MinPeakProminence',minPeakProminenceBCGMax);
% %         [BCGMin,BCGMinLoc]=findpeaks(-BCGsig,fs,'MinPeakHeight',mean(BCGsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',0.04);
%         if isempty(BCGMaxLoc)
%             BCGMaxLoc=NaN(size(BPMaxLoc));BCGMax=NaN(size(BPMaxLoc));
%         end
%         BCGMax2=BCGMax;BCGMaxLoc2=BCGMaxLoc;
%         fBCGMax=plot(startTime+BCGMaxLoc,BCGMax,'go');
%         fBCGMax2=plot(startTime+BCGMaxLoc2,BCGMax2,'gx');
%         fBCGMin=plot(startTime+BCGMinLoc,-BCGMin,'ro');
%         plot(timesig,BCGsig2)
        ax15=subplot(815);plot(timesig,PPGfingersig);ylabel('PPG finger');hold on;grid on;grid minor;
        [PPGfingerMax,PPGfingerMaxLoc]=findpeaks(PPGfingersig,fs,'MinPeakHeight',mean(PPGfingersig)-0.5,'MinPeakDistance',minPeakDistPPGfingerMax,'MinPeakProminence',minPeakProminencePPGfingerMax);
        [PPGfingerMin,PPGfingerMinLoc]=findpeaks(-PPGfingersig,fs,'MinPeakHeight',-mean(PPGfingersig)-0.5,'MinPeakDistance',minPeakDistPPGfingerMin,'MinPeakProminence',minPeakProminencePPGfingerMin);
        if isempty(PPGfingerMaxLoc) || isempty(PPGfingerMinLoc)
            PPGfingerMaxLoc=NaN(size(BPMaxLoc));PPGfingerMax=NaN(size(BPMaxLoc));PPGfingerMinLoc=NaN(size(BPMaxLoc));PPGfingerMin=NaN(size(BPMaxLoc));
        end
        fPPGfingerMax=plot(startTime+PPGfingerMaxLoc,PPGfingerMax,'go');
        fPPGfingerMin=plot(startTime+PPGfingerMinLoc,-PPGfingerMin,'ro');
        ax16=subplot(816);plot(timesig,PPGearsig);ylabel('PPG ear');hold on;grid on;grid minor;
        [PPGearMax,PPGearMaxLoc]=findpeaks(PPGearsig,fs,'MinPeakHeight',mean(PPGearsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGearMax);
        [PPGearMin,PPGearMinLoc]=findpeaks(-PPGearsig,fs,'MinPeakHeight',-mean(PPGearsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',minPeakProminencePPGearMin);
        if isempty(PPGearMaxLoc) || isempty(PPGearMinLoc)
            PPGearMaxLoc=NaN(size(BPMaxLoc));PPGearMax=NaN(size(BPMaxLoc));PPGearMinLoc=NaN(size(BPMaxLoc));PPGearMin=NaN(size(BPMaxLoc));
        end
        fPPGearMax=plot(startTime+PPGearMaxLoc,PPGearMax,'go');
        fPPGearMin=plot(startTime+PPGearMinLoc,-PPGearMin,'ro');
        ax17=subplot(817);plot(timesig,PPGtoesig);ylabel('PPGtoe');hold on;grid on;grid minor;
        [PPGtoeMax,PPGtoeMaxLoc]=findpeaks(PPGtoesig,fs,'MinPeakHeight',mean(PPGtoesig),'MinPeakDistance',minPeakDistPPGtoeMax,'MinPeakProminence',minPeakProminencePPGtoeMax);
        [PPGtoeMin,PPGtoeMinLoc]=findpeaks(-PPGtoesig,fs,'MinPeakHeight',-mean(PPGtoesig),'MinPeakDistance',minPeakDistPPGtoeMin,'MinPeakProminence',minPeakProminencePPGtoeMin);
        if isempty(PPGtoeMaxLoc) || isempty(PPGtoeMinLoc)
            PPGtoeMaxLoc=NaN(size(BPMaxLoc));PPGtoeMax=NaN(size(BPMaxLoc));PPGtoeMinLoc=NaN(size(BPMaxLoc));PPGtoeMin=NaN(size(BPMaxLoc));
        end
        fPPGtoeMax=plot(startTime+PPGtoeMaxLoc,PPGtoeMax,'go');
        fPPGtoeMin=plot(startTime+PPGtoeMinLoc,-PPGtoeMin,'ro');
        ax18=subplot(818);plot(timesig,PPGfeetsig);ylabel('PPGfeet');hold on;grid on;grid minor;
        [PPGfeetMax,PPGfeetMaxLoc]=findpeaks(PPGfeetsig,fs,'MinPeakHeight',mean(PPGfeetsig),'MinPeakDistance',minPeakDistPPGfeetMax,'MinPeakProminence',minPeakProminencePPGfeetMax);
        [PPGfeetMin,PPGfeetMinLoc]=findpeaks(-PPGfeetsig,fs,'MinPeakHeight',-mean(PPGfeetsig),'MinPeakDistance',minPeakDistPPGfeetMin,'MinPeakProminence',minPeakProminencePPGfeetMin);
        if isempty(PPGfeetMaxLoc) || isempty(PPGfeetMinLoc)
            PPGfeetMaxLoc=NaN(size(BPMaxLoc));PPGfeetMax=NaN(size(BPMaxLoc));PPGfeetMinLoc=NaN(size(BPMaxLoc));PPGfeetMin=NaN(size(BPMaxLoc));
        end
        fPPGfeetMax=plot(startTime+PPGfeetMaxLoc,PPGfeetMax,'go');
        fPPGfeetMin=plot(startTime+PPGfeetMinLoc,-PPGfeetMin,'ro');
%         linkaxes([ax11,ax12,ax13,ax14,ax15,ax16,ax17,ax18],'x')
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
        
        %% PPGfeet Max/Min
        [PPGfeetMaxExcludeMask,PPGfeetMinIncludeMask,~]=alignSignal(PPGfeetMaxLoc,PPGfeetMinLoc,maxP2VDurPPGfeet,'left');
        PPGfeetMaxLoc(PPGfeetMaxExcludeMask==1)=[];
        PPGfeetMax(PPGfeetMaxExcludeMask==1)=[];
        PPGfeetMinLoc=PPGfeetMinLoc(PPGfeetMinIncludeMask==1);
        PPGfeetMin=PPGfeetMin(PPGfeetMinIncludeMask==1);
        if isempty(PPGfeetMaxLoc)
            PPGfeetMaxLoc=NaN(size(BPMaxLoc));PPGfeetMax=NaN(size(BPMaxLoc));PPGfeetMinLoc=NaN(size(BPMaxLoc));PPGfeetMin=NaN(size(BPMaxLoc));
        end
        fPPGfeetMax.XData = startTime+PPGfeetMaxLoc; fPPGfeetMax.YData = PPGfeetMax;
        fPPGfeetMin.XData = startTime+PPGfeetMinLoc; fPPGfeetMin.YData = -PPGfeetMin;
        
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
        minGap = 30; maxPercent = 15;
        [BPMinLocRefined,BPMinRefined,BPMinLocChanged,BPMinChanged]=refineValley(BPsig,BPMaxLoc,BPMax,BPMinLoc,-BPMin,fs,minGap,maxPercent);
        BPMinLoc = BPMinLocRefined; BPMin = -BPMinRefined;
        fBPMax.XData = startTime+BPMaxLoc; fBPMax.YData = BPMax;
        fBPMin.XData = startTime+BPMinLoc; fBPMin.YData = -BPMin;
        subplot(813);htxt=text(startTime+BPMaxLoc,1.05*BPMax,cellstr(num2str((1:length(BPMax))')),'fontsize',7);set(htxt,'Clipping','on')
        BPLength = length(BPMaxLoc);
        
        %% BPMin->ECGMax
        [ECGNaNMask,ECGMaxIncludeMask,ECGMap]=alignSignal(BPMinLoc,ECGMaxLoc,maxDurECGMax2BPMin,'left');
        ECGMax=expandSignal(ECGMax,ECGMaxIncludeMask,ECGMap,BPLength);
        ECGMaxLoc=expandSignal(ECGMaxLoc,ECGMaxIncludeMask,ECGMap,BPLength);
        fprintf(['Length difference of ECGMax and BPMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(BPMaxLoc(~isnan(BPMaxLoc)))) '\n'])
        fECGMax.XData = startTime+ECGMaxLoc; fECGMax.YData = ECGMax;
        subplot(811);htxt=text(startTime+ECGMaxLoc,1.05*ECGMax,cellstr(num2str((1:length(ECGMax))')),'fontsize',7);set(htxt,'Clipping','on')
        
        BCGsig=expMA(BCGsig,fix(ECGMaxLoc*fs));
        figure(1);subplot(817);plot(timesig,BCGsig,'c')
        figure(figIdx)
        ax14=subplot(814);plot(timesig,BCGsig);ylabel('BCG');hold on;grid on;grid minor;
        [BCGMax,BCGMaxLoc]=findpeaks(BCGsig,fs,'MinPeakHeight',mean(BCGsig)-0.1,'MinPeakDistance',minPeakDistBCG,'MinPeakProminence',minPeakProminenceBCGMax);
%         [BCGMin,BCGMinLoc]=findpeaks(-BCGsig,fs,'MinPeakHeight',mean(BCGsig),'MinPeakDistance',minPeakDist,'MinPeakProminence',0.04);
        if isempty(BCGMaxLoc)
            BCGMaxLoc=NaN(size(BPMaxLoc));BCGMax=NaN(size(BPMaxLoc));
        end
        BCGMax2=BCGMax;BCGMaxLoc2=BCGMaxLoc;
        fBCGMax=plot(startTime+BCGMaxLoc,BCGMax,'go');
        fBCGMax2=plot(startTime+BCGMaxLoc2,BCGMax2,'gx');
        linkaxes([ax11,ax12,ax13,ax14,ax15,ax16,ax17,ax18],'x')
        
        %% BCG IJ
%         [~,BCGMaxIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMaxLoc,maxDurECGMax2BCGMax,'right');
%         [~,BCGMaxIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMaxLoc,[ones(length(ECGMaxLoc),1)*0.1,BPMaxLoc-ECGMaxLoc],'right');
        [~,BCGMaxIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMaxLoc,[BPMinLoc-ECGMaxLoc-0.07,BPMaxLoc-ECGMaxLoc],'right');
        BCGMax=expandSignal(BCGMax,BCGMaxIncludeMask,BCGMap,BPLength);
        BCGMaxLoc=expandSignal(BCGMaxLoc,BCGMaxIncludeMask,BCGMap,BPLength);
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
        fBCGMax.XData = startTime+BCGMaxLoc; fBCGMax.YData = BCGMax;
        
        [BCGMaxExcludeMask,BCGMinIncludeMask,~]=alignSignal(BCGMaxLoc,BCGMinLoc,maxP2VDurBCG,'left');
        BCGMaxLoc(BCGMaxExcludeMask==1)=NaN;
        BCGMax(BCGMaxExcludeMask==1)=NaN;
        BCGMinLoc(BCGMinIncludeMask~=1)=NaN;
        BCGMin(BCGMinIncludeMask~=1)=NaN;
        fBCGMax.XData = startTime+BCGMaxLoc; fBCGMax.YData = BCGMax;
        
        [~,BCGMinIncludeMask,BCGMap]=alignSignal(ECGMaxLoc,BCGMinLoc,[zeros(length(ECGMaxLoc),1),BPMinLoc-ECGMaxLoc],'right');
        BCGMax=expandSignal(BCGMax,BCGMinIncludeMask,BCGMap,BPLength);
        BCGMaxLoc=expandSignal(BCGMaxLoc,BCGMinIncludeMask,BCGMap,BPLength);
        BCGMin=expandSignal(BCGMin,BCGMinIncludeMask,BCGMap,BPLength);
        BCGMinLoc=expandSignal(BCGMinLoc,BCGMinIncludeMask,BCGMap,BPLength);

        minGap = 30; maxPercent = 10;
        [BCGMinLocRefined,BCGMinRefined,BCGMinLocChanged,BCGMinChanged]=refineValley(BCGsig,BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,fs,minGap,maxPercent);
        BCGMinLoc = BCGMinLocRefined; BCGMin = BCGMinRefined;
        subplot(814);plot(startTime+BCGMinLoc,BCGMin,'ro')
        fBCGMax.XData = startTime+BCGMaxLoc; fBCGMax.YData = BCGMax;
%         plot(startTime+BCGMinLocChanged,BCGMinChanged,'rs')
        subplot(814);htxt=text(startTime+BCGMaxLoc,1.05*BCGMax,cellstr(num2str((1:length(BCGMax))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% BCG JK
%         [~,BCGMaxIncludeMask2,BCGMap2]=alignSignal(ECGMaxLoc,BCGMaxLoc2,maxDurECGMax2BCGMax,'right');
%         BCGMax2=expandSignal(BCGMax2,BCGMaxIncludeMask2,BCGMap2,BPLength);
%         BCGMaxLoc2=expandSignal(BCGMaxLoc2,BCGMaxIncludeMask2,BCGMap2,BPLength);
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
%         BCGMax2=expandSignal(BCGMax2,BCGMaxIncludeMask2,BCGMap2,BPLength);
%         BCGMaxLoc2=expandSignal(BCGMaxLoc2,BCGMaxIncludeMask2,BCGMap2,BPLength);
%         BCGMin2=expandSignal(BCGMin2,BCGMaxIncludeMask2,BCGMap2,BPLength);
%         BCGMinLoc2=expandSignal(BCGMinLoc2,BCGMaxIncludeMask2,BCGMap2,BPLength);
        subplot(814);plot(startTime+BCGMinLoc2,BCGMin2,'rx')
        fBCGMax2.XData = startTime+BCGMaxLoc2; fBCGMax2.YData = BCGMax2;
        subplot(814);htxt=text(startTime+BCGMinLoc2,0.95*BCGMin2,cellstr(num2str((1:length(BCGMin2))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGfingerMax
        [~,PPGfingerMaxIncludeMask,PPGfingerMap]=alignSignal(ECGMaxLoc,PPGfingerMaxLoc,maxDurECGMax2PPGfingerMax,'right');
        PPGfingerMax=expandSignal(PPGfingerMax,PPGfingerMaxIncludeMask,PPGfingerMap,BPLength);
        PPGfingerMaxLoc=expandSignal(PPGfingerMaxLoc,PPGfingerMaxIncludeMask,PPGfingerMap,BPLength);
        PPGfingerMin=expandSignal(PPGfingerMin,PPGfingerMaxIncludeMask,PPGfingerMap,BPLength);
        PPGfingerMinLoc=expandSignal(PPGfingerMinLoc,PPGfingerMaxIncludeMask,PPGfingerMap,BPLength);
        PPGfingerfoot=findFoot(PPGfingersig,PPGfingerMin,PPGfingerMaxLoc,PPGfingerMinLoc,ECGMaxLoc,startTime,fs);
        PTTPositiveMask = PPGfingerfoot(:,1)-BCGMinLoc-startTime<=0;
        PPGfingerfoot(PTTPositiveMask,:)=NaN;
        
        fprintf(['Length difference of ECGMax and PPGfingerMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfingerMaxLoc(~isnan(PPGfingerMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGfingerMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfingerMinLoc(~isnan(PPGfingerMinLoc)))) '\n'])
        fPPGfingerMax.XData = startTime+PPGfingerMaxLoc; fPPGfingerMax.YData = PPGfingerMax;
        fPPGfingerMin.XData = startTime+PPGfingerMinLoc; fPPGfingerMin.YData = -PPGfingerMin;
        subplot(815);htxt=text(startTime+PPGfingerMaxLoc,1.05*PPGfingerMax,cellstr(num2str((1:length(PPGfingerMax))')),'fontsize',7);set(htxt,'Clipping','on')
        subplot(815);plot(PPGfingerfoot(:,1),PPGfingerfoot(:,2),'b^');
        subplot(815);htxt=text(PPGfingerfoot(:,1),0.95*PPGfingerfoot(:,2),cellstr(num2str((1:length(PPGfingerfoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGearMax
        [~,PPGearMaxIncludeMask,PPGearMap]=alignSignal(ECGMaxLoc,PPGearMaxLoc,maxDurECGMax2PPGearMax,'right');
        PPGearMax=expandSignal(PPGearMax,PPGearMaxIncludeMask,PPGearMap,BPLength);
        PPGearMaxLoc=expandSignal(PPGearMaxLoc,PPGearMaxIncludeMask,PPGearMap,BPLength);
        PPGearMin=expandSignal(PPGearMin,PPGearMaxIncludeMask,PPGearMap,BPLength);
        PPGearMinLoc=expandSignal(PPGearMinLoc,PPGearMaxIncludeMask,PPGearMap,BPLength);
        PPGearfoot=findFoot(PPGearsig,PPGearMin,PPGearMaxLoc,PPGearMinLoc,ECGMaxLoc,startTime,fs);
        PTTPositiveMask = PPGearfoot(:,1)-BCGMinLoc-startTime<=0;
        PPGearfoot(PTTPositiveMask,:)=NaN;
        fprintf(['Length difference of ECGMax and PPGearMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGearMaxLoc(~isnan(PPGearMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGearMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGearMinLoc(~isnan(PPGearMinLoc)))) '\n'])
        fPPGearMax.XData = startTime+PPGearMaxLoc; fPPGearMax.YData = PPGearMax;
        fPPGearMin.XData = startTime+PPGearMinLoc; fPPGearMin.YData = -PPGearMin;
        subplot(816);htxt=text(startTime+PPGearMaxLoc,1.05*PPGearMax,cellstr(num2str((1:length(PPGearMax))')),'fontsize',7);set(htxt,'Clipping','on')
        subplot(816);plot(PPGearfoot(:,1),PPGearfoot(:,2),'b^');
        subplot(816);htxt=text(PPGearfoot(:,1),0.95*PPGearfoot(:,2),cellstr(num2str((1:length(PPGearfoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGtoeMax
        [~,PPGtoeMaxIncludeMask,PPGtoeMap]=alignSignal(ECGMaxLoc,PPGtoeMaxLoc,maxDurECGMax2PPGtoeMax,'right');
        PPGtoeMax=expandSignal(PPGtoeMax,PPGtoeMaxIncludeMask,PPGtoeMap,BPLength);
        PPGtoeMaxLoc=expandSignal(PPGtoeMaxLoc,PPGtoeMaxIncludeMask,PPGtoeMap,BPLength);
        PPGtoeMin=expandSignal(PPGtoeMin,PPGtoeMaxIncludeMask,PPGtoeMap,BPLength);
        PPGtoeMinLoc=expandSignal(PPGtoeMinLoc,PPGtoeMaxIncludeMask,PPGtoeMap,BPLength);
        PPGtoefoot=findFoot(PPGtoesig,PPGtoeMin,PPGtoeMaxLoc,PPGtoeMinLoc,ECGMaxLoc,startTime,fs);
        PTTPositiveMask = PPGtoefoot(:,1)-BCGMinLoc-startTime<=0;
        PPGtoefoot(PTTPositiveMask,:)=NaN;
        fprintf(['Length difference of ECGMax and PPGtoeMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGtoeMaxLoc(~isnan(PPGtoeMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGtoeMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGtoeMinLoc(~isnan(PPGtoeMinLoc)))) '\n'])
        fPPGtoeMax.XData = startTime+PPGtoeMaxLoc; fPPGtoeMax.YData = PPGtoeMax;
        fPPGtoeMin.XData = startTime+PPGtoeMinLoc; fPPGtoeMin.YData = -PPGtoeMin;
        subplot(817);htxt=text(startTime+PPGtoeMaxLoc,1.05*PPGtoeMax,cellstr(num2str((1:length(PPGtoeMax))')),'fontsize',7);set(htxt,'Clipping','on')
        subplot(817);plot(PPGtoefoot(:,1),PPGtoefoot(:,2),'b^');
        subplot(817);htxt=text(PPGtoefoot(:,1),0.95*PPGtoefoot(:,2),cellstr(num2str((1:length(PPGtoefoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> PPGfeetMax
        [~,PPGfeetMaxIncludeMask,PPGfeetMap]=alignSignal(ECGMaxLoc,PPGfeetMaxLoc,maxDurECGMax2PPGfeetMax,'right');
        PPGfeetMax=expandSignal(PPGfeetMax,PPGfeetMaxIncludeMask,PPGfeetMap,BPLength);
        PPGfeetMaxLoc=expandSignal(PPGfeetMaxLoc,PPGfeetMaxIncludeMask,PPGfeetMap,BPLength);
        PPGfeetMin=expandSignal(PPGfeetMin,PPGfeetMaxIncludeMask,PPGfeetMap,BPLength);
        PPGfeetMinLoc=expandSignal(PPGfeetMinLoc,PPGfeetMaxIncludeMask,PPGfeetMap,BPLength);
        PPGfeetfoot=findFoot(PPGfeetsig,PPGfeetMin,PPGfeetMaxLoc,PPGfeetMinLoc,ECGMaxLoc,startTime,fs);
        PTTPositiveMask = PPGfeetfoot(:,1)-BCGMinLoc-startTime<=0;
        PPGfeetfoot(PTTPositiveMask,:)=NaN;
        fprintf(['Length difference of ECGMax and PPGfeetMax for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfeetMaxLoc(~isnan(PPGfeetMaxLoc)))) '\n'])
        fprintf(['Length difference of ECGMax and PPGfeetMin for Fig ' num2str(figIdx) ': ' num2str(length(ECGMaxLoc(~isnan(ECGMaxLoc)))-length(PPGfeetMinLoc(~isnan(PPGfeetMinLoc)))) '\n'])
        fPPGfeetMax.XData = startTime+PPGfeetMaxLoc; fPPGfeetMax.YData = PPGfeetMax;
        fPPGfeetMin.XData = startTime+PPGfeetMinLoc; fPPGfeetMin.YData = -PPGfeetMin;
        subplot(818);htxt=text(startTime+PPGfeetMaxLoc,1.05*PPGfeetMax,cellstr(num2str((1:length(PPGfeetMax))')),'fontsize',7);set(htxt,'Clipping','on')
        subplot(818);plot(PPGfeetfoot(:,1),PPGfeetfoot(:,2),'b^');
        subplot(818);htxt=text(PPGfeetfoot(:,1),0.95*PPGfeetfoot(:,2),cellstr(num2str((1:length(PPGfeetfoot))')),'fontsize',7);set(htxt,'Clipping','on')
        
        %% ECGMax -> ICGMax
        [~,ICGdzdtMaxIncludeMask,ICGdzdtMap]=alignSignal(ECGMaxLoc,ICGdzdtMaxLoc,[0,0.3],'right');
        ICGdzdtMax=expandSignal(ICGdzdtMax,ICGdzdtMaxIncludeMask,ICGdzdtMap,BPLength);
        ICGdzdtMaxLoc=expandSignal(ICGdzdtMaxLoc,ICGdzdtMaxIncludeMask,ICGdzdtMap,BPLength);
        fICGMax.XData = startTime+ICGdzdtMaxLoc; fICGMax.YData = ICGdzdtMax;
        subplot(812);htxt=text(startTime+ICGdzdtMaxLoc,1.05*ICGdzdtMax,cellstr(num2str((1:length(ICGdzdtMax))')),'fontsize',7);set(htxt,'Clipping','on')
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
        subplot(812);plot(ICGBpoint(:,1),ICGBpoint(:,2),'b^')
        subplot(812);htxt=text(ICGBpoint(:,1),1.05*ICGBpoint(:,2),cellstr(num2str((1:length(ICGBpoint))')),'fontsize',7);set(htxt,'Clipping','on')
        
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
        [temp,BPInfo]=calcTime(ECGMaxLoc(:,1),PPGfeetfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PAT.('PPGfeetECG').data = [PAT.('PPGfeetECG').data;temp];
        PAT.('PPGfeetECG').BPInfo = [PAT.('PPGfeetECG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfeetsig,'PPGfeet',PPGfeetMaxLoc,PPGfeetMax,PPGfeetMinLoc,PPGfeetMin,PPGfeetfoot,0,...
            ECGsig,'ECG',ECGMaxLoc,ECGMax,[],[],[],0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfeetECG')
        
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
        [temp,BPInfo]=calcTime(ICGBpoint(:,1),PPGfeetfoot(:,1),[],BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGfeetICG').data = [PTT.('PPGfeetICG').data;temp];
        PTT.('PPGfeetICG').BPInfo = [PTT.('PPGfeetICG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfeetsig,'PPGfeet',PPGfeetMaxLoc,PPGfeetMax,PPGfeetMinLoc,PPGfeetMin,PPGfeetfoot,0,...
            ICGdzdtsig,'ICG',ICGdzdtMaxLoc,ICGdzdtMax,[],[],ICGBpoint,0,[],[],ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfeetICG')
        
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
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),PPGfeetfoot(:,1),startTime,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        PTT.('PPGfeetBCG').data = [PTT.('PPGfeetBCG').data;temp];
        PTT.('PPGfeetBCG').BPInfo = [PTT.('PPGfeetBCG').BPInfo;eventIdx*ones(1,6);BPInfo];
        plotSep(startTime,temp,BPsig,BPMaxLoc,BPMax,BPMinLoc,BPMin,PPGfeetsig,'PPGfeet',PPGfeetMaxLoc,PPGfeetMax,PPGfeetMinLoc,PPGfeetMin,PPGfeetfoot,0,...
            BCGsig,'BCG',BCGMaxLoc,BCGMax,BCGMinLoc,BCGMin,[],0,BCGMinLoc2,BCGMin2,ECGsig,ECGMaxLoc,ECGMax,eventIdx,interventionName,fileName,'PPGfeetBCG')
                
        [temp,BPInfo]=calcTime(BCGMinLoc(:,1),BCGMaxLoc(:,1),0,BPMax,BPMin,BPMaxLoc,interventionName,interventionIdx);
        
        IJInfo.data = [IJInfo.data;temp];
        IJInfo.BPInfo = [IJInfo.BPInfo;eventIdx*ones(1,6);BPInfo];
        
        figIdx = figIdx+1;
    end
    
    eventIdx = eventIdx+1;
    
end


correlations = [];
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
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.03], [0.06 0.06], [0.04 0.04]);
% clear subplot;
figure(102);maximize(gcf);set(gcf,'Color','w');legendFontSize=7.5;grid on;grid minor
subplot(5,8,1);plot(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,2),'bo');xlabel('PATfinger/ECG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGfingerECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,2);plot(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,3),'bo');xlabel('PATfinger/ECG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGfingerECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGfingerECG').data(:,1)*1000,PAT.('PPGfingerECG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,3);plot(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,2),'bo');xlabel('PATear/ECG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGearECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,4);plot(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,3),'bo');xlabel('PATear/ECG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGearECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGearECG').data(:,1)*1000,PAT.('PPGearECG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,5);plot(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,2),'bo');xlabel('PATtoe/ECG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGtoeECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,6);plot(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,3),'bo');xlabel('PATtoe/ECG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGtoeECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGtoeECG').data(:,1)*1000,PAT.('PPGtoeECG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,7);plot(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,2),'bo');xlabel('PATfeet/ECG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PAT.('PPGfeetECG').correlation(1))])
grid on;grid minor
htxt=text(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,8);plot(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,3),'bo');xlabel('PATfeet/ECG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PAT.('PPGfeetECG').correlation(2))])
grid on;grid minor
htxt=text(PAT.('PPGfeetECG').data(:,1)*1000,PAT.('PPGfeetECG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,8,9);plot(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,2),'bo');xlabel('PTTfinger/ICG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfingerICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,10);plot(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,3),'bo');xlabel('PTTfinger/ICG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfingerICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfingerICG').data(:,1)*1000,PTT.('PPGfingerICG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,11);plot(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,2),'bo');xlabel('PTTear/ICG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGearICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,12);plot(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,3),'bo');xlabel('PTTear/ICG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGearICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGearICG').data(:,1)*1000,PTT.('PPGearICG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,13);plot(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,2),'bo');xlabel('PTTtoe/ICG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGtoeICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,14);plot(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,3),'bo');xlabel('PTTtoe/ICG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGtoeICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGtoeICG').data(:,1)*1000,PTT.('PPGtoeICG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,15);plot(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,2),'bo');xlabel('PTTfeet/ICG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfeetICG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,16);plot(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,3),'bo');xlabel('PTTfeet/ICG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfeetICG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfeetICG').data(:,1)*1000,PTT.('PPGfeetICG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,8,17);plot(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,2),'bo');xlabel('PTTfinger/BCG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfingerBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,18);plot(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,3),'bo');xlabel('PTTfinger/BCG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfingerBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfingerBCG').data(:,1)*1000,PTT.('PPGfingerBCG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,19);plot(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,2),'bo');xlabel('PTTear/BCG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGearBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,20);plot(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,3),'bo');xlabel('PTTear/BCG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGearBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGearBCG').data(:,1)*1000,PTT.('PPGearBCG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,21);plot(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,2),'bo');xlabel('PTTtoe/BCG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGtoeBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,22);plot(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,3),'bo');xlabel('PTTtoe/BCG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGtoeBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGtoeBCG').data(:,1)*1000,PTT.('PPGtoeBCG').data(:,3)*1.01,eventList,'fontsize',7);
subplot(5,8,23);plot(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,2),'bo');xlabel('PTTfeet/BCG [ms]');ylabel('SP [mmHg]');title(['r=' num2str(PTT.('PPGfeetBCG').correlation(1))])
grid on;grid minor
htxt=text(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,24);plot(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,3),'bo');xlabel('PTTfeet/BCG [ms]');ylabel('DP [mmHg]');title(['r=' num2str(PTT.('PPGfeetBCG').correlation(2))])
grid on;grid minor
htxt=text(PTT.('PPGfeetBCG').data(:,1)*1000,PTT.('PPGfeetBCG').data(:,3)*1.01,eventList,'fontsize',7);

subplot(5,8,25);plot(IJInfo.data(:,1)*1000,IJInfo.data(:,2),'bo');xlabel('I-J Interval [ms]');ylabel('SP [mmHg]');title(['r=' num2str(IJInfo.correlation(1))])
grid on;grid minor
htxt=text(IJInfo.data(:,1)*1000,IJInfo.data(:,2)*1.01,eventList,'fontsize',7);
subplot(5,8,26);plot(IJInfo.data(:,1)*1000,IJInfo.data(:,3),'bo');xlabel('I-J Interval [ms]');ylabel('DP [mmHg]');title(['r=' num2str(IJInfo.correlation(2))])
grid on;grid minor
htxt=text(IJInfo.data(:,1)*1000,IJInfo.data(:,3)*1.01,eventList,'fontsize',7);
% subplot(5,6,[21,22,23,24]);plot()

subplot(5,8,33);plot(1:length(PAT.('PPGfingerECG').data(:,2)),PAT.('PPGfingerECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGfingerICG').data(:,2)),PTT.('PPGfingerICG').data(:,2),'o-');
plot(1:length(PTT.('PPGfingerBCG').data(:,2)),PTT.('PPGfingerBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfingerECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,34);plot(1:length(PAT.('PPGfingerECG').data(:,3)),PAT.('PPGfingerECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGfingerICG').data(:,3)),PTT.('PPGfingerICG').data(:,3),'o-');
plot(1:length(PTT.('PPGfingerBCG').data(:,3)),PTT.('PPGfingerBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfingerECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,35);plot(1:length(PAT.('PPGearECG').data(:,2)),PAT.('PPGearECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGearICG').data(:,2)),PTT.('PPGearICG').data(:,2),'o-');
plot(1:length(PTT.('PPGearBCG').data(:,2)),PTT.('PPGearBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGearECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,36);plot(1:length(PAT.('PPGearECG').data(:,3)),PAT.('PPGearECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGearICG').data(:,3)),PTT.('PPGearICG').data(:,3),'o-');
plot(1:length(PTT.('PPGearBCG').data(:,3)),PTT.('PPGearBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGearECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,37);plot(1:length(PAT.('PPGtoeECG').data(:,2)),PAT.('PPGtoeECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGtoeICG').data(:,2)),PTT.('PPGtoeICG').data(:,2),'o-');
plot(1:length(PTT.('PPGtoeBCG').data(:,2)),PTT.('PPGtoeBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGtoeECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,38);plot(1:length(PAT.('PPGtoeECG').data(:,3)),PAT.('PPGtoeECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGtoeICG').data(:,3)),PTT.('PPGtoeICG').data(:,3),'o-');
plot(1:length(PTT.('PPGtoeBCG').data(:,3)),PTT.('PPGtoeBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGtoeECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,39);plot(1:length(PAT.('PPGfeetECG').data(:,2)),PAT.('PPGfeetECG').data(:,2),'o-');hold on;ylabel('SP [mmHg]')
plot(1:length(PTT.('PPGfeetICG').data(:,2)),PTT.('PPGfeetICG').data(:,2),'o-');
plot(1:length(PTT.('PPGfeetBCG').data(:,2)),PTT.('PPGfeetBCG').data(:,2),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfeetECG').data(:,2)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
subplot(5,8,40);plot(1:length(PAT.('PPGfeetECG').data(:,3)),PAT.('PPGfeetECG').data(:,3),'o-');hold on;ylabel('DP [mmHg]')
plot(1:length(PTT.('PPGfeetICG').data(:,3)),PTT.('PPGfeetICG').data(:,3),'o-');
plot(1:length(PTT.('PPGfeetBCG').data(:,3)),PTT.('PPGfeetBCG').data(:,3),'o-');
grid on;grid minor
set(gca,'xtick',1:length(PAT.('PPGfeetECG').data(:,3)),'xticklabel',eventList);xtickangle(90);h=legend('w/ ECG','w/ ICG','w/ BCG','Location','best');set(h,'FontSize',legendFontSize);
legend boxoff
export_fig(['../../Data2Result\Subject' fileName(18:20) 'Total.png'])
%%
if exist(['../../Data2Result\TotalCorrelation.mat'],'file')
    load '../../Data2Result\TotalCorrelation.mat'
end
TotalCorrelation(1:length(correlations),1:2,str2double(fileName(18:20))) = correlations;
save(['../../Data2Result\TotalCorrelation.mat'],'TotalCorrelation')
%%
notZeros = any(TotalCorrelation,1);
notZeros = double(squeeze(notZeros))';

notZeros([10,12,20],:)=0;
totalSubjectNum = sum(double(notZeros(:,1)~=0));
correlationMeanSE = [nanmean(TotalCorrelation(:,:,notZeros(:,1)==1),3),nanstd(TotalCorrelation(:,:,notZeros(:,1)==1),0,3)./sqrt(sum(double(TotalCorrelation~=0 & ~isnan(TotalCorrelation)),3))]
correlationTableDP = squeeze(TotalCorrelation(:,2,notZeros(:,1)==1));
correlationTableSP = squeeze(TotalCorrelation(:,1,notZeros(:,1)==1));

%%
% figure(103);maximize(gcf);set(gcf,'Color','w')
% tempIdx=1;
% for ii = 1:length(eventList)
%     tempRangeIJ=IJInfoDetail.idx(ii,1):IJInfoDetail.idx(ii,2);
%     idxRange = IJInfoDetail.idx(ii,3):IJInfoDetail.idx(ii,4);
%     subplot(4,5,tempIdx);plot(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),'o')
%     subplot(4,5,tempIdx);text(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),cellstr(num2str((idxRange)')),'fontsize',7)
%     if ~all(isnan(IJInfoDetail.data(tempRangeIJ,1))) && ~all(isnan(IJInfoDetail.data(tempRangeIJ,2)))
%         temp=corrcoef(IJInfoDetail.data(tempRangeIJ,1),IJInfoDetail.data(tempRangeIJ,2),'rows','complete');
%         if length(temp)==1
%             IJcorrelation = 0;
%         else
%             IJcorrelation = temp(1,2);
%         end
%     else
%         IJcorrelation = 0;
%     end
%     xlabel('I-J Interval [sec]');ylabel('DP [mmHg]');title([eventList{ii} ', r=' num2str(IJcorrelation)])
%     
%     
%     tempRangeJK=JKInfoDetail.idx(ii,1):JKInfoDetail.idx(ii,2);
%     idxRange = JKInfoDetail.idx(ii,3):JKInfoDetail.idx(ii,4);
%     subplot(4,5,10+tempIdx);plot(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),'o')
%     subplot(4,5,10+tempIdx);text(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),cellstr(num2str((idxRange)')),'fontsize',7)
%     if ~all(isnan(JKInfoDetail.data(tempRangeJK,1))) && ~all(isnan(JKInfoDetail.data(tempRangeJK,2)))
%         temp=corrcoef(JKInfoDetail.data(tempRangeJK,1),JKInfoDetail.data(tempRangeJK,2),'rows','complete');
%         if length(temp)==1
%             JKcorrelation = 0;
%         else
%             JKcorrelation = temp(1,2);
%         end
%     else
%         JKcorrelation = 0;
%     end
%     xlabel('J-K Amplitude');ylabel('PP [mmHg]');title([eventList{ii} ', r=' num2str(JKcorrelation)])
%     tempIdx = tempIdx+1;
% end
% export_fig(['../../Data2Result\Subject' fileName(18:20) 'IJ_JK Info.png'])
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
    
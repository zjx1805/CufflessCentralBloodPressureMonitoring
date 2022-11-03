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
    };
    
fileIndex = 27;
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
        ax14=subplot(814);plot(timesig,cumtrapz(timesig,ICGdzdtsig));ylabel('ICGdzdt integrated');hold on;grid on;grid minor;

        
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
        linkaxes([ax11,ax12,ax13,ax14],'x')
        
        %% ECGMax -> ICGMax
        [~,ICGdzdtMaxIncludeMask,ICGdzdtMap]=alignSignal(ECGMaxLoc,ICGdzdtMaxLoc,[0,0.3],'right');
        ICGdzdtMax=expandSignal(ICGdzdtMax,ICGdzdtMaxIncludeMask,ICGdzdtMap,BPLength);
        ICGdzdtMaxLoc=expandSignal(ICGdzdtMaxLoc,ICGdzdtMaxIncludeMask,ICGdzdtMap,BPLength);
        fICGMax.XData = startTime+ICGdzdtMaxLoc; fICGMax.YData = ICGdzdtMax;
        subplot(812);htxt=text(startTime+ICGdzdtMaxLoc,1.05*ICGdzdtMax,cellstr(num2str((1:length(ICGdzdtMax))')),'fontsize',7);set(htxt,'Clipping','on')
%         fprintf(['Length difference of ECGMax and ICGdzdtMax for Fig ' num2str(figIdx) ': ' num2str(length(BPMaxLoc)-length(ICGdzdtMaxLoc)) '\n'])
        
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
        
        
        
        
        figIdx = figIdx+1;
    end
    
    eventIdx = eventIdx+1;
    
end


%%


clear all;close all;clc

%%% Change the file path as needed
load ../../Data\WAVE_013-supine.mat
%%% Variable assignment
BPCuff=data(:,1)*100; % mmHg
ECG1=data(:,3); 
ICG=data(:,4);
PPGtoe=data(:,5);
PPGear=data(:,6);
PPGfingerTip=data(:,7);
PPGfingerWrap=data(:,8);
BPNexfin=data(:,9)*100; % mmHg
ICGdzdt=data(:,11);
ECG2=data(:,12);
time=0:0.001:0.001*(length(data)-1);
totalLength=length(data);
fs=1000; % sampling frequency
%%% Filter the signal
[u,v]=butter(1,20/(fs/2));
BPCuffFiltered=filtfilt(u,v,BPCuff); % Use filtfilt so that there is no phase delay
BPNexfinFiltered=filtfilt(u,v,BPNexfin);
[u,v]=butter(1,50/(fs/2));
ECG2Filtered=filtfilt(u,v,ECG2);
[u,v]=butter(1,[0.5,10]/(fs/2));
PPGearFiltered=filtfilt(u,v,PPGear);
PPGtoeFiltered=filtfilt(u,v,PPGtoe);
[u,v]=butter(1,[0.5,10]/(fs/2));
ICGdzdtFiltered=filtfilt(u,v,ICGdzdt);

%%% Use timeRange to specify the region for analysis (the manual
%%% segmentation can also be specified by timeRange). The unit is second
timeRange=[48,223]; % SB (slow breathing is roughly from 48 to 223 seconds)
timeRange=[282,400]; % R1
timeRange=[440,550]; % MA
timeRange=[580,720]; % R2
% timeRange=[670,685];
% timeRange=[780,870]; % CP
timeRange=[1020,1120]; % R3
% timeRange=[1100,1120];
% timeRange=[1250,1260]; % Nitro

%%% FFT
signal_fft = abs(fft(ICGdzdt)/totalLength);
P1 = signal_fft(1:floor(totalLength/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:floor(totalLength/2))/totalLength;
figure(1)
plot(f,P1)

%%% Raw/Filtered signal plotting. use linkaxes so that all subplots have the same X-axis range when zooming
figure(2)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
ax1=subplot(6,1,1);
plot(time,BPNexfin);hold on
plot(time,BPNexfinFiltered)
ylabel('BP Nexfin');ylim([0,200])
ax2=subplot(6,1,2);
plot(time,PPGtoe);hold on
plot(time,PPGtoeFiltered)
ylabel('PPG toe')
ax3=subplot(6,1,3);
plot(time,ECG2);hold on
plot(time,ECG2Filtered)
ylabel('ECG2')
ax4=subplot(6,1,4);
plot(time,ICGdzdt);hold on
plot(time,ICGdzdtFiltered)
linkaxes([ax1,ax2,ax3,ax4],'x')

%%% Finding peaks/foots of the signal, change 'MinPeakHeight'/'MinPeakDistance' as needed according to the signal
%%% Note that we would rather miss some peaks/foots than including
%%% unnecessary peaks/foots because the missing peaks/foots will be
%%% recovered later during beat-by-beat analysis.
[BPNexfinMax,BPNexfinMaxLoc]=findpeaks(BPNexfinFiltered,fs,'MinPeakHeight',100,'MinPeakDistance',0.48);
[BPNexfinMin,BPNexfinMinLoc]=findpeaks(-BPNexfinFiltered,fs,'MinPeakHeight',-100,'MinPeakDistance',0.48);
subplot(6,1,1)
plot(BPNexfinMaxLoc,BPNexfinMax,'go')
plot(BPNexfinMinLoc,-BPNexfinMin,'ro')

[PPGtoeMax,PPGtoeMaxLoc]=findpeaks(PPGtoeFiltered,fs,'MinPeakHeight',0,'MinPeakDistance',0.35);
[PPGtoeMin,PPGtoeMinLoc]=findpeaks(-PPGtoeFiltered,fs,'MinPeakHeight',0,'MinPeakDistance',0.35);
subplot(6,1,2)
plot(PPGtoeMaxLoc,PPGtoeMax,'go')
plot(PPGtoeMinLoc,-PPGtoeMin,'ro')
[ECG2Max,ECG2MaxLoc]=findpeaks(ECG2Filtered,fs,'MinPeakHeight',0.48,'MinPeakDistance',0.2);
subplot(6,1,3)
plot(ECG2MaxLoc,ECG2Max,'go')
[ICGdzdtMax,ICGdzdtMaxLoc]=findpeaks(ICGdzdtFiltered,fs,'MinPeakHeight',0.48,'MinPeakDistance',0.15);
% legend({'Raw','Filtered','Max'},'Location','eastoutside')
subplot(6,1,4)
plot(ICGdzdtMaxLoc,ICGdzdtMax,'go');hold on;grid on
ylabel('ICG dz/dt')

%% Main analysis starts
% windowSize: window length of the moving standard deviation 
% thresholdStd: moving std of BP less than this value will be marked as
% candidate region where NexfinBP calibration occurs
% minWidth: those marked as candidate region where NexfinBP calibration
% occurs that is smaller than this width will be excluded (because they are
% mostly probably not during the calibration process. The unit of this
% variable is second
% maxGapWidth: those segments marked as candidate region where NexfinBP calibration
% occurs will be connected together if they are less than maxGapWidth
% apart. The unit of this variable is second
% minTimeDuration: minimum length of data segments used for analysis, i.e.,
% data segments shorter than this will be excluded from analysis. The unit
% of this variable is second 

windowSize=300;thresholdStd=3;maxGapWidth=1.2;minWidth=0.15;minTimeDuration=5;
BPNexfinMovStd=movstd(BPNexfinFiltered,windowSize); % windowSize-point moving standard deviation
ax5=subplot(6,1,5);
plot(time,BPNexfinMovStd);hold on
ylabel({'BP Moving','Standard Deviation'});xlabel('Absolute Time [sec]')
linkaxes([ax1,ax2,ax3,ax4,ax5],'x')
% The function BPexcludedRange specifies those regions where Nexfin BP
% calibration happens. The output of the function, BPexcludedRangeMatrix,
% is a N by 2 matrix where the first element of each row is the starting
% time of each calibration segment and the second element the ending time.
% The unit is second
[BPexcludedRangeMatrix]=BPexcludedRange(BPNexfinFiltered,timeRange,fs,windowSize,thresholdStd,maxGapWidth,minWidth);
% Mark the regions for Nexfin calibration as red. Please double check the
% BP plot to make sure that the regions are correct
for ii=1:size(BPexcludedRangeMatrix,1)
    subplot(6,1,5)
    tempRange=(BPexcludedRangeMatrix(ii,1):(1/fs):BPexcludedRangeMatrix(ii,2));
    plot(tempRange,BPNexfinMovStd(fix(tempRange/(1/fs)+1)),'r.')
    subplot(6,1,1)
    plot(tempRange,BPNexfinFiltered(fix(tempRange/(1/fs)+1)),'r.')
end
% subplot(6,1,5)
% legend({'Raw','Excluded'},'Location','eastoutside')
% subplot(6,1,1)
% legend({'Raw','Filtered','SP','DP','BP Calibration'},'Location','eastoutside')
% Excluding all Nexfin BP calibration segments from analysis. It is also a
% N by 2 matrix where the first element of each row means the starting time
% of each usable segments and the second element means the ending time. The
% unit is second
includedRangeMatrix=timeComplement(timeRange,BPexcludedRangeMatrix,minTimeDuration);

%% Extract PTT/PAT/ICG B-point/DP/SP using beat-by-beat analysis. 
% Detailed explanation of the function findFeature is given in
% findFeature.m file
PTT=[];PAT=[];Bpoint=[];interceptLine=[];interceptPoint=[];DPinfo=[];SPinfo=[];
for ii=1:size(includedRangeMatrix,1)
    segRange=includedRangeMatrix(ii,:);
    [PTTtemp,PATtemp,BpointTemp,interceptLineTemp,interceptPointTemp,DPinfoTemp,SPinfoTemp,DPfixTemp,SPfixTemp]=findFeatures(segRange,fs,ECG2MaxLoc,PPGtoeFiltered,PPGtoeMaxLoc,PPGtoeMinLoc,...
        ICGdzdtFiltered,ICGdzdtMaxLoc,BPNexfinFiltered,BPNexfinMaxLoc,BPNexfinMinLoc);
    PTT=[PTT;PTTtemp];PAT=[PAT;PATtemp];Bpoint=[Bpoint;BpointTemp];interceptLine=[interceptLine;interceptLineTemp];interceptPoint=[interceptPoint;interceptPointTemp];
    DPinfo=[DPinfo;DPinfoTemp];SPinfo=[SPinfo;SPinfoTemp];
    subplot(6,1,2)
    plot(interceptPointTemp(:,1),interceptPointTemp(:,2),'b^')
    line(interceptLineTemp(:,1),interceptLineTemp(:,2),'Color','b','LineStyle','--')
    subplot(6,1,4)
    plot(BpointTemp(:,2),BpointTemp(:,3),'b^')
end
% subplot(6,1,2)
% legend({'Raw','Filtered','Max','Min','Foot'},'Location','eastoutside')
% subplot(6,1,4)
% legend({'Raw','Filtered','Max','B-point'},'Location','eastoutside')


figure(10)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
subplot(5,1,1)
plot(PAT(:,2),PAT(:,1)*1000)
ylabel('PAT [ms]')
subplot(5,1,2)
plot(PTT(:,2),PTT(:,1)*1000)
ylabel('PTT [ms]')
subplot(5,1,3)
plot(PTT(:,2),DPinfo(:))
ylabel('DP [mmHg]')
subplot(5,1,4)
plot(PTT(:,2),SPinfo(:))
ylabel('SP [mmHg]');xlabel('Absolute Time [sec]')

figure(11)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
subplot(2,2,1)
plot(PTT(:,1)*1000,DPinfo(:),'o')
xlabel('PTT [ms]');ylabel('DP [mmHg]')
subplot(2,2,2)
plot(PTT(:,1)*1000,SPinfo(:),'o')
xlabel('PTT [ms]');ylabel('SP [mmHg]')
subplot(2,2,3)
plot(PAT(:,1)*1000,DPinfo(:),'o')
xlabel('PAT [ms]');ylabel('DP [mmHg]')
subplot(2,2,4)
plot(PAT(:,1)*1000,SPinfo(:),'o')
xlabel('PAT [ms]');ylabel('SP [mmHg]')



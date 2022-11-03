% Related to the NIH project. No longer participating in it.

clear all;close all;clc
addpath('.\export_fig')
tic
sID=1;filename='../Data\test-20170410-s1-acqk';
% sID=2;filename='../Data\test-20170411-s2-acqk';
% sID=3;filename='../Data\test-20170412-s3-acqk';
% sID=4;filename='../Data\test-20170413-s4-acqk';
% sID=5;filename='../Data\test-20170413-s5-acqk';
% sID=6;filename='../Data\test-20170414-s6-acqk';

eval(['load ' filename]) 
load ../Data\eventTimes
load ../Data\SubjectParam

xAccelRaw=data(:,1)/4;
yAccelRaw=data(:,9)/4;
zAccelRaw=data(:,5)/4;
ECGRaw=data(:,10);
BPRaw=data(:,4);
SVRaw=data(:,6);
CORaw=data(:,8);
HRRaw=CORaw./SVRaw*1000;
HRRaw(isnan(HRRaw))=0;
HRRaw(isinf(HRRaw))=0;
TPRRaw=BPRaw./CORaw;
TPRRaw(isnan(TPRRaw))=0;
TPRRaw(isinf(TPRRaw))=0;
xAccelFiltered=data(:,12)/4;
yAccelFiltered=data(:,14)/4;
zAccelFiltered=data(:,13)/4;
zScale=data(:,11);
fs=1000;
totalLength=length(xAccelRaw);
time=(1:totalLength)/1000;
[u,v]=butter(1,100/(fs/2));
BPFiltered=filtfilt(u,v,BPRaw);
COFiltered=filtfilt(u,v,CORaw);
SVFiltered=filtfilt(u,v,SVRaw);
HRFiltered=filtfilt(u,v,HRRaw);
TPRFiltered=filtfilt(u,v,TPRRaw);

dataT=[BPFiltered,BPFiltered,HRFiltered,COFiltered,SVFiltered,TPRFiltered];

%%
ssTimeMatrix=eventTimes(sID).ssTimeMatrix;
cpTimeMatrix=eventTimes(sID).cpTimeMatrix;
maTimeMatrix=eventTimes(sID).maTimeMatrix;
sbTimeMatrix=eventTimes(sID).sbTimeMatrix;
hbTimeMatrix=eventTimes(sID).hbTimeMatrix;
hrTimeMatrix=eventTimes(sID).hrTimeMatrix;
TimeMatrix={ssTimeMatrix,cpTimeMatrix,maTimeMatrix,sbTimeMatrix,hbTimeMatrix,hrTimeMatrix};
ssTime=reshape(ssTimeMatrix,1,[]);cpTime=reshape(cpTimeMatrix,1,[]);maTime=reshape(maTimeMatrix,1,[]);sbTime=reshape(sbTimeMatrix,1,[]);hbTime=reshape(hbTimeMatrix,1,[]);
hrTime=reshape(hrTimeMatrix,1,[]);
eventNames={'ss','cp','ma','sb','hb','hr'};
eventSeq={'ss(1)','cp','ss(2)','ma','ss(3)','sb','ss(4)','hb','ss(5)','hr(1)','hr(2)','hr(3)','hr(4)','hr(5)','ss(6)'};
endpointNames={'SP','DP','HR','CO','SV','TPR'};
endpointNamesPlot={'BP','BP','HR','CO','SV','TPR'};

%%
% signal_fft = abs(fft(HRRaw)/totalLength);
% P1 = signal_fft(1:floor(totalLength/2)+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = fs*(0:floor(totalLength/2))/totalLength;
% figure(1)
% plot(f,P1)

figure(10)
subplot(311)
plot(time,xAccelRaw);hold on;grid on;
plot(time,xAccelFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
legend('Raw','Filtered');xlabel('Time [sec]');ylabel('X Acceleration')
subplot(312)
plot(time,yAccelRaw);hold on;grid on;
plot(time,yAccelFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
legend('Raw','Filtered');xlabel('Time [sec]');ylabel('Y Acceleration')
subplot(313)
plot(time,zAccelRaw);hold on;grid on;
plot(time,zAccelFiltered)
plot(time,zScale)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
legend('Raw','Filtered','via Scale');xlabel('Time [sec]');ylabel('Z Acceleration')

figure(15)
subplot(511)
plot(time,BPRaw);hold on;grid on;
plot(time,BPFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
ylabel('BP');ylim(SubjectParam(sID).TotalPlot.BP)
subplot(512)
plot(time,CORaw);hold on;grid on;
plot(time,COFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
ylabel('CO');ylim(SubjectParam(sID).TotalPlot.CO)
subplot(513)
plot(time,SVRaw);hold on;grid on;
plot(time,SVFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
ylabel('SV');ylim(SubjectParam(sID).TotalPlot.SV)
subplot(514)
plot(time,HRRaw);hold on;grid on;
plot(time,HRFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
ylabel('HR');ylim(SubjectParam(sID).TotalPlot.HR)
subplot(515)
plot(time,TPRRaw);hold on;grid on;
plot(time,TPRFiltered)
vline(ssTime,'r--');vline(cpTime,'g--');vline(maTime,'b--');vline(sbTime,'k--');vline(hbTime,'c--');vline(hrTime,'m--')
ylabel('TPR');xlabel('Time [sec]');ylim(SubjectParam(sID).TotalPlot.TPR)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
export_fig(['../Figure\Subject' num2str(sID) '\endpointTotal.png'])

%% ss
maxLocTotal={};minLocTotal={};maxPtTotal={};minPtTotal={};
for ii=1:length(ssTimeMatrix)
    for jj=1:length(endpointNames)
        if jj==2 %% DP is obtained when extracting SP
            continue
        else
            endpointName=endpointNames{jj}; 
        end  
        figure(20)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        set(gcf,'Color','w')
        tempStart=floor(ssTimeMatrix(ii,1)/time(end)*totalLength);tempEnd=floor(ssTimeMatrix(ii,2)/time(end)*totalLength);
        dataTemp=dataT(tempStart:tempEnd,jj);timeTemp=ssTimeMatrix(ii,1)+(0:length(dataTemp)-1)'/fs;
        if jj==1
            [maxPt,maxLoc]=findpeaks(dataTemp,timeTemp,'MinPeakHeight',SubjectParam(sID).BP.ss(ii,1),'MinPeakDistance',0.4);
            [minPt,minLoc]=findpeaks(-dataTemp,timeTemp,'MinPeakHeight',-SubjectParam(sID).BP.ss(ii,2),'MinPeakDistance',0.4);
            maxLocTotal{ii}=maxLoc;minLocTotal{ii}=minLoc;maxPtTotal{ii}=maxPt;minPtTotal{ii}=minPt;
            resultT.ss(ii).SPLoc=maxLoc;resultT.ss(ii).DPLoc=minLoc;resultT.ss(ii).SP=maxPt;resultT.ss(ii).DP=-minPt;
            resultT.ss(ii).SPAvg=mean(maxPt(floor(length(maxPt)/3*2):end));resultT.ss(ii).SPStd=std(maxPt(floor(length(maxPt)/3*2):end));
            resultT.ss(ii).DPAvg=mean(-minPt(floor(length(minPt)/3*2):end));resultT.ss(ii).DPStd=std(-minPt(floor(length(minPt)/3*2):end));
            resultT.ss(ii).StartTime=timeTemp(1);resultT.ss(ii).EndTime=timeTemp(end);
            plot(timeTemp,dataTemp,'b-');hold on;grid on;
            plot(maxLoc,maxPt,'ro')
            plot(minLoc,-minPt,'go')
        else
            resultT.ss(ii).(endpointName)=dataTemp;
            resultT.ss(ii).([endpointName,'Avg'])=mean(dataTemp(floor(length(dataTemp)/3*2):end));
            resultT.ss(ii).([endpointName,'Std'])=std(dataTemp(floor(length(dataTemp)/3*2):end));
            plot(timeTemp,dataTemp,'b-')
        end
        xlabel('Time [sec]');ylabel(endpointName)
        export_fig(['../Figure\Subject' num2str(sID) '\ss' num2str(ii) '_' endpointName '.png'])
        clf
    end
end
% legendText={};
% for ii=1:length(maxPtTotal)
%     subplot(211)
%     plot(maxPtTotal{ii});hold on;
%     subplot(212)
%     plot(minPtTotal{ii});hold on;
%     legendText=horzcat(legendText,['ss' num2str(ii)]);
% end
% subplot(211);legend(legendText);legend('boxoff')
% subplot(212);legend(legendText);legend('boxoff')
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% set(gcf,'Color','w')

%% cp/ma/sb/hb
cutoff=[0,0,0,0,3500,0]; %% last 3.5 sec of hb data is excluded because there might be a delay between resuming breathing and recording the stop time
for ii=2:5 
    for jj=1:length(endpointNames)
        if jj==2 %% DP is obtained when extracting SP
            continue
        else
            endpointName=endpointNames{jj}; 
        end  
        figure(30)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        set(gcf,'Color','w')
        eventName=eventNames{ii};
        tempStart=floor(TimeMatrix{ii}(1)/time(end)*totalLength);tempEnd=floor(TimeMatrix{ii}(2)/time(end)*totalLength);
        dataTemp=dataT(tempStart:tempEnd,jj);timeTemp=TimeMatrix{ii}(1)+(0:length(dataTemp)-1)'/fs;
        if jj==1
            [maxPt,maxLoc]=findpeaks(dataTemp,timeTemp,'MinPeakHeight',SubjectParam(sID).BP.(eventName)(1),'MinPeakDistance',0.4);
            [minPt,minLoc]=findpeaks(-dataTemp,timeTemp,'MinPeakHeight',-SubjectParam(sID).BP.(eventName)(2),'MinPeakDistance',0.4);
            resultT.(eventName).SPLoc=maxLoc;resultT.(eventName).DPLoc=minLoc;resultT.(eventName).SP=maxPt;resultT.(eventName).DP=-minPt;
            resultT.(eventName).SPAvg=mean(maxPt(floor(length(maxPt)/3*2):end));resultT.(eventName).SPStd=std(maxPt(floor(length(maxPt)/3*2):end));
            resultT.(eventName).DPAvg=mean(-minPt(floor(length(minPt)/3*2):end));resultT.(eventName).DPStd=std(-minPt(floor(length(minPt)/3*2):end));
            resultT.(eventName).StartTime=timeTemp(1);resultT.(eventName).EndTime=timeTemp(end);
            plot(timeTemp,dataTemp,'b-');hold on;grid on;
            plot(maxLoc,maxPt,'ro')
            plot(minLoc,-minPt,'go')
        else
            resultT.(eventName).(endpointName)=dataTemp;
            resultT.(eventName).([endpointName,'Avg'])=mean(dataTemp(floor(length(dataTemp)/3*2):end-cutoff(ii)));
            resultT.(eventName).([endpointName,'Std'])=std(dataTemp(floor(length(dataTemp)/3*2):end-cutoff(ii)));
            plot(timeTemp,dataTemp,'b-')
        end
        xlabel('Time [sec]');ylabel(endpointName)
        export_fig(['../Figure\Subject' num2str(sID) '\' (eventName) '_' endpointName '.png'])
        clf
    end
end

%% hr
maxLocTotal={};minLocTotal={};maxPtTotal={};minPtTotal={};
for ii=1:length(hrTimeMatrix)
    for jj=1:length(endpointNames)
        if jj==2 %% DP is obtained when extracting SP
            continue
        else
            endpointName=endpointNames{jj}; 
        end  
        figure(30)
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        set(gcf,'Color','w')
        tempStart=floor(hrTimeMatrix(ii,1)/time(end)*totalLength);tempEnd=floor(hrTimeMatrix(ii,2)/time(end)*totalLength);
        dataTemp=dataT(tempStart:tempEnd,jj);timeTemp=hrTimeMatrix(ii,1)+(0:length(dataTemp)-1)'/fs;
        if jj==1
            [maxPt,maxLoc]=findpeaks(dataTemp,timeTemp,'MinPeakHeight',SubjectParam(sID).BP.hr(ii,1),'MinPeakDistance',0.4);
            [minPt,minLoc]=findpeaks(-dataTemp,timeTemp,'MinPeakHeight',-SubjectParam(sID).BP.hr(ii,2),'MinPeakDistance',0.4);
            maxLocTotal{ii}=maxLoc;minLocTotal{ii}=minLoc;maxPtTotal{ii}=maxPt;minPtTotal{ii}=minPt;
            resultT.hr(ii).SPLoc=maxLoc;resultT.hr(ii).DPLoc=minLoc;resultT.hr(ii).SP=maxPt;resultT.hr(ii).DP=-minPt;
            resultT.hr(ii).SPAvg=mean(maxPt(floor(length(maxPt)/3*2):end));resultT.hr(ii).SPStd=std(maxPt(floor(length(maxPt)/3*2):end));
            resultT.hr(ii).DPAvg=mean(-minPt(floor(length(minPt)/3*2):end));resultT.hr(ii).DPStd=std(-minPt(floor(length(minPt)/3*2):end));
            resultT.hr(ii).StartTime=timeTemp(1);resultT.hr(ii).EndTime=timeTemp(end);
            plot(timeTemp,dataTemp,'b-');hold on;grid on;
            plot(maxLoc,maxPt,'ro')
            plot(minLoc,-minPt,'go')
        else
            resultT.hr(ii).(endpointName)=dataTemp;
            resultT.hr(ii).([endpointName,'Avg'])=mean(dataTemp(floor(length(dataTemp)/3*2):end));
            resultT.hr(ii).([endpointName,'Std'])=std(dataTemp(floor(length(dataTemp)/3*2):end));
            plot(timeTemp,dataTemp,'b-')
        end
        xlabel('Time [sec]');ylabel(endpointName)
        export_fig(['../Figure\Subject' num2str(sID) '\hr' num2str(ii) '_' endpointName '.png'])
        clf
    end
end

%%
eventNum=length(eventSeq);endpointNum=length(endpointNames);eventStartTime=zeros(eventNum,1);eventEndTime=zeros(eventNum,1);
dataAvg=zeros(eventNum,endpointNum);
dataStd=zeros(eventNum,endpointNum);
dataStartTime=zeros(eventNum,1);
dataEndTime=zeros(eventNum,1);
for ii=1:length(endpointNames)
    for jj=1:length(eventSeq)
        eval(['dataAvg(jj,ii)=resultT.' eventSeq{jj} '.' endpointNames{ii} 'Avg;'])
        eval(['dataStd(jj,ii)=resultT.' eventSeq{jj} '.' endpointNames{ii} 'Std;'])
        eval(['dataStartTime(jj,1)=resultT.' eventSeq{jj} '.StartTime;'])
        eval(['dataEndTime(jj,1)=resultT.' eventSeq{jj} '.EndTime;'])
    end
end
figure(40)
subplotIdx=1;
for ii=1:endpointNum
    
    subplot(endpointNum-1,1,subplotIdx)
    errorbar((dataStartTime+dataEndTime)/2,dataAvg(:,ii),dataStd(:,ii))
    text((dataStartTime+dataEndTime)/2,dataAvg(:,ii)*0.95,eventSeq)
    ylabel(endpointNamesPlot{ii})
    
    if ii==1
        hold on
        errorbar((dataStartTime+dataEndTime)/2,dataAvg(:,ii),dataStd(:,ii))
        grid on; grid minor;
    else
        subplotIdx=subplotIdx+1;
    end
    grid on; grid minor;
end
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
export_fig(['../Figure\Subject' num2str(sID) '\endpointAvgStd.png'])

output=[dataAvg(:,1);dataAvg(:,2);dataAvg(:,3);dataAvg(:,4);dataAvg(:,5);dataAvg(:,6)];
toc
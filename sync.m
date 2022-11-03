clear all;close all;clc
addpath('.\export_fig')
tic
% sID=1;filename='../Data\test-20170410-s1-acqk';filenameXLS='../Data\test-20170410-S_1#1-Samsung.xlsx';dataRange='D22:D190664';
% sID=1;filename='../Data\test-20170410-s1-acqk';filenameXLS='../Data\test-20170410-S_1#2-Samsung.xlsx';dataRange='D22:D299966';
% subIdx=1;
% dispRange=[-0.6,0.6;-1e4,3.5e4];BioPeak=[0.1,500];SumPeak=[2e4,50;-1e4,154];delay=18.92;SumDataRange=2000:19880;BioDataRange=delay*1000+[8000:79520]; % 0 delay
% dispRange=[-0.6,0.6;-1e4,3.5e4];BioPeak=[0.1,500];SumPeak=[2e4,50;-1e4,154];delay=18.92;SumDataRange=50:4000;BioDataRange=delay*1000+[2000:16000]; % 0 delay
% sID=2;filename='../Data\test-20170411-s2-acqk';filenameXLS='../Data\test-20170411_S2_Samsung.xlsx';dataRange='F23:F600173';
% subIdx=1;
% dispRange=[-0.3,0.3;3.95e5,4.15e5];BioPeak=[0.1,500];SumPeak=[4.02e5,140;-4.05e5,100];delay=429.65;SumDataRange=5000:20000;BioDataRange=delay*1000+[20000:80000]; % 0 delay
sID=3;filename='../Data\test-20170412-s3-acqk';filenameXLS='../Data\test-20170412_S3_Samsung.xlsx';dataRange='F23:F533636';
subIdx=4;
% dispRange=[-0.6,0.6;-5e4,-2e4];BioPeak=[0.2,500];SumPeak=[-3.8e4,50;3.5e4,100];delay=16.47;SumDataRange=1:15000;BioDataRange=delay*1000+[1:60000]; % 0 delay
% dispRange=[-0.6,0.6;-7.5e4,-5e4];BioPeak=[0.2,500];SumPeak=[-6e4,50;6.3e4,100];delay=16.47;SumDataRange=1e5:1.191e5;BioDataRange=delay*1000+[4e5:4.764e5]; % 2 delay
% dispRange=[-0.6,0.6;-6.5e4,-4.5e4];BioPeak=[0.2,500];SumPeak=[-5.4e4,50;5.9e4,100];delay=16.47;SumDataRange=2.302e5:2.44e5;BioDataRange=delay*1000+[9.208e5:9.76e5]; % 4 delay
dispRange=[-0.6,0.6;-9e4,-6.5e4];BioPeak=[0.2,500];SumPeak=[-7.6e4,50;8e4,100];delay=16.47;SumDataRange=4.92e5:5.12e5;BioDataRange=delay*1000+[4.92e5*4:5.12e5*4]; % 13 delay
% sID=4;filename='../Data\test-20170413-s4-acqk';filenameXLS='../Data\test-20170413_S4_Samsung.xlsx';dataRange='F23:F435079';
% subIdx=4;
% dispRange=[-0.6,0.6;-6e4,-3e4];BioPeak=[0.1,500];SumPeak=[-4.5e4,40;4.5e4,100];delay=276.39;SumDataRange=1:14880;BioDataRange=delay*1000+[1:14880*4]; % 0 delay
% dispRange=[-0.6,0.6;-6e4,-4e4];BioPeak=[0.095,500];SumPeak=[-5e4,40;5.8e4,100];delay=276.39;SumDataRange=1e5:1.2e5;BioDataRange=delay*1000+[4e5:4.8e5]; % 2 delay
% dispRange=[-0.3,0.3;-4.5e4,-1.5e4];BioPeak=[0.05,100;0.1,500];SumPeak=[-2.5e4,40;3e4,100];delay=276.39;SumDataRange=2.5e5:2.688e5;BioDataRange=delay*1000+[10e5:10.752e5]; % 4 delay
% dispRange=[-0.4,0.4;-7.5e4,-4.5e4];BioPeak=[0.06,50;0.15,500];SumPeak=[-5.3e4,40;6e4,100];delay=276.39;SumDataRange=4.15e5:4.25e5;BioDataRange=delay*1000+[16.6e5:17e5]; % 7 delay
% sID=5;filename='../Data\test-20170413-s5-acqk';filenameXLS='../Data\test-20170413-s5-samsung.xlsx';dataRange='F23:F451570';
% subIdx=4;
% dispRange=[-0.1,0.5;0,5e4];BioPeak=[0.1,500];SumPeak=[2.20e4,105;4.5e4,100];delay=137.67;SumDataRange=5000:20000;BioDataRange=delay*1000+[20000:80000]; % 0 delay
% dispRange=[-0.1,0.5;3e4,7e4];BioPeak=[0.1,500];SumPeak=[2.20e4,105;4.5e4,100];delay=137.67;SumDataRange=1.02e5:1.2e5;BioDataRange=delay*1000+[4.08e5:4.8e5]; % 1 delay
% dispRange=[-0.1,0.5;3.5e4,6.5e4];BioPeak=[0.1,500];SumPeak=[5e4,105;4.5e4,100];delay=137.67;SumDataRange=2.12e5:2.32e5;BioDataRange=delay*1000+[8.48e5:9.28e5]; % 3 delay
% dispRange=[-0.1,0.5;5e4,9e4];BioPeak=[0.1,500];SumPeak=[7e4,105;4.5e4,100];delay=137.67;SumDataRange=4.065e5:4.19e5;BioDataRange=delay*1000+[16.26e5:16.76e5]; % ? delay
% sID=6;filename='../Data\test-20170414-s6-acqk';filenameXLS='../Data\test-20170414-s6-samsung.xlsx';dataRange='F23:F418723';
% subIdx=1;
% dispRange=[-0.3,0.3;3.95e5,4.15e5];BioPeak=[0.1,500];SumPeak=[4.02e5,140;-4.05e5,100];delay=165.53;SumDataRange=6000:20000;BioDataRange=delay*1000+[23900:80000]; % 0 delay
% dispRange=[-0.3,0.3;3.75e5,4.00e5];BioPeak=[0.1,500];SumPeak=[3.80e5,150;-4.05e5,100];delay=165.53;SumDataRange=7.2e4:9e4;BioDataRange=delay*1000+[28.8e4:36e4]; % 1 sample delay
% dispRange=[-0.2,0.42;-8e4,-6e4];BioPeak=[0.1,500];SumPeak=[-7.4e4,150;-4.05e5,100];delay=165.53;SumDataRange=1.640e5:1.842e5;BioDataRange=delay*1000+[1.640e5*4:1.842e5*4]; % 4 sample delay
% dispRange=[-0.2,0.4;-6e4,-4e4];BioPeak=[0.1,500];SumPeak=[-5.3e4,140;-4.05e5,100];delay=165.53;SumDataRange=3.913e5:4.064e5;BioDataRange=delay*1000+[3.913e5*4:4.064e5*4]; % 7 delay

eval(['load ' filename]) 
ECGRaw=data(:,10);
ECGSumsung=xlsread(filenameXLS,dataRange);
fs=1000;
totalLength=length(ECGRaw);
time=(1:totalLength)/1000;
% signal_fft = abs(fft(ECGRaw)/totalLength);
% P1 = signal_fft(1:floor(totalLength/2)+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = fs*(0:floor(totalLength/2))/totalLength;
% figure(1)
% plot(f,P1)
% [u,v]=butter(1,100/(fs/2));
% TPRFiltered=filtfilt(u,v,TPRRaw);

figure(5)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w')
subplot(5,1,1)
plot(ECGRaw);ylabel('ECG Biopac')
% ylim(dispRange(1,:))
subplot(5,1,2)
plot(ECGSumsung);ylabel('ECG Sumsung')
% axis([1,length(ECGSumsung),dispRange(2,:)])
% ylim(dispRange(2,:))
subplot(513)

if sID==1 || sID==3 || sID==5
    plot(BioDataRange,ECGRaw(BioDataRange));ylabel('ECG Biopac')
    [maxPt1,maxLoc1]=findpeaks(ECGRaw(BioDataRange),'MinPeakHeight',BioPeak(1),'MinPeakDistance',BioPeak(2));
    maxLoc1=maxLoc1+BioDataRange(1)-1;
elseif sID==4
    if subIdx==1 || subIdx==2
        plot(BioDataRange,ECGRaw(BioDataRange));ylabel('ECG Biopac')
        [maxPt1,maxLoc1]=findpeaks(ECGRaw(BioDataRange),'MinPeakHeight',BioPeak(1),'MinPeakDistance',BioPeak(2));
        maxLoc1=maxLoc1+BioDataRange(1)-1;
    elseif subIdx==3 || subIdx==4
        plot(BioDataRange,ECGRaw(BioDataRange));ylabel('ECG Biopac');hold on
        [maxPt1Temp,maxLoc1Temp]=findpeaks(ECGRaw(BioDataRange),'MinPeakHeight',BioPeak(1,1),'MinPeakDistance',BioPeak(1,2));
        [minPt1,minLoc1]=findpeaks(-ECGRaw(BioDataRange),'MinPeakHeight',BioPeak(2,1),'MinPeakDistance',BioPeak(2,2));
%         plot(maxLoc1Temp+BioDataRange(1)-1,maxPt1Temp,'bo')
%         plot(minLoc1+BioDataRange(1)-1,-minPt1,'ko')
        maxPt1=[];maxLoc1=[];
        for ii=1:length(minLoc1)
            if ii==1
                tempLoc=maxLoc1Temp(maxLoc1Temp<minLoc1(ii));
                tempPt=maxPt1Temp(maxLoc1Temp<minLoc1(ii));
                maxLoc1=[maxLoc1;tempLoc(end)];maxPt1=[maxPt1;tempPt(end)];
            else
                tempLoc=maxLoc1Temp(and(maxLoc1Temp<minLoc1(ii),maxLoc1Temp>minLoc1(ii-1)));
                tempPt=maxPt1Temp(and(maxLoc1Temp<minLoc1(ii),maxLoc1Temp>minLoc1(ii-1)));
                maxLoc1=[maxLoc1;tempLoc(end)];maxPt1=[maxPt1;tempPt(end)];
            end
        end
        maxLoc1=maxLoc1+BioDataRange(1)-1;
    end
elseif sID==6
    plot(BioDataRange,ECGRaw(BioDataRange));ylabel('ECG Biopac')
    [maxPt1,maxLoc1]=findpeaks(ECGRaw(BioDataRange),'MinPeakHeight',BioPeak(1),'MinPeakDistance',BioPeak(2));
    maxLoc1=maxLoc1+BioDataRange(1)-1;
end
hold on
plot(maxLoc1,maxPt1,'go')
ylim(dispRange(1,:))
subplot(514)

if sID~=5 && sID~=6
    plot(SumDataRange,ECGSumsung(SumDataRange));ylabel('ECG Sumsung')
    hold on
    [maxPt2Temp,maxLoc2Temp]=findpeaks(ECGSumsung(SumDataRange),'MinPeakHeight',SumPeak(1,1),'MinPeakDistance',SumPeak(1,2));
    [minPt2,minLoc2]=findpeaks(-ECGSumsung(SumDataRange),'MinPeakHeight',SumPeak(2,1),'MinPeakDistance',SumPeak(2,2));
%     plot(maxLoc2Temp+SumDataRange(1)-1,maxPt2Temp,'bo')
%     plot(minLoc2+SumDataRange(1)-1,-minPt2,'ko')
    maxPt2=[];maxLoc2=[];
    for ii=1:length(minLoc2)
        if ii==1
            tempLoc=maxLoc2Temp(maxLoc2Temp<minLoc2(ii));
            tempPt=maxPt2Temp(maxLoc2Temp<minLoc2(ii));
            maxLoc2=[maxLoc2;tempLoc(end)];maxPt2=[maxPt2;tempPt(end)];
        else
            tempLoc=maxLoc2Temp(and(maxLoc2Temp<minLoc2(ii),maxLoc2Temp>minLoc2(ii-1)));
            tempPt=maxPt2Temp(and(maxLoc2Temp<minLoc2(ii),maxLoc2Temp>minLoc2(ii-1)));
            maxLoc2=[maxLoc2;tempLoc(end)];maxPt2=[maxPt2;tempPt(end)];
        end
    end
    maxLoc2=maxLoc2+SumDataRange(1)-1;
    minLoc2=minLoc2+SumDataRange(1)-1;
elseif sID==6
    plot(SumDataRange,ECGSumsung(SumDataRange));ylabel('ECG Sumsung')
    hold on
    [maxPt2Temp,maxLoc2Temp]=findpeaks(ECGSumsung(SumDataRange),'MinPeakHeight',SumPeak(1,1),'MinPeakDistance',SumPeak(1,2));
    maxPt2=maxPt2Temp;maxLoc2=maxLoc2Temp+SumDataRange(1)-1;
else % sID=5
    plot(SumDataRange,ECGSumsung(SumDataRange));ylabel('ECG Sumsung')
    hold on
    [maxPt2Temp,maxLoc2Temp]=findpeaks(ECGSumsung(SumDataRange),'MinPeakHeight',SumPeak(1,1),'MinPeakDistance',SumPeak(1,2));
    maxPt2=maxPt2Temp;maxLoc2=maxLoc2Temp+SumDataRange(1)-1;
end
% plot(maxLoc2Temp,maxPt2Temp,'bo')
plot(maxLoc2,maxPt2,'go')
if sID~=5 && sID~=6
    plot(minLoc2,-minPt2,'ro')
end
ylim(dispRange(2,:))
subplot(515)
plot(diff(maxLoc1)/4,'o-')
hold on
if sID==1
    if subIdx==1
        plot([NaN;NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==2
        plot(diff(maxLoc2),'*-')
    elseif subIdx==3
    elseif subIdx==4
    end
elseif sID==2
    if subIdx==1
        plot(diff(maxLoc2),'*-')
    elseif subIdx==2
    elseif subIdx==3
    elseif subIdx==4
    end
elseif sID==3
    if subIdx==1
        plot(diff(maxLoc2),'*-')
    elseif subIdx==2
        plot([NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==3
        plot([NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==4
        plot([NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    end
elseif sID==4
    if subIdx==1
        plot(diff(maxLoc2),'*-')
    elseif subIdx==2
        plot([NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==3
        plot([NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==4
        plot([NaN;NaN;NaN;NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    end
elseif sID==5
    if subIdx==1
        plot(diff(maxLoc2),'*-')
    elseif subIdx==2
        plot([NaN;diff(maxLoc2)],'*-')
    elseif subIdx==3
        plot([NaN;NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==4
        plot([NaN;NaN;NaN;NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    end
elseif sID==6
    if subIdx==1
        plot(diff(maxLoc2),'*-')
    elseif subIdx==2
        plot([NaN;diff(maxLoc2)],'*-')
    elseif subIdx==3
        plot([NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    elseif subIdx==4
        plot([NaN;NaN;NaN;NaN;NaN;NaN;NaN;diff(maxLoc2)],'*-')
    end
end
xlabel('Interval Index');ylabel({'Interval','[samples@250Hz]'})
legend({'Biopac','Sumsung'},'Location','best')

finddelay(diff(maxLoc1)/4,diff(maxLoc2))
[C21,lag21] = xcorr(diff(maxLoc1)/4,diff(maxLoc2));
C21 = C21/max(C21);
[M21,I21] = max(C21);
t21 = lag21(I21);
figure(2)
subplot(3,1,1)
plot(lag21,C21,[t21 t21],[-0.5 1],'r:')
text(t21+20,0.5,['Lag: ' int2str(t21)])
ylabel('C_{21}')
axis tight
title('Cross-Correlations')
% finddelay(ECGRaw(1:4:60000),ECGSumsung(1:15000))

(maxLoc1(1)+3)/4-maxLoc2(1)-delay*250;
BioDiff=diff(maxLoc1)/4;
SumDiff=diff(maxLoc2);
if sID==1
    if subIdx==1
    elseif subIdx==2
    elseif subIdx==3
    elseif subIdx==4
    end
elseif sID==2
    if subIdx==1
    elseif subIdx==2
    elseif subIdx==3
    elseif subIdx==4
    end
elseif sID==3
    if subIdx==1
        fit(maxLoc1/1000,maxLoc1/1000-maxLoc2(1:end-1)/250-delay,'poly1') % 0.002388/418.7605
    elseif subIdx==2
        fit(maxLoc1(3:end)/1000,maxLoc1(3:end)/1000-maxLoc2(1:end-2)/250-delay,'poly1') % 0.002782/359.4536
    elseif subIdx==3
        fit(maxLoc1(5:end)/1000,maxLoc1(5:end)/1000-maxLoc2(1:end-4)/250-delay,'poly1') % 0.002896/345.3039
    elseif subIdx==4
        fit(maxLoc1(14:end)/1000,maxLoc1(14:end)/1000-maxLoc2(1:end-13)/250-delay,'poly1') % 0.003144/318.0662
    end
elseif sID==4
    if subIdx==1
        fit(maxLoc1/1000,maxLoc1/1000-maxLoc2/250-delay,'poly1') % 0.002568/389.4081
    elseif subIdx==2
        fit(maxLoc1(3:end)/1000,maxLoc1(3:end)/1000-maxLoc2(1:end-2)/250-delay,'poly1') % 0.002953/338.6387
    elseif subIdx==3
        fit(maxLoc1(5:end)/1000,maxLoc1(5:end)/1000-maxLoc2(1:end-4)/250-delay,'poly1') % 0.003032/329.8153
    elseif subIdx==4
        fit(maxLoc1(8:end)/1000,maxLoc1(8:end)/1000-maxLoc2(1:end-7)/250-delay,'poly1') % 0.002975/336.1345
    end
elseif sID==5
    if subIdx==1
        fit(maxLoc1/1000,maxLoc1/1000-maxLoc2/250-delay,'poly1') % 0.002362/423.37
    elseif subIdx==2
        fit(maxLoc1(2:end)/1000,maxLoc1(2:end)/1000-maxLoc2(1:end-3)/250-delay,'poly1') % 0.002785/359.0664
    elseif subIdx==3
        fit(maxLoc1(4:end)/1000,maxLoc1(4:end)/1000-maxLoc2(1:end-4)/250-delay,'poly1') % 0.00309/323.6246
    elseif subIdx==4
        fit(maxLoc1(8:end)/1000,maxLoc1(8:end)/1000-maxLoc2(1:end-8)/250-delay,'poly1') % 0.002905/344.2341
    end
elseif sID==6
    if subIdx==1
%         fit(maxLoc1/1000,maxLoc1/1000-maxLoc2/250-delay,'poly1') % 0.002119/471.9207
        % [sum(BioDiff)-sum(SumDiff),(sum(BioDiff)-sum(SumDiff))/length(BioDiff)] % =[28.25,0.3576]
    elseif subIdx==2
        % fit(maxLoc1(2:end-16)/1000,maxLoc1(2:end-16)/1000-maxLoc2(1:end-16)/250-delay,'poly1') % 0.002604/384.0246
        % [sum(BioDiff(2:end-16))-sum(SumDiff(1:end-16)),(sum(BioDiff(2:end-16))-sum(SumDiff(1:end-16)))/length(BioDiff(2:end-16))] % =[39,0.4699]
    elseif subIdx==3
        % fit(maxLoc1(5:end)/1000,maxLoc1(5:end)/1000-maxLoc2(1:end-3)/250-delay,'poly1') % 0.002929/341.4135
        % [sum(BioDiff(5:end))-sum(SumDiff(1:end-3)),(sum(BioDiff(5:end))-sum(SumDiff(1:end-3)))/length(BioDiff(5:end))] % =[56.25,0.5984]
    elseif subIdx==4
        % fit(maxLoc1(8:end)/1000,maxLoc1(8:end)/1000-maxLoc2(1:end-7)/250-delay,'poly1')  % 0.003101/322.4766
        % [sum(BioDiff(8:end))-sum(SumDiff(1:end-7)),(sum(BioDiff(8:end))-sum(SumDiff(1:end-7)))/length(BioDiff(8:end))] % =[44.25,0.4972]
    end
end




clear all;close all;clc

% fileIndex = 4; subjectIndex = 8; fileName = '../../../Data2\wave_008-standing';
% fileIndex = 5; subjectIndex = 9; fileName = '../../../Data2\wave_009-standing';
% fileIndex = 6; subjectIndex = 10; fileName = '../../../Data2\wave_010-standing';
% fileIndex = 8; subjectIndex = 12; fileName = '../../../Data2\wave_012-standing';
% fileIndex = 9; subjectIndex = 13; fileName = '../../../Data2\wave_013-standing';
% fileIndex = 10; subjectIndex = 14; fileName = '../../../Data2\wave_014-standing';
% fileIndex = 15; subjectIndex = 19; fileName = '../../../Data2\wave_019-standing';
% fileIndex = 16; subjectIndex = 20; fileName = '../../../Data2\wave_020-standing';
% fileIndex = 17; subjectIndex = 21; fileName = '../../../Data2\wave_021-standing';
% fileIndex = 18; subjectIndex = 22; fileName = '../../../Data2\wave_022-standing';
% fileIndex = 20; subjectIndex = 24; fileName = '../../../Data2\wave_024-standing';
% fileIndex = 23; subjectIndex = 27; fileName = '../../../Data2\wave_027-standing';
% fileIndex = 24; subjectIndex = 28; fileName = '../../../Data2\wave_028-standing';
% fileIndex = 25; subjectIndex = 29; fileName = '../../../Data2\wave_029-standing';
% fileIndex = 26; subjectIndex = 30; fileName = '../../../Data2\wave_030-standing';
% fileIndex = 27; subjectIndex = 31; fileName = '../../../Data2\wave_031-standing';
% fileIndex = 28; subjectIndex = 33; fileName = '../../../Data2\wave_033-standing';
% fileIndex = 100; subjectIndex = 100; fileName = '../../../Data2\S25_RAW';
fileIndex = 101; subjectIndex = 101; fileName = '../../../Data2\S27_RAW';
load(['Subject' num2str(subjectIndex) 'Data'])
load ../mParams

validEventNum = mResults.Result.validEventNum;
PAT = mResults.Result.PAT;
PTT = mResults.Result.PTT;
IJInfo = mResults.Result.IJInfo;
eventList = mResults.Result.eventList;
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
%%

mPlots.Result.Parent=figure(100);maximize(gcf);set(gcf,'Color','w');
%%% Use third-party subplot function to control the margins
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.03], [0.06 0.06], [0.04 0.04]);
mAxes.Result.PPGfingerECGSP=subplot(5,8,1);mPlots.Result.PPGfingerECGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATfinger/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerECGDP=subplot(5,8,5);mPlots.Result.PPGfingerECGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATfinger/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearECGSP=subplot(5,8,2);mPlots.Result.PPGearECGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATear/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearECGDP=subplot(5,8,6);mPlots.Result.PPGearECGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATear/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeECGSP=subplot(5,8,3);mPlots.Result.PPGtoeECGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATtoe/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeECGDP=subplot(5,8,7);mPlots.Result.PPGtoeECGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATtoe/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetECGSP=subplot(5,8,4);mPlots.Result.PPGfeetECGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATfeet/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetECGDP=subplot(5,8,8);mPlots.Result.PPGfeetECGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PATfeet/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.PPGfingerICGSP=subplot(5,8,9);mPlots.Result.PPGfingerICGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfinger/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerICGDP=subplot(5,8,13);mPlots.Result.PPGfingerICGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfinger/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearICGSP=subplot(5,8,10);mPlots.Result.PPGearICGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTear/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearICGDP=subplot(5,8,14);mPlots.Result.PPGearICGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTear/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeICGSP=subplot(5,8,11);mPlots.Result.PPGtoeICGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTtoe/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeICGDP=subplot(5,8,15);mPlots.Result.PPGtoeICGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTtoe/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetICGSP=subplot(5,8,12);mPlots.Result.PPGfeetICGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfeet/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetICGDP=subplot(5,8,16);mPlots.Result.PPGfeetICGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfeet/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.PPGfingerBCGSP=subplot(5,8,17);mPlots.Result.PPGfingerBCGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfinger/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerBCGDP=subplot(5,8,21);mPlots.Result.PPGfingerBCGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfinger/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearBCGSP=subplot(5,8,18);mPlots.Result.PPGearBCGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTear/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearBCGDP=subplot(5,8,22);mPlots.Result.PPGearBCGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTear/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeBCGSP=subplot(5,8,19);mPlots.Result.PPGtoeBCGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTtoe/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeBCGDP=subplot(5,8,23);mPlots.Result.PPGtoeBCGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTtoe/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetBCGSP=subplot(5,8,20);mPlots.Result.PPGfeetBCGSP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfeet/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetBCGDP=subplot(5,8,24);mPlots.Result.PPGfeetBCGDP=plot(NaN,NaN,'bo');hold on;grid on;grid minor;xlabel('PTTfeet/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.IJSP=subplot(5,8,25);mPlots.Result.IJSP=plot(NaN,NaN,'bo');xlabel('I-J Interval [ms]');hold on;grid on;grid minor;ylabel('SP [mmHg]');
mPlots.Result.IJSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.IJDP=subplot(5,8,26);mPlots.Result.IJDP=plot(NaN,NaN,'bo');xlabel('I-J Interval [ms]');hold on;grid on;grid minor;ylabel('DP [mmHg]');
mPlots.Result.IJDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.PPGfingerEventSP=subplot(5,8,33);mPlots.Result.PPGfingerEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
mPlots.Result.PPGfingerEventICGSP=plot(NaN,NaN,'o-');
mPlots.Result.PPGfingerEventBCGSP=plot(NaN,NaN,'o-');
mAxes.Result.PPGfingerEventDP=subplot(5,8,37);mPlots.Result.PPGfingerEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
mPlots.Result.PPGfingerEventICGDP=plot(NaN,NaN,'o-');
mPlots.Result.PPGfingerEventBCGDP=plot(NaN,NaN,'o-');
mAxes.Result.PPGearEventSP=subplot(5,8,34);mPlots.Result.PPGearEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
mPlots.Result.PPGearEventICGSP=plot(NaN,NaN,'o-');
mPlots.Result.PPGearEventBCGSP=plot(NaN,NaN,'o-');
mAxes.Result.PPGearEventDP=subplot(5,8,38);mPlots.Result.PPGearEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
mPlots.Result.PPGearEventICGDP=plot(NaN,NaN,'o-');
mPlots.Result.PPGearEventBCGDP=plot(NaN,NaN,'o-');
mAxes.Result.PPGtoeEventSP=subplot(5,8,35);mPlots.Result.PPGtoeEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
mPlots.Result.PPGtoeEventICGSP=plot(NaN,NaN,'o-');
mPlots.Result.PPGtoeEventBCGSP=plot(NaN,NaN,'o-');
mAxes.Result.PPGtoeEventDP=subplot(5,8,39);mPlots.Result.PPGtoeEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
mPlots.Result.PPGtoeEventICGDP=plot(NaN,NaN,'o-');
mPlots.Result.PPGtoeEventBCGDP=plot(NaN,NaN,'o-');
mAxes.Result.PPGfeetEventSP=subplot(5,8,36);mPlots.Result.PPGfeetEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
mPlots.Result.PPGfeetEventICGSP=plot(NaN,NaN,'o-');
mPlots.Result.PPGfeetEventBCGSP=plot(NaN,NaN,'o-');
mAxes.Result.PPGfeetEventDP=subplot(5,8,40);mPlots.Result.PPGfeetEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
mPlots.Result.PPGfeetEventICGDP=plot(NaN,NaN,'o-');
mPlots.Result.PPGfeetEventBCGDP=plot(NaN,NaN,'o-');
%%% End placeholder plots for result page %%%


%%
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

%%
featureNames = {'PPGfingerECG','PPGfingerICG','PPGfingerBCG','PPGearECG','PPGearICG','PPGearBCG','PPGfeetECG','PPGfeetICG','PPGfeetBCG','PPGtoeECG','PPGtoeICG','PPGtoeBCG','IJ'};
for ii = 1:length(featureNames)
    featureName = featureNames{ii};
    for jj = 1:validEventNum
        mPlots.Analysis.(['Event' num2str(jj)]).([featureName 'SPTotal'])=plot(mAxes.Result.([featureName 'SP']),NaN,NaN,'.');
        mPlots.Analysis.(['Event' num2str(jj)]).([featureName 'DPTotal'])=plot(mAxes.Result.([featureName 'DP']),NaN,NaN,'.');
    end
end
%%

mPlots.Result.Controls=figure(110);maximize(gcf);set(gcf,'Color','w');
for ii = 1:validEventNum
    eventTag = ['Event' num2str(ii)];
    mControls.(eventTag).featurePanel = uipanel('Parent',mPlots.Result.Controls,'Title',[eventTag ':' eventList{ii}],'FontSize',12,...
        'Position',[0.1*(ii-1),0,0.1,1],'Tag',eventTag); % 0.5-0.5*(ceil(ii/5)-1)
    for kk = 1:length(featureNames)
        featureName = featureNames{kk};
        mControls.(eventTag).([featureName 'Box']) = uicontrol('Parent',mControls.(eventTag).featurePanel,'Style','checkbox','units','normalized','String',featureName,...
            'Position',[0.1,0.9-0.05*(kk-1),0.8,0.05],'FontSize',10,'Tag',featureName);
    end
    mControls.(eventTag).magnitudeSlider = uicontrol('Parent',mControls.(eventTag).featurePanel,'Style','slider','units','normalized','Position',[0.1,0.2,0.8,0.05],...
        'Min',0,'Max',1,'Value',1,'SliderStep',[0.0025 0.1]);
    mControls.(eventTag).timeSlider = uicontrol('Parent',mControls.(eventTag).featurePanel,'Style','slider','units','normalized','Position',[0.1,0.1,0.8,0.05],...
        'Min',0,'Max',1,'Value',1,'SliderStep',[0.0025 0.1]);
    mControls.(eventTag).timeText = uicontrol('Parent',mControls.(eventTag).featurePanel,'Style','text','units','normalized','Position',[0.1,0,0.3,0.05],'FontSize',10);
    for kk = 1:length(featureNames)
        featureName = featureNames{kk};
        set(mControls.(eventTag).([featureName 'Box']),'Callback',{@checkboxCallback,mPlots,mControls,mResults,ii,featureName});
    end
    mControls.(eventTag).magnitudeSliderListener = addlistener(mControls.(eventTag).magnitudeSlider,...
            'ContinuousValueChange',@(src,cbdata)magnitudeSliderCallback(src,cbdata,mPlots,mControls,mResults,featureNames));
    setappdata(mControls.(eventTag).featurePanel,'magnitudeSliderListener',mControls.(eventTag).magnitudeSliderListener);
    mControls.(eventTag).timeSliderListener = addlistener(mControls.(eventTag).timeSlider,...
            'ContinuousValueChange',@(src,cbdata)timeSliderCallback(src,cbdata,mPlots,mControls,mResults,featureNames));
    setappdata(mControls.(eventTag).featurePanel,'timeSliderListener',mControls.(eventTag).timeSliderListener);
    
end
%%


% [timeInfo]=calcTime(mResults,1,'PPGfingerECG');
% set(mPlots.Analysis.(['Event' num2str(1)]).PPGfingerECGSPTotal,'XData',timeInfo(:,3),'YData',timeInfo(:,1))
% set(mPlots.Analysis.(['Event' num2str(1)]).PPGfingerECGDPTotal,'XData',timeInfo(:,3),'YData',timeInfo(:,2))
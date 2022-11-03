clear all;close all;clc
addpath('../../export_fig')
% Main file!
%% Load constant variables and default parameters for each subject
load mParams

%% Load subject information from Excel file and raw data file 
% [~,~,subjectParamXLS] = xlsread('../../../Data2\subjectParamXLS');
% fileIndex = 100; subjectIndex = 100; fileName = '../../../Data2\S25_RAW';
fileIndex = 101; subjectIndex = 101; fileName = '../../../Data2\S27_RAW';
defaultParams = mParams.DefaultValue.(['Subject' num2str(subjectIndex)]);
customParams = copy(defaultParams);
InterventionName2Idx = mParams.Constant.InterventionName2Idx;

%% Load raw data file and variable assignment
dataRaw = load(fileName);
dataFile = dataRaw.Data;
eventListMod = dataRaw.Event_Name;
eventListMod = eventListMod([1:9,15]);
eventListOrig = eventListMod;
for ii = 1:length(eventListMod)
    eventName = eventListMod{ii};
    if strcmp(eventName(1),'R') == 1
        eventListMod{ii} = 'BL';
    elseif contains(eventName,'HRL') == 1
        eventListMod{ii} = 'PE';
    end
    data = dataFile.(['bio_1kHz_' eventListOrig{ii}]); % 1k Hz
%     data = dataFile.(['bio_' eventListOrig{ii}]); % 250 Hz
    ECG = data(:,1);
    BCG = -data(:,7);
    PPGfeet = rand(length(ECG),1)/1000;
    PPGtoe = rand(length(ECG),1)/1000;
    PPGear = rand(length(ECG),1)/1000;
    PPGfingerClip = data(:,15);
    BPNexfin = data(:,2);
    ICGdzdt = rand(length(ECG),1)/1000;
    % time=0:0.001:0.001*(length(data)-1);
    % totalLength=length(data);
    fs = mParams.Constant.fs; % sampling frequency
    
    %% Filter the signal
    [u,v]=butter(1,30/(fs/2));
    ECGFiltered=filtfilt(u,v,ECG);
    % ECG1Filtered=filtfilt(u,v,ECG1);
    [u,v]=butter(1,20/(fs/2));
    BPNexfinFiltered=filtfilt(u,v,BPNexfin);
    % ECG2Filtered=filtfilt(u,v,ECG2);
    [u,v]=butter(1,[0.5,10]/(fs/2));
    PPGearFiltered=filtfilt(u,v,PPGear);
    PPGtoeFiltered=filtfilt(u,v,PPGtoe);
    PPGfeetFiltered=filtfilt(u,v,PPGfeet);
    PPGfingerClipFiltered=filtfilt(u,v,PPGfingerClip);
    % PPGfingerWrapFiltered=filtfilt(u,v,PPGfingerWrap);
    BCGFiltered=filtfilt(u,v,BCG);
    [u,v]=butter(1,[0.5,20]/(fs/2));
    ICGdzdtFiltered=filtfilt(u,v,ICGdzdt);
    filtered.(eventListOrig{ii}).BP = BPNexfinFiltered;
    filtered.(eventListOrig{ii}).ECG = ECGFiltered;
    filtered.(eventListOrig{ii}).ICGdzdt = ICGdzdtFiltered;
    filtered.(eventListOrig{ii}).BCG = BCGFiltered;
    filtered.(eventListOrig{ii}).PPGfinger = PPGfingerClipFiltered;
    filtered.(eventListOrig{ii}).PPGear = PPGearFiltered;
    filtered.(eventListOrig{ii}).PPGfeet = PPGfeetFiltered;
    filtered.(eventListOrig{ii}).PPGtoe = PPGtoeFiltered;
end


%% Initialization
validEventNum = length(eventListMod);
for ii = 1:validEventNum
    mPlots.Analysis.(['Event',num2str(ii)]).Parent=figure(ii+1); % Pre-allocation of figure for each intervention
end

%%% Begin placeholder plots for result page %%%
%%% These plots will be updated later by handle when the analysis is complete
mPlots.Result.Parent=figure(100);maximize(gcf);set(gcf,'Color','w');
%%% Use third-party subplot function to control the margins
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.03], [0.06 0.06], [0.04 0.04]);
mAxes.Result.PPGfingerECGSP=subplot(5,8,1);mPlots.Result.PPGfingerECGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATfinger/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerECGDP=subplot(5,8,5);mPlots.Result.PPGfingerECGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATfinger/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearECGSP=subplot(5,8,2);mPlots.Result.PPGearECGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATear/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearECGDP=subplot(5,8,6);mPlots.Result.PPGearECGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATear/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeECGSP=subplot(5,8,3);mPlots.Result.PPGtoeECGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATtoe/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeECGDP=subplot(5,8,7);mPlots.Result.PPGtoeECGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATtoe/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetECGSP=subplot(5,8,4);mPlots.Result.PPGfeetECGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATfeet/ECG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetECGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetECGDP=subplot(5,8,8);mPlots.Result.PPGfeetECGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PATfeet/ECG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetECGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.PPGfingerICGSP=subplot(5,8,9);mPlots.Result.PPGfingerICGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfinger/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerICGDP=subplot(5,8,13);mPlots.Result.PPGfingerICGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfinger/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearICGSP=subplot(5,8,10);mPlots.Result.PPGearICGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTear/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearICGDP=subplot(5,8,14);mPlots.Result.PPGearICGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTear/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeICGSP=subplot(5,8,11);mPlots.Result.PPGtoeICGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTtoe/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeICGDP=subplot(5,8,15);mPlots.Result.PPGtoeICGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTtoe/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetICGSP=subplot(5,8,12);mPlots.Result.PPGfeetICGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfeet/ICG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetICGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetICGDP=subplot(5,8,16);mPlots.Result.PPGfeetICGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfeet/ICG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetICGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.PPGfingerBCGSP=subplot(5,8,17);mPlots.Result.PPGfingerBCGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfinger/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfingerBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfingerBCGDP=subplot(5,8,21);mPlots.Result.PPGfingerBCGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfinger/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfingerBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearBCGSP=subplot(5,8,18);mPlots.Result.PPGearBCGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTear/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGearBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGearBCGDP=subplot(5,8,22);mPlots.Result.PPGearBCGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTear/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGearBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeBCGSP=subplot(5,8,19);mPlots.Result.PPGtoeBCGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTtoe/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGtoeBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGtoeBCGDP=subplot(5,8,23);mPlots.Result.PPGtoeBCGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTtoe/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGtoeBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetBCGSP=subplot(5,8,20);mPlots.Result.PPGfeetBCGSP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfeet/BCG [ms]');ylabel('SP [mmHg]');
mPlots.Result.PPGfeetBCGSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.PPGfeetBCGDP=subplot(5,8,24);mPlots.Result.PPGfeetBCGDP=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('PTTfeet/BCG [ms]');ylabel('DP [mmHg]');
mPlots.Result.PPGfeetBCGDPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);

mAxes.Result.IJSP=subplot(5,8,25);mPlots.Result.IJSP=plot(NaN,NaN,'bo');xlabel('I-J Interval [ms]');grid on;grid minor;ylabel('SP [mmHg]');
mPlots.Result.IJSPText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
mAxes.Result.IJDP=subplot(5,8,26);mPlots.Result.IJDP=plot(NaN,NaN,'bo');xlabel('I-J Interval [ms]');grid on;grid minor;ylabel('DP [mmHg]');
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

%%% Adjustment Plot
mPlots.Adjust.Parent=figure(110);maximize(gcf);set(gcf,'Color','w');
mControls.Adjust.EventTabs = uitabgroup('Parent',mPlots.Adjust.Parent);
SlidingWindowSize = mParams.Constant.SlidingWindowSize;
subplot = @(m,n,p) subtightplot (m, n, p, 0.04, 0.06, [0.05 0.25]);
for ii = 1:validEventNum
%     eventNames = getappdata(mPlots.Result.Parent,'eventList');
    mControls.Adjust.(['Event' num2str(ii) 'Tab']) = uitab('Parent',mControls.Adjust.EventTabs,'Title',['Event' num2str(ii) ': ']);
    mAxes.Adjust.(['Event' num2str(ii) 'Parent'])=axes('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']));
    mAxes.Adjust.(['Event' num2str(ii) 'Sub']) = subplot(6,1,1);
%     BPMinLoc = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMinLoc');
%     BPMin = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMin');
    mPlots.Adjust.(['Event' num2str(ii) 'Plot'])=plot(NaN,NaN,'bo-');grid on;grid minor;hold on;
    mPlots.Adjust.(['Event' num2str(ii) 'CurrentWindow'])=plot(NaN,NaN,'ro');
    mControls.Adjust.(['Event' num2str(ii)]).BCGSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
        'position',[0.05,0.75,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','BCGSlider');
    mControls.Adjust.(['Event' num2str(ii)]).BCGSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
        'position',[0.35,0.75,0.03,0.03],'String','0','FontSize',10);
    mControls.Adjust.(['Event' num2str(ii)]).BCGReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'BCG'},'FontSize',10,'units','normalized',...
        'Position',[0.385,0.75,0.04,0.03],'Tag','BCGPopup');
    mControls.Adjust.(['Event' num2str(ii)]).PPGfingerSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
        'position',[0.05,0.70,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGfingerSlider');
    mControls.Adjust.(['Event' num2str(ii)]).PPGfingerSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
        'position',[0.35,0.70,0.03,0.03],'String','0','FontSize',10);
    mControls.Adjust.(['Event' num2str(ii)]).PPGfingerReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
        'Position',[0.385,0.70,0.04,0.03],'Tag','PPGfingerPopup');
    mControls.Adjust.(['Event' num2str(ii)]).PPGearSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
        'position',[0.05,0.65,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGearSlider');
    mControls.Adjust.(['Event' num2str(ii)]).PPGearSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
        'position',[0.35,0.65,0.03,0.03],'String','0','FontSize',10);
    mControls.Adjust.(['Event' num2str(ii)]).PPGearReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
        'Position',[0.385,0.65,0.04,0.03],'Tag','PPGearPopup');
    mControls.Adjust.(['Event' num2str(ii)]).PPGfeetSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
        'position',[0.05,0.60,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGfeetSlider');
    mControls.Adjust.(['Event' num2str(ii)]).PPGfeetSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
        'position',[0.35,0.60,0.03,0.03],'String','0','FontSize',10);
    mControls.Adjust.(['Event' num2str(ii)]).PPGfeetReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
        'Position',[0.385,0.60,0.04,0.03],'Tag','PPGfeetPopup');
    mControls.Adjust.(['Event' num2str(ii)]).PPGtoeSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
        'position',[0.05,0.55,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGtoeSlider');
    mControls.Adjust.(['Event' num2str(ii)]).PPGtoeSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
        'position',[0.35,0.55,0.03,0.03],'String','0','FontSize',10);
    mControls.Adjust.(['Event' num2str(ii)]).PPGtoeReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
        'Position',[0.385,0.55,0.04,0.03],'Tag','PPGtoePopup');
end

%%% Initialiation of PTT/PAT variable
PAT.('PPGfingerECG').data=zeros(validEventNum,7);PAT.('PPGearECG').data=zeros(validEventNum,7);PAT.('PPGtoeECG').data=zeros(validEventNum,7);PAT.('PPGfeetECG').data=zeros(validEventNum,7);
PTT.('PPGfingerICG').data=zeros(validEventNum,7);PTT.('PPGearICG').data=zeros(validEventNum,7);PTT.('PPGtoeICG').data=zeros(validEventNum,7);PTT.('PPGfeetICG').data=zeros(validEventNum,7);
PTT.('PPGfingerBCG').data=zeros(validEventNum,7);PTT.('PPGearBCG').data=zeros(validEventNum,7);PTT.('PPGtoeBCG').data=zeros(validEventNum,7);PTT.('PPGfeetBCG').data=zeros(validEventNum,7);
PAT.('PPGfingerECG').BPInfo=zeros(2*validEventNum,6);PAT.('PPGearECG').BPInfo=zeros(2*validEventNum,6);PAT.('PPGtoeECG').BPInfo=zeros(2*validEventNum,6);PAT.('PPGfeetECG').BPInfo=zeros(2*validEventNum,6);
PTT.('PPGfingerICG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGearICG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGtoeICG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGfeetICG').BPInfo=zeros(2*validEventNum,6);
PTT.('PPGfingerBCG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGearBCG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGtoeBCG').BPInfo=zeros(2*validEventNum,6);PTT.('PPGfeetBCG').BPInfo=zeros(2*validEventNum,6);
IJInfo.data=zeros(validEventNum,7);IJInfo.BPInfo=zeros(2*validEventNum,6);

%%% Store the important variables in figure application data so that
%%% update to any of them in any subfunction will be synchronized
setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'IJInfo',IJInfo)
eventList={};
setappdata(mPlots.Result.Parent,'eventList',eventList)

setappdata(mPlots.Result.Parent,'validEventNum',validEventNum)
setappdata(mPlots.Result.Parent,'subjectIndex',subjectIndex)
setappdata(mPlots.Result.Parent,'skipCalculation',0)
setappdata(mPlots.Result.Parent,'skipFeature',0)



%% Looping over all listed interventions in the Excel file
validEventIdx=1;figIdx=2;timeCounter = 0;
% eventIdx=1;
for eventIdx = 1:validEventNum %while ~isnan(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4}) %eventIdx<=4 %
    name = ['event' num2str(eventIdx)];
    eventTag = ['Event' num2str(validEventIdx)];
%     eventData.(name).eventName = subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4};
    eventData.(name).startTime = (timeCounter+1-1)/fs;
    eventData.(name).endTime = (timeCounter+1+length(filtered.(eventListOrig{eventIdx}).BP)-1-1)/fs;
    timeCounter = timeCounter+length(filtered.(eventListOrig{eventIdx}).BP);
    eventData.(name).note = 'Y';
    interventionName = eventListMod{eventIdx}; interventionIdx = InterventionName2Idx(interventionName);
    %%% Each valid intervention will generate a figure
    if eventData.(name).note == 'Y'
        eventList = getappdata(mPlots.Result.Parent,'eventList');
        eventList = horzcat(eventList,interventionName);
        setappdata(mPlots.Result.Parent,'eventList',eventList) % save the updated eventList in the *Result* figure
        startTime = eventData.(name).startTime;
        endTime = eventData.(name).endTime;
        timesig = (startTime:1/fs:endTime);
        dataRange = startTime*fs:endTime*fs;
        startIdx = dataRange(1);
        ECGsig = filtered.(eventListOrig{eventIdx}).ECG;
        BPsig = filtered.(eventListOrig{eventIdx}).BP;
        ICGdzdtsig = filtered.(eventListOrig{eventIdx}).ICGdzdt;
        BCGsig = filtered.(eventListOrig{eventIdx}).BCG;
        BCGCopysig = filtered.(eventListOrig{eventIdx}).BCG;
        PPGfingersig = filtered.(eventListOrig{eventIdx}).PPGfinger;
        PPGearsig = filtered.(eventListOrig{eventIdx}).BCG;%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        PPGfeetsig = filtered.(eventListOrig{eventIdx}).PPGfeet;
        PPGtoesig = filtered.(eventListOrig{eventIdx}).PPGtoe;
%         figure(500);[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(-ECGsig,1000,1)
        
%         mPlots.Analysis.(eventTag).Parent=figure(validEventIdx+1);maximize(gcf);set(gcf,'Color','w')
        %%% Save signals and local info in application data of each figure
        figure(validEventIdx+1);maximize(gcf);set(gcf,'Color','w')
        setappdata(mPlots.Analysis.(eventTag).Parent,'timesig',timesig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGsig',ECGsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPsig',BPsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtsig',ICGdzdtsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig',BCGsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGCopysig',BCGCopysig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingersig',PPGfingersig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGearsig',PPGearsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetsig',PPGfeetsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoesig',PPGtoesig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'customParams',customParams)
        setappdata(mPlots.Analysis.(eventTag).Parent,'defaultParams',defaultParams)
        setappdata(mPlots.Analysis.(eventTag).Parent,'startIdx',startIdx)
        setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx',1)
        setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx',length(BPsig))
        setappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed',0)
        setappdata(mPlots.Analysis.(eventTag).Parent,'interventionName',interventionName)
        setappdata(mPlots.Analysis.(eventTag).Parent,'interventionIdx',interventionIdx)
        setappdata(mPlots.Analysis.(eventTag).Parent,'validEventIdx',validEventIdx)
        setappdata(mPlots.Analysis.(eventTag).Parent,'eventIdx',eventIdx)
        setappdata(mPlots.Analysis.(eventTag).Parent,'interventionLength',length(timesig))
        setappdata(mPlots.Analysis.(eventTag).Parent,'eventName',interventionName)
        setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowSource','BCG')
        setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowReference','BCG')
        setappdata(mPlots.Analysis.(eventTag).Parent,'initialRun',1)
        
        
        subplot = @(m,n,p) subtightplot (m, n, p, 0.04, 0.06, [0.05 0.25]);
        mAxes.Analysis.(eventTag).BP=subplot(8,1,1);mPlots.Analysis.(eventTag).BP=plot(timesig,BPsig,'b');hold on;grid on;grid minor;ylabel('BP');
        title(['eventIdx = ' num2str(eventIdx) ', validEventIdx = ' num2str(validEventIdx) ', name = ' interventionName])
        mAxes.Analysis.(eventTag).ECG=subplot(8,1,2);mPlots.Analysis.(eventTag).ECG=plot(timesig,ECGsig,'b');hold on;grid on;grid minor;ylabel('ECG');
        mAxes.Analysis.(eventTag).ICGdzdt=subplot(8,1,3);mPlots.Analysis.(eventTag).ICGdzdt=plot(timesig,ICGdzdtsig,'b');hold on;grid on;grid minor;ylabel('ICGdzdt');
        mAxes.Analysis.(eventTag).BCG=subplot(8,1,4);mPlots.Analysis.(eventTag).BCG=plot(timesig,BCGsig,'b');hold on;grid on;grid minor;ylabel('BCG');
        mAxes.Analysis.(eventTag).PPGfinger=subplot(8,1,5);mPlots.Analysis.(eventTag).PPGfinger=plot(timesig,PPGfingersig,'b');hold on;grid on;grid minor;ylabel('PPGfinger');
        mAxes.Analysis.(eventTag).PPGear=subplot(8,1,6);mPlots.Analysis.(eventTag).PPGear=plot(timesig,PPGearsig,'b');hold on;grid on;grid minor;ylabel('PPGear');
        mAxes.Analysis.(eventTag).PPGfeet=subplot(8,1,7);mPlots.Analysis.(eventTag).PPGfeet=plot(timesig,PPGfeetsig,'b');hold on;grid on;grid minor;ylabel('PPGfeet');
        mAxes.Analysis.(eventTag).PPGtoe=subplot(8,1,8);mPlots.Analysis.(eventTag).PPGtoe=plot(timesig,PPGtoesig,'b');hold on;grid on;grid minor;ylabel('PPGtoe');
        
        
        %%% Place holder for candidate features
        mPlots.Analysis.(eventTag).Features.BPMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BP);
        mPlots.Analysis.(eventTag).Features.BPMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BP);
        mPlots.Analysis.(eventTag).Features.ECGMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).ECG);
        mPlots.Analysis.(eventTag).Features.ICGdzdtMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).ICGdzdt);
        mPlots.Analysis.(eventTag).Features.ICGdzdtBPoint=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).ICGdzdt);
        mPlots.Analysis.(eventTag).Features.BCGMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCG);
        mPlots.Analysis.(eventTag).Features.BCGMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCG);
        mPlots.Analysis.(eventTag).Features.PPGfingerMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfinger);
        mPlots.Analysis.(eventTag).Features.PPGfingerMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfinger);
        mPlots.Analysis.(eventTag).Features.PPGfingerFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfinger);
        mPlots.Analysis.(eventTag).Features.PPGearMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGear);
        mPlots.Analysis.(eventTag).Features.PPGearMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGear);
        mPlots.Analysis.(eventTag).Features.PPGearFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGear);
        mPlots.Analysis.(eventTag).Features.PPGfeetMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfeet);
        mPlots.Analysis.(eventTag).Features.PPGfeetMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfeet);
        mPlots.Analysis.(eventTag).Features.PPGfeetFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGfeet);
        mPlots.Analysis.(eventTag).Features.PPGtoeMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGtoe);
        mPlots.Analysis.(eventTag).Features.PPGtoeMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGtoe);
        mPlots.Analysis.(eventTag).Features.PPGtoeFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGtoe);
        
        %% Start of Controls
        %%% Horizontal scroll slider and pan slider
        pos=get(mAxes.Analysis.(eventTag).PPGtoe,'position');
        hScrollSliderPos=[pos(1) pos(2)-0.08 0.3 0.05];
        mControls.Analysis.(eventTag).hScrollSlider=uicontrol('style','slider','units','normalized','position',hScrollSliderPos,'min',0,'max',1,'SliderStep',[0.0001 0.1],'Tag',eventTag);
        hPanSliderPos=[hScrollSliderPos(1)+hScrollSliderPos(3) pos(2)-0.08 0.3 0.05];
        mControls.Analysis.(eventTag).hPanSlider=uicontrol('style','slider','units','normalized','position',hPanSliderPos,'min',0,'max',1,'Value',1,'SliderStep',[0.0001 0.1],'Tag',eventTag);
        
        %%% Signal Panel
        ax1Pos = mAxes.Analysis.(eventTag).BP.Position;
        mControls.Analysis.(eventTag).SignalButtonGroup = uibuttongroup('Title','Signal','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02,ax1Pos(2)+ax1Pos(4)-0.2,0.04,0.2],'Tag',eventTag);
        sigBtnGroupPos = mControls.Analysis.(eventTag).SignalButtonGroup.Position;
        mControls.Analysis.(eventTag).SelectNone = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
            'Position',[0.1,0.85,0.8,0.1],'BackgroundColor','g');
        mControls.Analysis.(eventTag).SelectBP = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BP','FontSize',9,'units','normalized',...
            'Position',[0.1,0.75,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectECG = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','ECG','FontSize',9,'units','normalized',...
            'Position',[0.1,0.65,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectICGdzdt = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','ICGdzdt','FontSize',9,'units','normalized',...
            'Position',[0.1,0.55,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectBCG = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BCG','FontSize',9,'units','normalized',...
            'Position',[0.1,0.45,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGfinger = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGfinger','FontSize',9,'units','normalized',...
            'Position',[0.1,0.35,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGear = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGear','FontSize',9,'units','normalized',...
            'Position',[0.1,0.25,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGfeet = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGfeet','FontSize',9,'units','normalized',...
            'Position',[0.1,0.15,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGtoe = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGtoe','FontSize',9,'units','normalized',...
            'Position',[0.1,0.05,0.8,0.1]);
        
        %%% Feature Panel
        mControls.Analysis.(eventTag).FeatureButtonGroup = uibuttongroup('Title','Feature','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k','SelectedObject',[],...
            'Position',[sigBtnGroupPos(1)+sigBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.10,0.04,0.10],'Tag',eventTag);
        featureBtnGroupPos = mControls.Analysis.(eventTag).FeatureButtonGroup.Position;
        mControls.Analysis.(eventTag).FeatureNone = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
            'Position',[0.1,0.75,0.8,0.25],'BackgroundColor','g');
        mControls.Analysis.(eventTag).Peak = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Peak','FontSize',9,'units','normalized',...
            'Position',[0.1,0.50,0.8,0.25],'Enable','off');
        mControls.Analysis.(eventTag).Trough = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Trough','FontSize',9,'units','normalized',...
            'Position',[0.1,0.25,0.8,0.25],'Enable','off');
        mControls.Analysis.(eventTag).Foot = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Foot','FontSize',9,'units','normalized',...
            'Position',[0.1,0.00,0.8,0.25],'Enable','off');
        
        %%% Mode Panel
        mControls.Analysis.(eventTag).ModeButtonGroup = uibuttongroup('Title','Mode','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[sigBtnGroupPos(1)+sigBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.20,0.04,0.10],'Tag',eventTag);
        mControls.Analysis.(eventTag).ModeNone = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
            'Position',[0.1,0.75,0.8,0.25],'BackgroundColor','g');
        mControls.Analysis.(eventTag).Remove = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Remove','FontSize',9,'units','normalized',...
            'Position',[0.1,0.50,0.8,0.25],'Enable','off');
        mControls.Analysis.(eventTag).Update = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Update','FontSize',9,'units','normalized',...
            'Position',[0.1,0.25,0.8,0.25],'Enable','off');
        mControls.Analysis.(eventTag).Move = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Move','FontSize',9,'units','normalized',...
            'Position',[0.1,0.00,0.8,0.25],'Enable','off');
        
        %%% Action Panel
        mControls.Analysis.(eventTag).ActionPanel = uipanel('Title','Action','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[featureBtnGroupPos(1)+featureBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.10,0.1,0.10],'Tag',eventTag);
        mControls.Analysis.(eventTag).RemoveFeature = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Remove Features On Screen',...
            'FontSize',9,'units','normalized','Position',[0.05,0.75,0.9,0.25]);
        mControls.Analysis.(eventTag).UpdateFeature = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Update Features On Screen',...
            'FontSize',9,'units','normalized','Position',[0.05,0.50,0.9,0.25]);
        mControls.Analysis.(eventTag).GoToIJWindow = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Go To I-J Window',...
            'FontSize',9,'units','normalized','Position',[0.05,0.25,0.9,0.25]);
        mControls.Analysis.(eventTag).GoToFeatureWindow = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Go To Feature Window','FontSize',9,...
            'units','normalized','Position',[0.05,0.00,0.9,0.25]);
        
        %%% Data Save/Load Panel
        mControls.Analysis.(eventTag).DataPanel = uipanel('Title','Data','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[featureBtnGroupPos(1)+featureBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.20,0.1,0.10],'Tag',eventTag);
        mControls.Analysis.(eventTag).LoadData = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Load Data',...
            'FontSize',9,'units','normalized','Position',[0.05,0.75,0.9,0.25]);
        mControls.Analysis.(eventTag).SaveData = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Save Data',...
            'FontSize',9,'units','normalized','Position',[0.05,0.50,0.9,0.25]);
%         mControls.Analysis.(eventTag).ConfirmFeature = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Confirm Features On Screen',...
%             'FontSize',9,'units','normalized','Position',[0.05,0.25,0.9,0.25]);
%         mControls.Analysis.(eventTag).GoToWindow = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Go To Window','FontSize',9,...
%             'units','normalized','Position',[0.05,0.00,0.9,0.25]);
        
        %%% Parameter Tab
        BCGAxeLoc = mAxes.Analysis.(eventTag).BCG.Position;
        mControls.Analysis.(eventTag).ParameterTabs = uitabgroup('Parent',mPlots.Analysis.(eventTag).Parent,'units','normalized',...
            'Position',[BCGAxeLoc(1)+BCGAxeLoc(3)+0.02,BCGAxeLoc(2)+BCGAxeLoc(4)-0.3,0.22,0.3],'Tag',eventTag);
        signalNames={'BP','ECG','ICGdzdt','BCG','PPGfinger','PPGear','PPGfeet','PPGtoe'};
        %%% One uipanel for each signal
        for ii = 1:length(signalNames)
            signalName = signalNames{ii};
            mControls.Analysis.(eventTag).([signalName 'Tab']) = uitab('Parent',mControls.Analysis.(eventTag).ParameterTabs,'Title',signalName,'Tag',eventTag);
            mControls.Analysis.(eventTag).([signalName 'ParameterPanel']) = uipanel(mControls.Analysis.(eventTag).([signalName 'Tab']),'Title','Parameters','Position',[0,0,0.54,1],'FontSize',10);
            mControls.Analysis.(eventTag).([signalName 'DefaultPanel']) = uipanel(mControls.Analysis.(eventTag).([signalName 'Tab']),'Title','Default','Position',[0.54,0,0.23,1],'FontSize',10);
            mControls.Analysis.(eventTag).([signalName 'CustomPanel']) = uipanel(mControls.Analysis.(eventTag).([signalName 'Tab']),'Title','Custom','Position',[0.77,0,0.23,1],'FontSize',10);
            allKeys = keys(defaultParams);
            if strcmp(signalName,'BP') == 1
                signalParams = sort(allKeys(contains(allKeys,signalName) & ~contains(allKeys,'BPMin2ECGMax')));
            elseif strcmp(signalName,'ECG') == 1
                signalParams = sort(allKeys(contains(allKeys,signalName) & ~contains(allKeys,{'finger','ear','feet','toe','ECGMax2BCGMax','ECGMax2ICGdzdtMax'})));
            else
                signalParams = sort(allKeys(contains(allKeys,signalName)));
            end
            defaultParams = getappdata(mPlots.Analysis.(eventTag).Parent,'defaultParams');
            customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
            for jj = 1:length(signalParams)
                signalParam = signalParams{jj};
                mControls.Analysis.(eventTag).([signalParam 'Text']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'ParameterPanel']),'Style','text','String',signalParam,...
                    'units','normalized','Position',[0.01,0.9-0.1*jj,0.9,0.1],'HorizontalAlignment','left','FontSize',9);
                mControls.Analysis.(eventTag).([signalParam 'DefaultText']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'DefaultPanel']),'Style','text','Tag',signalParam,...
                    'String',num2str(defaultParams(signalParam)),'units','normalized','Position',[0.05,0.9-0.1*jj,0.9,0.1],...
                    'HorizontalAlignment','center','FontSize',9);
                mControls.Analysis.(eventTag).([signalParam 'CustomEdit']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'CustomPanel']),'Style','edit','Tag',signalParam,...
                    'String',num2str(customParams(signalParam)),'units','normalized','Position',[0.05,0.92-0.1*jj,0.9,0.09],...
                    'HorizontalAlignment','center','FontSize',9,'Callback',{@customParamEditCallback,mPlots});
            end
        end
        
        %%% Select reference signal (for use of displaying PTT/PAT window)
        mControls.Analysis.(eventTag).ReferenceSignalPopup = uicontrol('style','popup','String',{'ECG','ICG','BCG'},'FontSize',9,'units','normalized',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02,ax1Pos(2)+ax1Pos(4)-0.2-0.03,0.04,0.02],'Tag',eventTag);
        
        %%% Defining callbacks/buttondown function/listeners for the
        %%% control components
        mControls.Analysis.(eventTag).hScrollSliderListener=addlistener(mControls.Analysis.(eventTag).hScrollSlider,...
            'ContinuousValueChange',@(src,cbdata)scrollbarCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Analysis.(eventTag).hScrollSlider,'hScrollSliderListener',mControls.Analysis.(eventTag).hScrollSliderListener);
        mControls.Analysis.(eventTag).hPanSliderListener=addlistener(mControls.Analysis.(eventTag).hPanSlider,...
            'ContinuousValueChange',@(src,cbdata)hPanCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Analysis.(eventTag).hPanSlider,'hPanSliderListener',mControls.Analysis.(eventTag).hPanSliderListener);
        
        mControls.Adjust.(eventTag).BCGSliderListener=addlistener(mControls.Adjust.(eventTag).BCGSlider,...
            'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Adjust.(eventTag).BCGSlider,'BCGSliderListener',mControls.Adjust.(eventTag).BCGSliderListener)
        mControls.Adjust.(eventTag).PPGfingerSliderListener=addlistener(mControls.Adjust.(eventTag).PPGfingerSlider,...
            'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Adjust.(eventTag).PPGfingerSlider,'PPGfingerSliderListener',mControls.Adjust.(eventTag).PPGfingerSliderListener)
        mControls.Adjust.(eventTag).PPGearSliderListener=addlistener(mControls.Adjust.(eventTag).PPGearSlider,...
            'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Adjust.(eventTag).PPGearSlider,'PPGearSliderListener',mControls.Adjust.(eventTag).PPGearSliderListener)
        mControls.Adjust.(eventTag).PPGfeetSliderListener=addlistener(mControls.Adjust.(eventTag).PPGfeetSlider,...
            'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Adjust.(eventTag).PPGfeetSlider,'PPGfeetSliderListener',mControls.Adjust.(eventTag).PPGfeetSliderListener)
        mControls.Adjust.(eventTag).PPGtoeSliderListener=addlistener(mControls.Adjust.(eventTag).PPGtoeSlider,...
            'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Adjust.(eventTag).PPGtoeSlider,'PPGtoeSliderListener',mControls.Adjust.(eventTag).PPGtoeSliderListener)
        
        set(mControls.Adjust.(eventTag).BCGReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        set(mControls.Adjust.(eventTag).PPGfingerReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        set(mControls.Adjust.(eventTag).PPGearReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        set(mControls.Adjust.(eventTag).PPGfeetReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        set(mControls.Adjust.(eventTag).PPGtoeReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        
        set(mControls.Analysis.(eventTag).SignalButtonGroup,'SelectionChangedFcn',{@selectSignalCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).FeatureButtonGroup,'SelectionChangedFcn',{@selectFeatureCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).ModeButtonGroup,'SelectionChangedFcn',{@selectModeCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).RemoveFeature,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).UpdateFeature,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).GoToIJWindow,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).GoToFeatureWindow,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).LoadData,'Callback',{@dataCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).SaveData,'Callback',{@dataCallback,mAxes,mPlots,mControls,mParams})
        
        %% Start of main analysis procedures
        %%% The entryCode is used to tell analyze() to start from which
        %%% part
        customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
        entryCode = 0;
        setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
        setappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete',[])
        analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
        
        validEventIdx = validEventIdx+1;
        figIdx = figIdx+1;
    end
    eventIdx = eventIdx+1;
end


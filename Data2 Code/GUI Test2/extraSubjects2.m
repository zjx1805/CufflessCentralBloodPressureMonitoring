clear all;close all;clc
addpath('.\export_fig')
% Main file!
%% Load constant variables and default parameters for each subject
load mParams

%% Load subject information from Excel file and raw data file 
% [~,~,subjectParamXLS] = xlsread('../../../Data2\subjectParamXLS');
fileIndex = 100; subjectIndex = 100; fileName = '../../../Data2\S25_RAW';
% fileIndex = 101; subjectIndex = 101; fileName = '../../../Data2\S27_RAW';
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
    dataBio = dataFile.(['bio_1kHz_' eventListOrig{ii}]); 
    dataSAM = dataFile.(['sam_1kHz_' eventListOrig{ii}]); 
    ECG = dataBio(:,1);
    BCGScale = -dataBio(:,7);
    BCGArm = dataBio(:,10);
    BCGWrist = -dataBio(:,12);
    BCGNeck = rand(length(ECG),1)/1000;
    PPGIR = -dataSAM(:,2);
    PPGGreen = -dataSAM(:,2);
    PPGClip = dataBio(:,15);
    BPNexfin = dataBio(:,2);
    % time=0:0.001:0.001*(length(data)-1);
    % totalLength=length(data);
    fs = mParams.Constant.fs; % sampling frequency
    fs_IR = mParams.Constant.fs_IR;
    
    %% Filter the signal
    [u,v]=butter(1,30/(fs/2));
    ECGFiltered=filtfilt(u,v,ECG);

    [u,v]=butter(1,20/(fs/2));
    BPNexfinFiltered=filtfilt(u,v,BPNexfin);

    [u,v]=butter(1,[0.5,10]/(fs/2));
    PPGClipFiltered=filtfilt(u,v,PPGClip);
    BCGScaleFiltered=filtfilt(u,v,BCGScale);
    BCGArmFiltered=filtfilt(u,v,BCGArm);
    BCGWristFiltered=filtfilt(u,v,BCGWrist);
    BCGNeckFiltered=filtfilt(u,v,BCGNeck);
    
    [u,v]=butter(1,[0.5,10]/(fs/2));
    tempLoc = find(~isnan(PPGIR),1); temp = PPGIR(tempLoc:4:end); temp(isnan(temp)) = 0;
    PPGIRFiltered = interp(temp(~isnan(temp)),4);
    PPGIRFiltered = PPGIRFiltered(1:length(BPNexfinFiltered));
    PPGIRFiltered = filtfilt(u,v,PPGIRFiltered);
    tempLoc = find(~isnan(PPGGreen),1); temp = PPGGreen(tempLoc:4:end); temp(isnan(temp)) = 0;
    PPGGreenFiltered = interp(temp(~isnan(temp)),4);
    PPGGreenFiltered = PPGGreenFiltered(1:length(BPNexfinFiltered));
    PPGGreenFiltered = filtfilt(u,v,PPGGreenFiltered);
%     PPGIRFiltered=filtfilt(u,v,PPGIR(~isnan(PPGIR)));
%     PPGGreenFiltered=filtfilt(u,v,PPGGreen(~isnan(PPGGreen)));
%     temp=PPGIR; temp(~isnan(temp))=PPGIRFiltered; %PPGIRFiltered=temp;
%     temp=PPGGreen; temp(~isnan(temp))=PPGGreenFiltered; PPGGreenFiltered=temp;
    
    filtered.(eventListOrig{ii}).BP = BPNexfinFiltered;
    filtered.(eventListOrig{ii}).ECG = ECGFiltered;
    filtered.(eventListOrig{ii}).BCGScale = BCGScaleFiltered;
    filtered.(eventListOrig{ii}).BCGArm = BCGArmFiltered;
    filtered.(eventListOrig{ii}).BCGWrist = BCGWristFiltered;
    filtered.(eventListOrig{ii}).BCGNeck = BCGNeckFiltered;
    filtered.(eventListOrig{ii}).PPGClip = PPGClipFiltered;
    filtered.(eventListOrig{ii}).PPGIR = PPGIRFiltered;
    filtered.(eventListOrig{ii}).PPGGreen = PPGGreenFiltered;
end


%% Initialization
validEventNum = length(eventListMod);
for ii = 1:validEventNum
    mPlots.Analysis.(['Event',num2str(ii)]).Parent=figure(ii); % Pre-allocation of figure for each intervention
end

%%% Begin placeholder plots for result page %%%
%%% These plots will be updated later by handle when the analysis is complete
mPlots.Result.Parent=figure(100);maximize(gcf);set(gcf,'Color','w');
mPlots.Result.Tabs = uitabgroup('Parent',mPlots.Result.Parent);
%%% Use third-party subplot function to control the margins
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.03], [0.06 0.06], [0.04 0.04]);
BPNames = {'DP','PP'};
for ii = 1:length(BPNames)
    BPName = BPNames{ii};
    mPlots.Result.(BPName).Parent = uitab('Parent',mPlots.Result.Tabs,'Title',BPName,'BackgroundColor','w');
    mAxes.Result.(BPName).Parent=axes('Parent',mPlots.Result.(BPName).Parent);
    
    mAxes.Result.(BPName).BCGScaleIJInt=subplot(5,8,1);mPlots.Result.(BPName).BCGScaleIJInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Interval/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleIJIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristIJInt=subplot(5,8,2);mPlots.Result.(BPName).BCGWristIJInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Interval/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristIJIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmIJInt=subplot(5,8,3);mPlots.Result.(BPName).BCGArmIJInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Interval/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmIJIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckIJInt=subplot(5,8,4);mPlots.Result.(BPName).BCGNeckIJInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Interval/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckIJIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGScaleIJAmp=subplot(5,8,5);mPlots.Result.(BPName).BCGScaleIJAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Amplitude/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleIJAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristIJAmp=subplot(5,8,6);mPlots.Result.(BPName).BCGWristIJAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Amplitude/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristIJAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmIJAmp=subplot(5,8,7);mPlots.Result.(BPName).BCGArmIJAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Amplitude/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmIJAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckIJAmp=subplot(5,8,8);mPlots.Result.(BPName).BCGNeckIJAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-J Amplitude/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckIJAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    
    mAxes.Result.(BPName).BCGScaleJKInt=subplot(5,8,9);mPlots.Result.(BPName).BCGScaleJKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Interval/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleJKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristJKInt=subplot(5,8,10);mPlots.Result.(BPName).BCGWristJKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Interval/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristJKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmJKInt=subplot(5,8,11);mPlots.Result.(BPName).BCGArmJKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Interval/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmJKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckJKInt=subplot(5,8,12);mPlots.Result.(BPName).BCGNeckJKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Interval/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckJKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGScaleJKAmp=subplot(5,8,13);mPlots.Result.(BPName).BCGScaleJKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Amplitude/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleJKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristJKAmp=subplot(5,8,14);mPlots.Result.(BPName).BCGWristJKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Amplitude/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristJKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmJKAmp=subplot(5,8,15);mPlots.Result.(BPName).BCGArmJKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Amplitude/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmJKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckJKAmp=subplot(5,8,16);mPlots.Result.(BPName).BCGNeckJKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('J-K Amplitude/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckJKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    
    mAxes.Result.(BPName).BCGScaleIKInt=subplot(5,8,17);mPlots.Result.(BPName).BCGScaleIKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Interval/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleIKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristIKInt=subplot(5,8,18);mPlots.Result.(BPName).BCGWristIKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Interval/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristIKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmIKInt=subplot(5,8,19);mPlots.Result.(BPName).BCGArmIKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Interval/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmIKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckIKInt=subplot(5,8,20);mPlots.Result.(BPName).BCGNeckIKInt=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Interval/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckIKIntText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGScaleIKAmp=subplot(5,8,21);mPlots.Result.(BPName).BCGScaleIKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Amplitude/Scale [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScaleIKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristIKAmp=subplot(5,8,22);mPlots.Result.(BPName).BCGWristIKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Amplitude/Wrist [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristIKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmIKAmp=subplot(5,8,23);mPlots.Result.(BPName).BCGArmIKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Amplitude/Arm [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmIKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckIKAmp=subplot(5,8,24);mPlots.Result.(BPName).BCGNeckIKAmp=plot(NaN,NaN,'bo');grid on;grid minor;xlabel('I-K Amplitude/Neck [ms]');ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckIKAmpText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    
    mAxes.Result.(BPName).BCGScalePTT=subplot(5,8,25);mPlots.Result.(BPName).BCGScalePTT=plot(NaN,NaN,'bo');xlabel('PTT/Scale [ms]');grid on;grid minor;ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGScalePTTText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGWristPTT=subplot(5,8,26);mPlots.Result.(BPName).BCGWristPTT=plot(NaN,NaN,'bo');xlabel('PTT/Wrist [ms]');grid on;grid minor;ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGWristPTTText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGArmPTT=subplot(5,8,27);mPlots.Result.(BPName).BCGArmPTT=plot(NaN,NaN,'bo');xlabel('PTT/Arm [ms]');grid on;grid minor;ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGArmPTTText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    mAxes.Result.(BPName).BCGNeckPTT=subplot(5,8,28);mPlots.Result.(BPName).BCGNeckPTT=plot(NaN,NaN,'bo');xlabel('PTT/Neck [ms]');grid on;grid minor;ylabel([BPName ' [mmHg]']);
    mPlots.Result.(BPName).BCGNeckPTTText=text(NaN(validEventNum,1),NaN(validEventNum,1),'','fontsize',7);
    %
    % mAxes.Result.PPGfingerEventSP=subplot(5,8,33);mPlots.Result.PPGfingerEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
    % mPlots.Result.PPGfingerEventICGSP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGfingerEventBCGSP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGfingerEventDP=subplot(5,8,37);mPlots.Result.PPGfingerEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
    % mPlots.Result.PPGfingerEventICGDP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGfingerEventBCGDP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGearEventSP=subplot(5,8,34);mPlots.Result.PPGearEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
    % mPlots.Result.PPGearEventICGSP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGearEventBCGSP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGearEventDP=subplot(5,8,38);mPlots.Result.PPGearEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
    % mPlots.Result.PPGearEventICGDP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGearEventBCGDP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGtoeEventSP=subplot(5,8,35);mPlots.Result.PPGtoeEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
    % mPlots.Result.PPGtoeEventICGSP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGtoeEventBCGSP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGtoeEventDP=subplot(5,8,39);mPlots.Result.PPGtoeEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
    % mPlots.Result.PPGtoeEventICGDP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGtoeEventBCGDP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGfeetEventSP=subplot(5,8,36);mPlots.Result.PPGfeetEventECGSP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('SP [mmHg]')
    % mPlots.Result.PPGfeetEventICGSP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGfeetEventBCGSP=plot(NaN,NaN,'o-');
    % mAxes.Result.PPGfeetEventDP=subplot(5,8,40);mPlots.Result.PPGfeetEventECGDP=plot(NaN,NaN,'o-');hold on;grid on;grid minor;ylabel('DP [mmHg]')
    % mPlots.Result.PPGfeetEventICGDP=plot(NaN,NaN,'o-');
    % mPlots.Result.PPGfeetEventBCGDP=plot(NaN,NaN,'o-');
    %%% End placeholder plots for result page %%%
end

%%% Adjustment Plot
% mPlots.Adjust.Parent=figure(110);maximize(gcf);set(gcf,'Color','w');
% mControls.Adjust.EventTabs = uitabgroup('Parent',mPlots.Adjust.Parent);
% SlidingWindowSize = mParams.Constant.SlidingWindowSize;
% subplot = @(m,n,p) subtightplot (m, n, p, 0.04, 0.06, [0.05 0.25]);
% for ii = 1:validEventNum
% %     eventNames = getappdata(mPlots.Result.Parent,'eventList');
%     mControls.Adjust.(['Event' num2str(ii) 'Tab']) = uitab('Parent',mControls.Adjust.EventTabs,'Title',['Event' num2str(ii) ': ']);
%     mAxes.Adjust.(['Event' num2str(ii) 'Parent'])=axes('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']));
%     mAxes.Adjust.(['Event' num2str(ii) 'Sub']) = subplot(6,1,1);
% %     BPMinLoc = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMinLoc');
% %     BPMin = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMin');
%     mPlots.Adjust.(['Event' num2str(ii) 'Plot'])=plot(NaN,NaN,'bo-');grid on;grid minor;hold on;
%     mPlots.Adjust.(['Event' num2str(ii) 'CurrentWindow'])=plot(NaN,NaN,'ro');
%     mControls.Adjust.(['Event' num2str(ii)]).BCGSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.75,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','BCGSlider');
%     mControls.Adjust.(['Event' num2str(ii)]).BCGSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
%         'position',[0.35,0.75,0.03,0.03],'String','0','FontSize',10);
%     mControls.Adjust.(['Event' num2str(ii)]).BCGReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'BCG'},'FontSize',10,'units','normalized',...
%         'Position',[0.385,0.75,0.04,0.03],'Tag','BCGPopup');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfingerSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.70,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGfingerSlider');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfingerSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
%         'position',[0.35,0.70,0.03,0.03],'String','0','FontSize',10);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfingerReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
%         'Position',[0.385,0.70,0.04,0.03],'Tag','PPGfingerPopup');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGearSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.65,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGearSlider');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGearSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
%         'position',[0.35,0.65,0.03,0.03],'String','0','FontSize',10);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGearReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
%         'Position',[0.385,0.65,0.04,0.03],'Tag','PPGearPopup');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfeetSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.60,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGfeetSlider');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfeetSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
%         'position',[0.35,0.60,0.03,0.03],'String','0','FontSize',10);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfeetReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
%         'Position',[0.385,0.60,0.04,0.03],'Tag','PPGfeetPopup');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGtoeSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.55,0.3,0.03],'Min',0,'Max',1,'Value',0,'Tag','PPGtoeSlider');
%     mControls.Adjust.(['Event' num2str(ii)]).PPGtoeSliderText=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','edit','units','normalized',...
%         'position',[0.35,0.55,0.03,0.03],'String','0','FontSize',10);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGtoeReferenceSignalPopup = uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','popup','String',{'ECG','ICG','BCG'},'FontSize',10,'units','normalized',...
%         'Position',[0.385,0.55,0.04,0.03],'Tag','PPGtoePopup');
% end

%%% Initialiation of PTT/PAT variable
PAT.DP.('PPGClipECG').data=zeros(validEventNum,8);PAT.DP.('PPGIRECG').data=zeros(validEventNum,8);PAT.DP.('PPGGreenECG').data=zeros(validEventNum,8);
PTT.DP.('PPGClipBCGScale').data=zeros(validEventNum,8);PTT.DP.('PPGIRBCGScale').data=zeros(validEventNum,8);PTT.DP.('PPGGreenBCGScale').data=zeros(validEventNum,8);
PTT.DP.('PPGClipBCGWrist').data=zeros(validEventNum,8);PTT.DP.('PPGIRBCGWrist').data=zeros(validEventNum,8);PTT.DP.('PPGGreenBCGWrist').data=zeros(validEventNum,8);
PTT.DP.('PPGClipBCGArm').data=zeros(validEventNum,8);PTT.DP.('PPGIRBCGArm').data=zeros(validEventNum,8);PTT.DP.('PPGGreenBCGArm').data=zeros(validEventNum,8);
PTT.DP.('PPGClipBCGNeck').data=zeros(validEventNum,8);PTT.DP.('PPGIRBCGNeck').data=zeros(validEventNum,8);PTT.DP.('PPGGreenBCGNeck').data=zeros(validEventNum,8);
SIGS.IJ.DP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.IJ.DP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.IJ.DP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.IJ.DP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.IJ.DP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.IJ.DP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.IJ.DP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.IJ.DP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);
SIGS.JK.DP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.JK.DP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.JK.DP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.JK.DP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.JK.DP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.JK.DP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.JK.DP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.JK.DP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);
SIGS.IK.DP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.IK.DP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.IK.DP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.IK.DP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.IK.DP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.IK.DP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.IK.DP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.IK.DP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);

PAT.PP.('PPGClipECG').data=zeros(validEventNum,8);PAT.PP.('PPGIRECG').data=zeros(validEventNum,8);PAT.PP.('PPGGreenECG').data=zeros(validEventNum,8);
PTT.PP.('PPGClipBCGScale').data=zeros(validEventNum,8);PTT.PP.('PPGIRBCGScale').data=zeros(validEventNum,8);PTT.PP.('PPGGreenBCGScale').data=zeros(validEventNum,8);
PTT.PP.('PPGClipBCGWrist').data=zeros(validEventNum,8);PTT.PP.('PPGIRBCGWrist').data=zeros(validEventNum,8);PTT.PP.('PPGGreenBCGWrist').data=zeros(validEventNum,8);
PTT.PP.('PPGClipBCGArm').data=zeros(validEventNum,8);PTT.PP.('PPGIRBCGArm').data=zeros(validEventNum,8);PTT.PP.('PPGGreenBCGArm').data=zeros(validEventNum,8);
PTT.PP.('PPGClipBCGNeck').data=zeros(validEventNum,8);PTT.PP.('PPGIRBCGNeck').data=zeros(validEventNum,8);PTT.PP.('PPGGreenBCGNeck').data=zeros(validEventNum,8);
SIGS.IJ.PP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.IJ.PP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.IJ.PP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.IJ.PP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.IJ.PP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.IJ.PP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.IJ.PP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.IJ.PP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);
SIGS.JK.PP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.JK.PP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.JK.PP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.JK.PP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.JK.PP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.JK.PP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.JK.PP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.JK.PP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);
SIGS.IK.PP.('BCGScale').Interval.data=zeros(validEventNum,8);SIGS.IK.PP.('BCGWrist').Interval.data=zeros(validEventNum,8);
SIGS.IK.PP.('BCGArm').Interval.data=zeros(validEventNum,8);SIGS.IK.PP.('BCGNeck').Interval.data=zeros(validEventNum,8);
SIGS.IK.PP.('BCGScale').Amplitude.data=zeros(validEventNum,8);SIGS.IK.PP.('BCGWrist').Amplitude.data=zeros(validEventNum,8);
SIGS.IK.PP.('BCGArm').Amplitude.data=zeros(validEventNum,8);SIGS.IK.PP.('BCGNeck').Amplitude.data=zeros(validEventNum,8);

%%% Store the important variables in figure application data so that
%%% update to any of them in any subfunction will be synchronized
setappdata(mPlots.Result.Parent,'PAT',PAT)
setappdata(mPlots.Result.Parent,'PTT',PTT)
setappdata(mPlots.Result.Parent,'SIGS',SIGS)
eventList={};
setappdata(mPlots.Result.Parent,'eventList',eventList)
setappdata(mPlots.Result.Parent,'BPNames',{'DP','PP'})
setappdata(mPlots.Result.Parent,'SIGSNames',{'IJ','JK','IK'})
setappdata(mPlots.Result.Parent,'BCGNames',{'BCGScale','BCGWrist','BCGArm','BCGNeck'})

setappdata(mPlots.Result.Parent,'validEventNum',validEventNum)
setappdata(mPlots.Result.Parent,'subjectIndex',subjectIndex)
setappdata(mPlots.Result.Parent,'skipCalculation',0)
setappdata(mPlots.Result.Parent,'skipFeature',0)



%% Looping over all listed interventions in the Excel file
validEventIdx=1;figIdx=1;timeCounter = 0;
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
        BCGScalesig = filtered.(eventListOrig{eventIdx}).BCGScale;
        BCGWristsig = filtered.(eventListOrig{eventIdx}).BCGWrist;
        BCGArmsig = filtered.(eventListOrig{eventIdx}).BCGArm;
        BCGNecksig = filtered.(eventListOrig{eventIdx}).BCGNeck;
        BCGCopysig = filtered.(eventListOrig{eventIdx}).BCGScale;
        PPGClipsig = filtered.(eventListOrig{eventIdx}).PPGClip;
        PPGIRsig = filtered.(eventListOrig{eventIdx}).PPGIR;
        PPGGreensig = filtered.(eventListOrig{eventIdx}).PPGGreen;
%         figure(500);[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(-ECGsig,1000,1)
        
%         mPlots.Analysis.(eventTag).Parent=figure(validEventIdx+1);maximize(gcf);set(gcf,'Color','w')
        %%% Save signals and local info in application data of each figure
        figure(validEventIdx);maximize(gcf);set(gcf,'Color','w')
        setappdata(mPlots.Analysis.(eventTag).Parent,'timesig',timesig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'ECGsig',ECGsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BPsig',BPsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScalesig',BCGScalesig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGWristsig',BCGWristsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmsig',BCGArmsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGNecksig',BCGNecksig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGScaleCopysig',BCGScalesig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGWristCopysig',BCGWristsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmCopysig',BCGArmsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'BCGNeckCopysig',BCGNecksig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipsig',PPGClipsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGIRsig',PPGIRsig)
        setappdata(mPlots.Analysis.(eventTag).Parent,'PPGGreensig',PPGGreensig)
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
        mAxes.Analysis.(eventTag).BP=subplot(9,1,1);mPlots.Analysis.(eventTag).BP=plot(timesig,BPsig,'b');hold on;grid on;grid minor;ylabel('BP');
        title(['eventIdx = ' num2str(eventIdx) ', validEventIdx = ' num2str(validEventIdx) ', name = ' interventionName])
        mAxes.Analysis.(eventTag).ECG=subplot(9,1,2);mPlots.Analysis.(eventTag).ECG=plot(timesig,ECGsig,'b');hold on;grid on;grid minor;ylabel('ECG');
        mAxes.Analysis.(eventTag).BCGScale=subplot(9,1,3);mPlots.Analysis.(eventTag).BCGScale=plot(timesig,BCGScalesig,'b');hold on;grid on;grid minor;ylabel('BCG Scale');
        mAxes.Analysis.(eventTag).BCGWrist=subplot(9,1,4);mPlots.Analysis.(eventTag).BCGWrist=plot(timesig,BCGWristsig,'b');hold on;grid on;grid minor;ylabel('BCG Wrist');
        mAxes.Analysis.(eventTag).BCGArm=subplot(9,1,5);mPlots.Analysis.(eventTag).BCGArm=plot(timesig,BCGArmsig,'b');hold on;grid on;grid minor;ylabel('BCG Arm');
        mAxes.Analysis.(eventTag).BCGNeck=subplot(9,1,6);mPlots.Analysis.(eventTag).BCGNeck=plot(timesig,BCGNecksig,'b');hold on;grid on;grid minor;ylabel('BCG Neck');
        mAxes.Analysis.(eventTag).PPGClip=subplot(9,1,7);mPlots.Analysis.(eventTag).PPGClip=plot(timesig,PPGClipsig,'b');hold on;grid on;grid minor;ylabel('PPG Clip');
        mAxes.Analysis.(eventTag).PPGIR=subplot(9,1,8);mPlots.Analysis.(eventTag).PPGIR=plot(timesig,PPGIRsig,'b');hold on;grid on;grid minor;ylabel('PPG IR');
        mAxes.Analysis.(eventTag).PPGGreen=subplot(9,1,9);mPlots.Analysis.(eventTag).PPGGreen=plot(timesig,PPGGreensig,'b');hold on;grid on;grid minor;ylabel('PPG Green');
        
        
        %%% Place holder for candidate features
        mPlots.Analysis.(eventTag).Features.BPMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BP);
        mPlots.Analysis.(eventTag).Features.BPMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BP);
        mPlots.Analysis.(eventTag).Features.ECGMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).ECG);
        
        mPlots.Analysis.(eventTag).Features.BCGScaleHWave=plot(NaN,NaN,'co','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGScale);
        mPlots.Analysis.(eventTag).Features.BCGScaleIWave=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGScale);
        mPlots.Analysis.(eventTag).Features.BCGScaleJWave=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGScale);
        mPlots.Analysis.(eventTag).Features.BCGScaleKWave=plot(NaN,NaN,'mo','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGScale);
        mPlots.Analysis.(eventTag).Features.BCGScaleLWave=plot(NaN,NaN,'ko','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGScale);
        
        mPlots.Analysis.(eventTag).Features.BCGWristHWave=plot(NaN,NaN,'co','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGWrist);
        mPlots.Analysis.(eventTag).Features.BCGWristIWave=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGWrist);
        mPlots.Analysis.(eventTag).Features.BCGWristJWave=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGWrist);
        mPlots.Analysis.(eventTag).Features.BCGWristKWave=plot(NaN,NaN,'mo','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGWrist);
        mPlots.Analysis.(eventTag).Features.BCGWristLWave=plot(NaN,NaN,'ko','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGWrist);
        
        mPlots.Analysis.(eventTag).Features.BCGArmHWave=plot(NaN,NaN,'co','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGArm);
        mPlots.Analysis.(eventTag).Features.BCGArmIWave=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGArm);
        mPlots.Analysis.(eventTag).Features.BCGArmJWave=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGArm);
        mPlots.Analysis.(eventTag).Features.BCGArmKWave=plot(NaN,NaN,'mo','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGArm);
        mPlots.Analysis.(eventTag).Features.BCGArmLWave=plot(NaN,NaN,'ko','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGArm);
        
        mPlots.Analysis.(eventTag).Features.BCGNeckHWave=plot(NaN,NaN,'co','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGNeck);
        mPlots.Analysis.(eventTag).Features.BCGNeckIWave=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGNeck);
        mPlots.Analysis.(eventTag).Features.BCGNeckJWave=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGNeck);
        mPlots.Analysis.(eventTag).Features.BCGNeckKWave=plot(NaN,NaN,'mo','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGNeck);
        mPlots.Analysis.(eventTag).Features.BCGNeckLWave=plot(NaN,NaN,'ko','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).BCGNeck);
        
        mPlots.Analysis.(eventTag).Features.PPGClipMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGClip);
        mPlots.Analysis.(eventTag).Features.PPGClipMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGClip);
        mPlots.Analysis.(eventTag).Features.PPGClipFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGClip);
        
        mPlots.Analysis.(eventTag).Features.PPGIRMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGIR);
        mPlots.Analysis.(eventTag).Features.PPGIRMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGIR);
        mPlots.Analysis.(eventTag).Features.PPGIRFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGIR);
        
        mPlots.Analysis.(eventTag).Features.PPGGreenMax=plot(NaN,NaN,'go','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGGreen);
        mPlots.Analysis.(eventTag).Features.PPGGreenMin=plot(NaN,NaN,'ro','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGGreen);
        mPlots.Analysis.(eventTag).Features.PPGGreenFoot=plot(NaN,NaN,'b^','Tag',eventTag,'Parent',mAxes.Analysis.(eventTag).PPGGreen);
               
        %% Start of Controls
        %%% Horizontal scroll slider and pan slider
        pos=get(mAxes.Analysis.(eventTag).PPGGreen,'position');
        hScrollSliderPos=[pos(1) pos(2)-0.08 0.3 0.05];
        mControls.Analysis.(eventTag).hScrollSlider=uicontrol('style','slider','units','normalized','position',hScrollSliderPos,'min',0,'max',1,'SliderStep',[0.0001 0.1],'Tag',eventTag);
        hPanSliderPos=[hScrollSliderPos(1)+hScrollSliderPos(3) pos(2)-0.08 0.3 0.05];
        mControls.Analysis.(eventTag).hPanSlider=uicontrol('style','slider','units','normalized','position',hPanSliderPos,'min',0,'max',1,'Value',1,'SliderStep',[0.0001 0.1],'Tag',eventTag);
        
        %%% Signal Panel
        ax1Pos = mAxes.Analysis.(eventTag).BP.Position;
        mControls.Analysis.(eventTag).SignalButtonGroup = uibuttongroup('Title','Signal','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02,ax1Pos(2)+ax1Pos(4)-0.25,0.05,0.25],'Tag',eventTag);
        sigBtnGroupPos = mControls.Analysis.(eventTag).SignalButtonGroup.Position;
        mControls.Analysis.(eventTag).SelectNone = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
            'Position',[0.1,0.9,0.8,0.1],'BackgroundColor','g');
        mControls.Analysis.(eventTag).SelectBP = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BP','FontSize',9,'units','normalized',...
            'Position',[0.1,0.8,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectECG = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','ECG','FontSize',9,'units','normalized',...
            'Position',[0.1,0.7,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectBCGScale = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BCGScale','FontSize',9,'units','normalized',...
            'Position',[0.1,0.6,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectBCGWrist = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BCGWrist','FontSize',9,'units','normalized',...
            'Position',[0.1,0.5,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectBCGArm = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BCGArm','FontSize',9,'units','normalized',...
            'Position',[0.1,0.4,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectBCGNeck = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','BCGNeck','FontSize',9,'units','normalized',...
            'Position',[0.1,0.3,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGClip = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGClip','FontSize',9,'units','normalized',...
            'Position',[0.1,0.2,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGIR = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGIR','FontSize',9,'units','normalized',...
            'Position',[0.1,0.1,0.8,0.1]);
        mControls.Analysis.(eventTag).SelectPPGGreen = uicontrol(mControls.Analysis.(eventTag).SignalButtonGroup,'Style','togglebutton','String','PPGGreen','FontSize',9,'units','normalized',...
            'Position',[0.1,0.0,0.8,0.1]);
        
        %%% Feature Panel
        mControls.Analysis.(eventTag).FeatureButtonGroup = uibuttongroup('Title','Feature','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k','SelectedObject',[],...
            'Position',[sigBtnGroupPos(1)+sigBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.25,0.04,0.25],'Tag',eventTag);
        featureBtnGroupPos = mControls.Analysis.(eventTag).FeatureButtonGroup.Position;
        mControls.Analysis.(eventTag).FeatureNone = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
            'Position',[0.1,0.9,0.8,0.1],'BackgroundColor','g');
        mControls.Analysis.(eventTag).Peak = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Peak','FontSize',9,'units','normalized',...
            'Position',[0.1,0.8,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Trough = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Trough','FontSize',9,'units','normalized',...
            'Position',[0.1,0.7,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Hwave = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','HWave','FontSize',9,'units','normalized',...
            'Position',[0.1,0.6,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Iwave = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','IWave','FontSize',9,'units','normalized',...
            'Position',[0.1,0.5,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Jwave = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','JWave','FontSize',9,'units','normalized',...
            'Position',[0.1,0.4,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Kwave = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','KWave','FontSize',9,'units','normalized',...
            'Position',[0.1,0.3,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Lwave = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','LWave','FontSize',9,'units','normalized',...
            'Position',[0.1,0.2,0.8,0.1],'Enable','off');
        mControls.Analysis.(eventTag).Foot = uicontrol(mControls.Analysis.(eventTag).FeatureButtonGroup,'Style','togglebutton','String','Foot','FontSize',9,'units','normalized',...
            'Position',[0.1,0.1,0.8,0.1],'Enable','off');
        
%         %%% Mode Panel
%         mControls.Analysis.(eventTag).ModeButtonGroup = uibuttongroup('Title','Mode','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
%             'Position',[sigBtnGroupPos(1)+sigBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.20,0.04,0.10],'Tag',eventTag);
%         mControls.Analysis.(eventTag).ModeNone = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','None','FontSize',9,'units','normalized',...
%             'Position',[0.1,0.75,0.8,0.25],'BackgroundColor','g');
%         mControls.Analysis.(eventTag).Remove = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Remove','FontSize',9,'units','normalized',...
%             'Position',[0.1,0.50,0.8,0.25],'Enable','off');
%         mControls.Analysis.(eventTag).Update = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Update','FontSize',9,'units','normalized',...
%             'Position',[0.1,0.25,0.8,0.25],'Enable','off');
%         mControls.Analysis.(eventTag).Move = uicontrol(mControls.Analysis.(eventTag).ModeButtonGroup,'Style','togglebutton','String','Move','FontSize',9,'units','normalized',...
%             'Position',[0.1,0.00,0.8,0.25],'Enable','off');
        
        %%% Action Panel
        mControls.Analysis.(eventTag).ActionPanel = uipanel('Title','Action','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[featureBtnGroupPos(1)+featureBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.14,0.1,0.14],'Tag',eventTag);
        mControls.Analysis.(eventTag).RemoveFeature = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Remove Features On Screen',...
            'FontSize',9,'units','normalized','Position',[0.05,0.8,0.9,0.2]);
        mControls.Analysis.(eventTag).UpdateFeature = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Update Features On Screen',...
            'FontSize',9,'units','normalized','Position',[0.05,0.6,0.9,0.2]);
        mControls.Analysis.(eventTag).GoToSIGSWindow = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Go To SIGS Window',...
            'FontSize',9,'units','normalized','Position',[0.05,0.4,0.9,0.2]);
        mControls.Analysis.(eventTag).GoToFeatureWindow = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Go To Feature Window','FontSize',9,...
            'units','normalized','Position',[0.05,0.2,0.9,0.2]);
        mControls.Analysis.(eventTag).RefreshResult = uicontrol(mControls.Analysis.(eventTag).ActionPanel,'Style','pushbutton','String','Refresh Result','FontSize',9,...
            'units','normalized','Position',[0.05,0.0,0.9,0.2]);
        
        %%% Data Save/Load Panel
        mControls.Analysis.(eventTag).DataPanel = uipanel('Title','Data','BackgroundColor','w','FontSize',12,'units','normalized','HighlightColor','k',...
            'Position',[featureBtnGroupPos(1)+featureBtnGroupPos(3)+0.01,ax1Pos(2)+ax1Pos(4)-0.25,0.1,0.1],'Tag',eventTag);
        mControls.Analysis.(eventTag).LoadData = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Load Data',...
            'FontSize',9,'units','normalized','Position',[0.05,0.7,0.9,0.3]);
        mControls.Analysis.(eventTag).SaveData = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Save Data',...
            'FontSize',9,'units','normalized','Position',[0.05,0.4,0.9,0.3]);
%         mControls.Analysis.(eventTag).ConfirmFeature = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Confirm Features On Screen',...
%             'FontSize',9,'units','normalized','Position',[0.05,0.25,0.9,0.25]);
%         mControls.Analysis.(eventTag).GoToWindow = uicontrol(mControls.Analysis.(eventTag).DataPanel,'Style','pushbutton','String','Go To Window','FontSize',9,...
%             'units','normalized','Position',[0.05,0.00,0.9,0.25]);
        
        %%% Parameter Tab
        BCGWristAxeLoc = mAxes.Analysis.(eventTag).BCGWrist.Position;
        mControls.Analysis.(eventTag).ParameterTabs = uitabgroup('Parent',mPlots.Analysis.(eventTag).Parent,'units','normalized',...
            'Position',[BCGWristAxeLoc(1)+BCGWristAxeLoc(3)+0.02,BCGWristAxeLoc(2)+BCGWristAxeLoc(4)-0.6,0.22,0.6],'Tag',eventTag);
        signalNames={'BP','ECG','BCGScale','BCGWrist','BCGArm','BCGNeck','PPGClip','PPGIR','PPGGreen'};
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
                signalParams = sort(allKeys(contains(allKeys,signalName) & ~contains(allKeys,{'Clip','IR','Green','ECGMax2BCGMax'})));
            else
                signalParams = sort(allKeys(contains(allKeys,signalName)));
            end
            defaultParams = getappdata(mPlots.Analysis.(eventTag).Parent,'defaultParams');
            customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
            for jj = 1:length(signalParams)
                signalParam = signalParams{jj};
                mControls.Analysis.(eventTag).([signalParam 'Text']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'ParameterPanel']),'Style','text','String',signalParam,...
                    'units','normalized','Position',[0.01,0.95-0.045*jj,0.9,0.05],'HorizontalAlignment','left','FontSize',9);
                mControls.Analysis.(eventTag).([signalParam 'DefaultText']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'DefaultPanel']),'Style','text','Tag',signalParam,...
                    'String',num2str(defaultParams(signalParam)),'units','normalized','Position',[0.05,0.95-0.045*jj,0.9,0.05],...
                    'HorizontalAlignment','center','FontSize',9);
                mControls.Analysis.(eventTag).([signalParam 'CustomEdit']) = uicontrol('Parent',mControls.Analysis.(eventTag).([signalName 'CustomPanel']),'Style','edit','Tag',signalParam,...
                    'String',num2str(customParams(signalParam)),'units','normalized','Position',[0.05,0.965-0.045*jj,0.9,0.04],...
                    'HorizontalAlignment','center','FontSize',9,'Callback',{@customParamEditCallback,mPlots});
            end
        end
        
        %%% Select reference signal (for use of displaying PTT/PAT window)
        mControls.Analysis.(eventTag).ReferenceSignalPopup = uicontrol('style','popup','String',{'ECG','BCGScale','BCGWrist','BCGArm','BCGNeck'},'FontSize',9,'units','normalized',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02,ax1Pos(2)+ax1Pos(4)-0.25-0.03,0.05,0.02],'Tag',eventTag);
        mControls.Analysis.(eventTag).BPNamesPopup = uicontrol('style','popup','String',{'DP','PP'},'FontSize',9,'units','normalized',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02+0.06,ax1Pos(2)+ax1Pos(4)-0.25-0.03,0.03,0.02],'Tag',eventTag);
        mControls.Analysis.(eventTag).SIGSNamesPopup = uicontrol('style','popup','String',{'IJ','JK','IK'},'FontSize',9,'units','normalized',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02+0.10,ax1Pos(2)+ax1Pos(4)-0.25-0.03,0.03,0.02],'Tag',eventTag);
        mControls.Analysis.(eventTag).PropertyNamesPopup = uicontrol('style','popup','String',{'Interval','Amplitude'},'FontSize',9,'units','normalized',...
            'Position',[ax1Pos(1)+ax1Pos(3)+0.02+0.14,ax1Pos(2)+ax1Pos(4)-0.25-0.03,0.04,0.02],'Tag',eventTag);
        
        %%% Defining callbacks/buttondown function/listeners for the
        %%% control components
        mControls.Analysis.(eventTag).hScrollSliderListener=addlistener(mControls.Analysis.(eventTag).hScrollSlider,...
            'ContinuousValueChange',@(src,cbdata)scrollbarCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Analysis.(eventTag).hScrollSlider,'hScrollSliderListener',mControls.Analysis.(eventTag).hScrollSliderListener);
        mControls.Analysis.(eventTag).hPanSliderListener=addlistener(mControls.Analysis.(eventTag).hPanSlider,...
            'ContinuousValueChange',@(src,cbdata)hPanCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
        setappdata(mControls.Analysis.(eventTag).hPanSlider,'hPanSliderListener',mControls.Analysis.(eventTag).hPanSliderListener);
        
%         mControls.Adjust.(eventTag).BCGSliderListener=addlistener(mControls.Adjust.(eventTag).BCGSlider,...
%             'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
%         setappdata(mControls.Adjust.(eventTag).BCGSlider,'BCGSliderListener',mControls.Adjust.(eventTag).BCGSliderListener)
%         mControls.Adjust.(eventTag).PPGfingerSliderListener=addlistener(mControls.Adjust.(eventTag).PPGfingerSlider,...
%             'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
%         setappdata(mControls.Adjust.(eventTag).PPGfingerSlider,'PPGfingerSliderListener',mControls.Adjust.(eventTag).PPGfingerSliderListener)
%         mControls.Adjust.(eventTag).PPGearSliderListener=addlistener(mControls.Adjust.(eventTag).PPGearSlider,...
%             'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
%         setappdata(mControls.Adjust.(eventTag).PPGearSlider,'PPGearSliderListener',mControls.Adjust.(eventTag).PPGearSliderListener)
%         mControls.Adjust.(eventTag).PPGfeetSliderListener=addlistener(mControls.Adjust.(eventTag).PPGfeetSlider,...
%             'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
%         setappdata(mControls.Adjust.(eventTag).PPGfeetSlider,'PPGfeetSliderListener',mControls.Adjust.(eventTag).PPGfeetSliderListener)
%         mControls.Adjust.(eventTag).PPGtoeSliderListener=addlistener(mControls.Adjust.(eventTag).PPGtoeSlider,...
%             'ContinuousValueChange',@(src,cbdata)adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams));
%         setappdata(mControls.Adjust.(eventTag).PPGtoeSlider,'PPGtoeSliderListener',mControls.Adjust.(eventTag).PPGtoeSliderListener)
%         
%         set(mControls.Adjust.(eventTag).BCGReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
%         set(mControls.Adjust.(eventTag).PPGfingerReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
%         set(mControls.Adjust.(eventTag).PPGearReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
%         set(mControls.Adjust.(eventTag).PPGfeetReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
%         set(mControls.Adjust.(eventTag).PPGtoeReferenceSignalPopup,'Callback',{@adjustSliderReferenceCallback,eventTag,mAxes,mPlots,mControls,mParams})
        
        set(mControls.Analysis.(eventTag).SignalButtonGroup,'SelectionChangedFcn',{@selectSignalCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).FeatureButtonGroup,'SelectionChangedFcn',{@selectFeatureCallback,mAxes,mPlots,mControls,mParams})
%         set(mControls.Analysis.(eventTag).ModeButtonGroup,'SelectionChangedFcn',{@selectModeCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).RemoveFeature,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).UpdateFeature,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).GoToSIGSWindow,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).GoToFeatureWindow,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
        set(mControls.Analysis.(eventTag).RefreshResult,'Callback',{@selectActionCallback,mAxes,mPlots,mControls,mParams})
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
    
end


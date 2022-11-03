clear all;close all;clc
addpath('../../export_fig')
% Main file!
%% Load constant variables and default parameters for each subject
load mParams

%% Load subject information from Excel file and raw data file 
[~,~,subjectParamXLS] = xlsread('../../../Data2\subjectParamXLS');
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
% fileIndex = 29; subjectIndex = 34; fileName = '../../../Data2\wave_034-standing';
% fileIndex = 30; subjectIndex = 36; fileName = '../../../Data2\wave_036-standing';
% fileIndex = 31; subjectIndex = 37; fileName = '../../../Data2\wave_037-standing';
% fileIndex = 32; subjectIndex = 601; fileName = '../../../Data2\wave_006_2-standing';
% fileIndex = 33; subjectIndex = 801; fileName = '../../../Data2\wave_008_2-standing';
fileIndex = 34; subjectIndex = 701; fileName = '../../../Data2\wave_007_2-standing';
defaultParams = mParams.DefaultValue.(['Subject' num2str(subjectIndex)]);
customParams = copy(defaultParams);
InterventionName2Idx = mParams.Constant.InterventionName2Idx;

%% Load raw data file and variable assignment
dataRaw = load(fileName);
data = dataRaw.data;
BPNexfinTemp = data(:,11);
data = data(1:end-250,:);
data(:,11) = BPNexfinTemp(251:end,1);
BPCuff = data(:,1)*100;
BPOsc = data(:,2);
ECG1 = data(:,3);
ECG = data(:,13);
if any(subjectIndex == [19,20,21,25,27,34]) == 1 %sub19
    ECG = -ECG;
elseif fileIndex == 16 %sub20
    ECG=-ECG;
elseif fileIndex == 17 %sub21
    ECG=-ECG;
elseif fileIndex == 21 %sub25
    ECG=-ECG;
elseif fileIndex == 23 %sub27
    ECG = -ECG;
elseif fileIndex == 29 %sub34
    ECG = -ECG;
end
BCG = data(:,4);
ICGz = data(:,5);
PPGfeet = data(:,6);
if any(subjectIndex == [24,25,27,28,29,30,33,34,37,601,801,701]) == 1 %sub24
    PPGfeet = -PPGfeet;
elseif fileIndex == 21 %sub25
    PPGfeet = -PPGfeet;  
elseif fileIndex == 23 %sub27
    PPGfeet = -PPGfeet;
elseif fileIndex == 24 %sub28
    PPGfeet = -PPGfeet;
elseif fileIndex == 25 %sub29
    PPGfeet = -PPGfeet;
elseif fileIndex == 26 %sub30
    PPGfeet = -PPGfeet;
elseif fileIndex == 28 %sub33
    PPGfeet = -PPGfeet;
elseif fileIndex == 29 %sub34
    PPGfeet = -PPGfeet;
elseif fileIndex == 31 %sub37
    PPGfeet = -PPGfeet;
end
PPGtoe = data(:,7);
PPGear = data(:,8);
PPGfingerClip = data(:,9);
PPGfingerWrap = data(:,10);
BPNexfin = data(:,11)*100;
ICGdzdt = data(:,12);
time=0:0.001:0.001*(length(data)-1);
totalLength=length(data);
fs=mParams.Constant.fs; % sampling frequency

%% Filter the signal
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
[u,v]=butter(1,[0.5,20]/(fs/2));
ICGdzdtFiltered=filtfilt(u,v,ICGdzdt);

%%
mPlots.All.Parent = figure(1);maximize(gcf);set(gcf,'Color','w');
mPlots.All.DataTabs = uitabgroup('Parent',mPlots.All.Parent);
subplot = @(m,n,p) subtightplot (m, n, p, 0.04, 0.06, [0.05 0.25]);
mPlots.Analysis.EventRaw.Parent = uitab('Parent',mPlots.All.DataTabs,'Title','Raw Signals');
mAxes.Analysis.EventRaw.Parent=axes('Parent',mPlots.Analysis.EventRaw.Parent);
mAxes.Analysis.EventRaw.BP=subplot(8,1,1);mPlots.Analysis.EventRaw.BP=plot(time,BPNexfin,'b');hold on;grid on;grid minor;ylabel('BP');
mAxes.Analysis.EventRaw.ECG=subplot(8,1,2);mPlots.Analysis.EventRaw.ECG=plot(time,ECG,'b');hold on;grid on;grid minor;ylabel('ECG');
mAxes.Analysis.EventRaw.ICGdzdt=subplot(8,1,3);mPlots.Analysis.EventRaw.ICGdzdt=plot(time,ICGdzdt,'b');hold on;grid on;grid minor;ylabel('ICGdzdt');
mAxes.Analysis.EventRaw.BCG=subplot(8,1,4);mPlots.Analysis.EventRaw.BCG=plot(time,BCG,'b');hold on;grid on;grid minor;ylabel('BCG');
mAxes.Analysis.EventRaw.PPGfinger=subplot(8,1,5);mPlots.Analysis.EventRaw.PPGfinger=plot(time,PPGfingerClip,'b');hold on;grid on;grid minor;ylabel('PPGfinger');
mAxes.Analysis.EventRaw.PPGear=subplot(8,1,6);mPlots.Analysis.EventRaw.PPGear=plot(time,PPGear,'b');hold on;grid on;grid minor;ylabel('PPGear');
mAxes.Analysis.EventRaw.PPGfeet=subplot(8,1,7);mPlots.Analysis.EventRaw.PPGfeet=plot(time,PPGfeet,'b');hold on;grid on;grid minor;ylabel('PPGfeet');
mAxes.Analysis.EventRaw.PPGtoe=subplot(8,1,8);mPlots.Analysis.EventRaw.PPGtoe=plot(time,PPGtoe,'b');hold on;grid on;grid minor;ylabel('PPGtoe');
setappdata(mPlots.Analysis.EventRaw.Parent,'timesig',time)
setappdata(mPlots.Analysis.EventRaw.Parent,'ECGsig',ECG)
setappdata(mPlots.Analysis.EventRaw.Parent,'BPsig',BPNexfin)
setappdata(mPlots.Analysis.EventRaw.Parent,'ICGdzdtsig',ICGdzdt)
setappdata(mPlots.Analysis.EventRaw.Parent,'BCGsig',BCG)
setappdata(mPlots.Analysis.EventRaw.Parent,'PPGfingersig',PPGfingerClip)
setappdata(mPlots.Analysis.EventRaw.Parent,'PPGearsig',PPGear)
setappdata(mPlots.Analysis.EventRaw.Parent,'PPGfeetsig',PPGfeet)
setappdata(mPlots.Analysis.EventRaw.Parent,'PPGtoesig',PPGtoe)
setappdata(mPlots.Analysis.EventRaw.Parent,'startIdx',1)
%% Horizontal scroll slider and pan slider
pos=get(mAxes.Analysis.EventRaw.PPGtoe,'position');
hScrollSliderPos=[pos(1) pos(2)-0.08 0.3 0.05];
mControls.Analysis.EventRaw.hScrollSlider=uicontrol(mPlots.Analysis.EventRaw.Parent,'style','slider','units','normalized','position',hScrollSliderPos,'min',0,'max',1,...
    'SliderStep',[0.0001 0.1],'Tag','EventRaw');
hPanSliderPos=[hScrollSliderPos(1)+hScrollSliderPos(3) pos(2)-0.08 0.3 0.05];
mControls.Analysis.EventRaw.hPanSlider=uicontrol(mPlots.Analysis.EventRaw.Parent,'style','slider','units','normalized','position',hPanSliderPos,'min',0,'max',1,'Value',1,...
    'SliderStep',[0.0001 0.1],'Tag','EventRaw');
% Listener
mControls.Analysis.EventRaw.hScrollSliderListener=addlistener(mControls.Analysis.EventRaw.hScrollSlider,...
    'ContinuousValueChange',@(src,cbdata)scrollbarCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
setappdata(mControls.Analysis.EventRaw.hScrollSlider,'hScrollSliderListener',mControls.Analysis.EventRaw.hScrollSliderListener);
mControls.Analysis.EventRaw.hPanSliderListener=addlistener(mControls.Analysis.EventRaw.hPanSlider,...
    'ContinuousValueChange',@(src,cbdata)hPanCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
setappdata(mControls.Analysis.EventRaw.hPanSlider,'hPanSliderListener',mControls.Analysis.EventRaw.hPanSliderListener);

%%%%%%%%%
mPlots.Analysis.EventFiltered.Parent = uitab('Parent',mPlots.All.DataTabs,'Title','Filtered Signals');
mAxes.Analysis.EventFiltered.Parent=axes('Parent',mPlots.Analysis.EventFiltered.Parent);
mAxes.Analysis.EventFiltered.BP=subplot(8,1,1);mPlots.Analysis.EventFiltered.BP=plot(time,BPNexfinFiltered,'b');hold on;grid on;grid minor;ylabel('BP');
mAxes.Analysis.EventFiltered.ECG=subplot(8,1,2);mPlots.Analysis.EventFiltered.ECG=plot(time,ECGFiltered,'b');hold on;grid on;grid minor;ylabel('ECG');
mAxes.Analysis.EventFiltered.ICGdzdt=subplot(8,1,3);mPlots.Analysis.EventFiltered.ICGdzdt=plot(time,ICGdzdtFiltered,'b');hold on;grid on;grid minor;ylabel('ICGdzdt');
mAxes.Analysis.EventFiltered.BCG=subplot(8,1,4);mPlots.Analysis.EventFiltered.BCG=plot(time,BCGFiltered,'b');hold on;grid on;grid minor;ylabel('BCG');
mAxes.Analysis.EventFiltered.PPGfinger=subplot(8,1,5);mPlots.Analysis.EventFiltered.PPGfinger=plot(time,PPGfingerClipFiltered,'b');hold on;grid on;grid minor;ylabel('PPGfinger');
mAxes.Analysis.EventFiltered.PPGear=subplot(8,1,6);mPlots.Analysis.EventFiltered.PPGear=plot(time,PPGearFiltered,'b');hold on;grid on;grid minor;ylabel('PPGear');
mAxes.Analysis.EventFiltered.PPGfeet=subplot(8,1,7);mPlots.Analysis.EventFiltered.PPGfeet=plot(time,PPGfeetFiltered,'b');hold on;grid on;grid minor;ylabel('PPGfeet');
mAxes.Analysis.EventFiltered.PPGtoe=subplot(8,1,8);mPlots.Analysis.EventFiltered.PPGtoe=plot(time,PPGtoeFiltered,'b');hold on;grid on;grid minor;ylabel('PPGtoe');
setappdata(mPlots.Analysis.EventFiltered.Parent,'timesig',time)
setappdata(mPlots.Analysis.EventFiltered.Parent,'ECGsig',ECGFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'BPsig',BPNexfinFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'ICGdzdtsig',ICGdzdtFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'BCGsig',BCGFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'PPGfingersig',PPGfingerClipFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'PPGearsig',PPGearFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'PPGfeetsig',PPGfeetFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'PPGtoesig',PPGtoeFiltered)
setappdata(mPlots.Analysis.EventFiltered.Parent,'startIdx',1)
%% Horizontal scroll slider and pan slider
pos=get(mAxes.Analysis.EventFiltered.PPGtoe,'position');
hScrollSliderPos=[pos(1) pos(2)-0.08 0.3 0.05];
mControls.Analysis.EventFiltered.hScrollSlider=uicontrol(mPlots.Analysis.EventFiltered.Parent,'style','slider','units','normalized','position',hScrollSliderPos,'min',0,'max',1,...
    'SliderStep',[0.0001 0.1],'Tag','EventFiltered');
hPanSliderPos=[hScrollSliderPos(1)+hScrollSliderPos(3) pos(2)-0.08 0.3 0.05];
mControls.Analysis.EventFiltered.hPanSlider=uicontrol(mPlots.Analysis.EventFiltered.Parent,'style','slider','units','normalized','position',hPanSliderPos,'min',0,'max',1,'Value',1,...
    'SliderStep',[0.0001 0.1],'Tag','EventFiltered');
% Listener
mControls.Analysis.EventFiltered.hScrollSliderListener=addlistener(mControls.Analysis.EventFiltered.hScrollSlider,...
    'ContinuousValueChange',@(src,cbdata)scrollbarCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
setappdata(mControls.Analysis.EventFiltered.hScrollSlider,'hScrollSliderListener',mControls.Analysis.EventFiltered.hScrollSliderListener);
mControls.Analysis.EventFiltered.hPanSliderListener=addlistener(mControls.Analysis.EventFiltered.hPanSlider,...
    'ContinuousValueChange',@(src,cbdata)hPanCallback(src,cbdata,mAxes,mPlots,mControls,mParams));
setappdata(mControls.Analysis.EventFiltered.hPanSlider,'hPanSliderListener',mControls.Analysis.EventFiltered.hPanSliderListener);

%% Initialization
validEventNum = 0;eventIdx=1;
while ~isnan(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4})
    % An intervention is included for analysis if its *note* in the excel
    % file is set to 'Y'
    if subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+3} == 'Y' 
        validEventNum = validEventNum+1;
        mPlots.Analysis.(['Event',num2str(validEventNum)]).Parent=figure(validEventNum+1); % Pre-allocation of figure for each intervention
    end
    eventIdx = eventIdx+1;
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
validEventIdx=1;figIdx=2;
eventIdx=1;
while ~isnan(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4}) %eventIdx<=4 %
    name = ['event' num2str(eventIdx)];
    eventTag = ['Event' num2str(validEventIdx)];
    eventData.(name).eventName = subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4};
    eventData.(name).startTime = round(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+1}*60);
    eventData.(name).endTime = round(subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+2}*60);
    eventData.(name).note = subjectParamXLS{fileIndex+1,2+(eventIdx-1)*4+3};
    interventionName = eventData.(name).eventName; interventionIdx = InterventionName2Idx(interventionName);
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
        ECGsig = ECGFiltered(dataRange);
        BPsig = BPNexfinFiltered(dataRange);
        ICGdzdtsig = ICGdzdtFiltered(dataRange);
        BCGsig = BCGFiltered(dataRange);
        BCGCopysig = BCGFiltered(dataRange);
        PPGfingersig = PPGfingerClipFiltered(dataRange);
        PPGearsig = PPGearFiltered(dataRange);
        PPGfeetsig = PPGfeetFiltered(dataRange);
        PPGtoesig = PPGtoeFiltered(dataRange);
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

%%
% mPlots.Adjust.Parent=figure(110);maximize(gcf);set(gcf,'Color','w');
% mControls.Adjust.EventTabs = uitabgroup('Parent',mPlots.Adjust.Parent);
% SlidingWindowSize = mParams.Constant.SlidingWindowSize;
% for ii = 1:validEventNum
%     eventNames = getappdata(mPlots.Result.Parent,'eventList');
%     mControls.Adjust.(['Event' num2str(ii) 'Tab']) = uitab('Parent',mControls.Adjust.EventTabs,'Title',['Event' num2str(ii) ': ' eventNames{ii}]);
%     mAxes.Adjust.(['Event' num2str(ii) 'Parent'])=axes('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']));
%     subplot(6,1,1)
%     BPMinLoc = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMinLoc');
%     BPMin = getappdata(mPlots.Analysis.(['Event' num2str(ii)]).Parent,'BPMin');
%     plot((BPMinLoc-1)/fs,BPMin,'o-')
%     mControls.Adjust.(['Event' num2str(ii)]).BCGSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.75,0.3,0.03],'Min',0,'Max',length(BPMinLoc)-(SlidingWindowSize-1),'Value',0);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfingerSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.70,0.3,0.03],'Min',0,'Max',length(BPMinLoc)-(SlidingWindowSize-1),'Value',0);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGearSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.65,0.3,0.03],'Min',0,'Max',length(BPMinLoc)-(SlidingWindowSize-1),'Value',0);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGfeetSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.60,0.3,0.03],'Min',0,'Max',length(BPMinLoc)-(SlidingWindowSize-1),'Value',0);
%     mControls.Adjust.(['Event' num2str(ii)]).PPGtoeSlider=uicontrol('Parent',mControls.Adjust.(['Event' num2str(ii) 'Tab']),'style','slider','units','normalized',...
%         'position',[0.05,0.55,0.3,0.03],'Min',0,'Max',length(BPMinLoc)-(SlidingWindowSize-1),'Value',0);
% end
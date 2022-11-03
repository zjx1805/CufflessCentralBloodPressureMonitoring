function []=hPanCallback(source,callbackdata,mAxes,mPlots,mControls,mParams)

% Redraw data points on the screen when pan slider is moved.

fs = mParams.Constant.fs;
panLoc = source.Value;
panValue = mParams.Constant.MinPanValue+panLoc*(mParams.Constant.MaxPanValue-mParams.Constant.MinPanValue);
eventTag = source.Tag;
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');

timesig = getappdata(mPlots.Analysis.(eventTag).Parent,'timesig');
ECGsig = getappdata(mPlots.Analysis.(eventTag).Parent,'ECGsig');
BPsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BPsig');
ICGdzdtsig = getappdata(mPlots.Analysis.(eventTag).Parent,'ICGdzdtsig');
BCGsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGsig');
PPGfingersig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfingersig');
PPGearsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGearsig');
PPGfeetsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGfeetsig');
PPGtoesig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGtoesig');
scrollLoc = mControls.Analysis.(eventTag).hScrollSlider.Value;



dataRange = (1+round(scrollLoc*(length(timesig)-panValue*fs-1))):(1+round(scrollLoc*(length(timesig)-panValue*fs-1))+panValue*fs);
timeRange = timesig(1)+(dataRange-1)/fs;
BPRange = BPsig(dataRange);
ECGRange = ECGsig(dataRange);
ICGdzdtRange = ICGdzdtsig(dataRange);
BCGRange = BCGsig(dataRange);
PPGfingerRange = PPGfingersig(dataRange);
PPGearRange = PPGearsig(dataRange);
PPGfeetRange = PPGfeetsig(dataRange);
PPGtoeRange = PPGtoesig(dataRange);
setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx',dataRange(1))
setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx',dataRange(end))


set(mPlots.Analysis.(eventTag).BP,'XData',timeRange,'YData',BPRange)
% axis(mAxes.Analysis.Event1.BP,[timeRange(1),timeRange(end),-inf,inf])
set(mPlots.Analysis.(eventTag).ECG,'XData',timeRange,'YData',ECGRange)
set(mPlots.Analysis.(eventTag).ICGdzdt,'XData',timeRange,'YData',ICGdzdtRange)
set(mPlots.Analysis.(eventTag).BCG,'XData',timeRange,'YData',BCGRange)
set(mPlots.Analysis.(eventTag).PPGfinger,'XData',timeRange,'YData',PPGfingerRange)
set(mPlots.Analysis.(eventTag).PPGear,'XData',timeRange,'YData',PPGearRange)
set(mPlots.Analysis.(eventTag).PPGfeet,'XData',timeRange,'YData',PPGfeetRange)
set(mPlots.Analysis.(eventTag).PPGtoe,'XData',timeRange,'YData',PPGtoeRange)

if contains(eventTag,{'Raw','Filtered'}) ~= 1
featureNames = fieldnames(mPlots.Analysis.(eventTag).Features);
for ii = 1:length(featureNames)
    featureName = featureNames{ii};
    featureXData = getappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc']);
    featureYData = getappdata(mPlots.Analysis.(eventTag).Parent,featureName);
    mask = ((featureXData-1)/fs>=timeRange(1) & (featureXData-1)/fs<=timeRange(end));
    set(mPlots.Analysis.(eventTag).Features.(featureName),'XData',(featureXData(mask)-1)/fs,'YData',featureYData(mask))
    
end
end
axis(mAxes.Analysis.(eventTag).BP,[timeRange(1),timeRange(end),min(BPRange),max(BPRange)])
axis(mAxes.Analysis.(eventTag).ECG,[timeRange(1),timeRange(end),min(ECGRange),max(ECGRange)])
axis(mAxes.Analysis.(eventTag).ICGdzdt,[timeRange(1),timeRange(end),min(ICGdzdtRange),max(ICGdzdtRange)])
axis(mAxes.Analysis.(eventTag).BCG,[timeRange(1),timeRange(end),min(BCGRange),max(BCGRange)])
axis(mAxes.Analysis.(eventTag).PPGfinger,[timeRange(1),timeRange(end),min(PPGfingerRange),max(PPGfingerRange)])
axis(mAxes.Analysis.(eventTag).PPGear,[timeRange(1),timeRange(end),min(PPGearRange),max(PPGearRange)])
axis(mAxes.Analysis.(eventTag).PPGfeet,[timeRange(1),timeRange(end),min(PPGfeetRange),max(PPGfeetRange)])
axis(mAxes.Analysis.(eventTag).PPGtoe,[timeRange(1),timeRange(end),min(PPGtoeRange),max(PPGtoeRange)])

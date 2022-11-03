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
BCGScalesig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGScalesig');
BCGWristsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGWristsig');
BCGArmsig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGArmsig');
BCGNecksig = getappdata(mPlots.Analysis.(eventTag).Parent,'BCGNecksig');
PPGClipsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGClipsig');
PPGIRsig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGIRsig');
PPGGreensig = getappdata(mPlots.Analysis.(eventTag).Parent,'PPGGreensig');
scrollLoc = mControls.Analysis.(eventTag).hScrollSlider.Value;



dataRange = (1+round(scrollLoc*(length(timesig)-panValue*fs-1))):(1+round(scrollLoc*(length(timesig)-panValue*fs-1))+panValue*fs);
timeRange = timesig(1)+(dataRange-1)/fs;
BPRange = BPsig(dataRange);
ECGRange = ECGsig(dataRange);
BCGScaleRange = BCGScalesig(dataRange);
BCGWristRange = BCGWristsig(dataRange);
BCGArmRange = BCGArmsig(dataRange);
BCGNeckRange = BCGNecksig(dataRange);
PPGClipRange = PPGClipsig(dataRange);
PPGIRRange = PPGIRsig(dataRange);
PPGGreenRange = PPGGreensig(dataRange);
setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx',dataRange(1))
setappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx',dataRange(end))


set(mPlots.Analysis.(eventTag).BP,'XData',timeRange,'YData',BPRange)
set(mPlots.Analysis.(eventTag).ECG,'XData',timeRange,'YData',ECGRange)
set(mPlots.Analysis.(eventTag).BCGScale,'XData',timeRange,'YData',BCGScaleRange)
set(mPlots.Analysis.(eventTag).BCGWrist,'XData',timeRange,'YData',BCGWristRange)
set(mPlots.Analysis.(eventTag).BCGArm,'XData',timeRange,'YData',BCGArmRange)
set(mPlots.Analysis.(eventTag).BCGNeck,'XData',timeRange,'YData',BCGNeckRange)
set(mPlots.Analysis.(eventTag).PPGClip,'XData',timeRange,'YData',PPGClipRange)
set(mPlots.Analysis.(eventTag).PPGIR,'XData',timeRange,'YData',PPGIRRange)
set(mPlots.Analysis.(eventTag).PPGGreen,'XData',timeRange,'YData',PPGGreenRange)

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
axis(mAxes.Analysis.(eventTag).BCGScale,[timeRange(1),timeRange(end),min(BCGScaleRange),max(BCGScaleRange)])
axis(mAxes.Analysis.(eventTag).BCGWrist,[timeRange(1),timeRange(end),min(BCGWristRange),max(BCGWristRange)])
axis(mAxes.Analysis.(eventTag).BCGArm,[timeRange(1),timeRange(end),min(BCGArmRange),max(BCGArmRange)])
axis(mAxes.Analysis.(eventTag).BCGNeck,[timeRange(1),timeRange(end),min(BCGNeckRange),max(BCGNeckRange)])
axis(mAxes.Analysis.(eventTag).PPGClip,[timeRange(1),timeRange(end),min(PPGClipRange),max(PPGClipRange)])
axis(mAxes.Analysis.(eventTag).PPGIR,[timeRange(1),timeRange(end),min(PPGIRRange),max(PPGIRRange)])
axis(mAxes.Analysis.(eventTag).PPGGreen,[timeRange(1),timeRange(end),min(PPGGreenRange),max(PPGGreenRange)])
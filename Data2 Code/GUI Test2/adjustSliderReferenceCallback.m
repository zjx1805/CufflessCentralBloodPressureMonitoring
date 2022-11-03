function []=adjustSliderReferenceCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams)

value = src.Value;
signalNames = src.String;
entryCode = 0; skipCalculation = 0; skipFeature = 1;
setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
signalTag = src.Tag;
setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowSource',extractBefore(signalTag,'Popup'))
setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowReference',signalNames{value})
setappdata(mPlots.Result.Parent,'skipCalculation',skipCalculation)
setappdata(mPlots.Result.Parent,'skipFeature',skipFeature)
analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
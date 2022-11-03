function []=adjustSliderCallback(src,cbdata,eventTag,mAxes,mPlots,mControls,mParams)

value = src.Value;
srcTag = src.Tag;
mControls.Adjust.(eventTag).([srcTag 'Text']).String = num2str(round(value));
entryCode = 0; skipCalculation = 0; skipFeature = 1;
setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
signalAdjusted = extractBefore(srcTag,'Slider');
setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowSource',signalAdjusted)
referenceSignalNum = mControls.Adjust.(eventTag).([signalAdjusted 'ReferenceSignalPopup']).Value;
referenceSignalNames = mControls.Adjust.(eventTag).([signalAdjusted 'ReferenceSignalPopup']).String;
setappdata(mPlots.Analysis.(eventTag).Parent,'currentBPWindowReference',referenceSignalNames{referenceSignalNum})
setappdata(mPlots.Result.Parent,'skipCalculation',skipCalculation)
setappdata(mPlots.Result.Parent,'skipFeature',skipFeature)
analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
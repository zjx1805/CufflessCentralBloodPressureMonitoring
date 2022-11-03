function []=selectModeCallback(source,cbdata,mAxes,mPlots,mControls,mParams)

% Perfom a specific action when a specific mode is selected

cbdata.OldValue.BackgroundColor = [0.94,0.94,0.94];
cbdata.NewValue.BackgroundColor = 'g';
eventTag = source.Tag;

handleParts = getHandle(mControls,eventTag);
oldHandle = mPlots.Analysis.(eventTag).Features.([handleParts{1},handleParts{2}]);
newHandle = mPlots.Analysis.(eventTag).Features.([handleParts{1},handleParts{2}]);
newMode = handleParts{3};
newFeatureName = [handleParts{1},handleParts{2}];
set(oldHandle,'ButtonDownFcn','')
set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,newMode,mAxes,mPlots,mControls,mParams})
% manipulateFeature(oldHandle,newHandle,newMode,newFeatureName)
% fprintf(['Old: ' handleParts{1} '/' handleParts{2} '/' cbdata.OldValue.String '\n'])
% fprintf(['New: ' handleParts{1} '/' handleParts{2} '/' handleParts{3} '\n'])
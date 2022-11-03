function []=selectFeatureCallback(source,cbdata,mAxes,mPlots,mControls,mParams)

% Perform specific actions when a specific feature is selected

cbdata.OldValue.BackgroundColor = [0.94,0.94,0.94];
cbdata.NewValue.BackgroundColor = 'g';
eventTag = source.Tag;

handleParts = getHandle(mControls,eventTag);
if strcmp(cbdata.OldValue.String,'Peak') == 1
    oldFeature = 'Max';
elseif strcmp(cbdata.OldValue.String,'Trough') == 1
    oldFeature = 'Min';
elseif strcmp(cbdata.OldValue.String,'Foot') == 1
    oldFeature = 'Foot';
else
    oldFeature = cbdata.OldValue.String;
end
oldHandle = mPlots.Analysis.(eventTag).Features.([handleParts{1},oldFeature]);
newHandle = mPlots.Analysis.(eventTag).Features.([handleParts{1},handleParts{2}]);
newFeatureName = [handleParts{1},handleParts{2}];
set(oldHandle,'ButtonDownFcn','')
set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,mAxes,mPlots,mControls,mParams})
% manipulateFeature(oldHandle,newHandle,newMode,newFeatureName)
% fprintf(['Old: ' handleParts{1} '/' oldFeature '/' handleParts{3} '\n'])
% fprintf(['New: ' handleParts{1} '/' handleParts{2} '/' handleParts{3} '\n'])

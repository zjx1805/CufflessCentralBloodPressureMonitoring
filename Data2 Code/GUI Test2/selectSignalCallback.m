function []=selectSignalCallback(source,cbdata,mAxes,mPlots,mControls,mParams)

% Perform specific action when a specific signal is selected

cbdata.OldValue.BackgroundColor = [0.94,0.94,0.94];
cbdata.NewValue.BackgroundColor = 'g';
eventTag = source.Tag;
oldFeature = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
if strcmp(oldFeature,'Peak') == 1
    oldFeature = 'Max';
elseif strcmp(oldFeature,'Trough') == 1
    oldFeature = 'Min';
end

if strcmp(source.SelectedObject.String,'None') == 1
    handleParts = getHandle(mControls,eventTag);
    %% Feature Panel
    mControls.Analysis.(eventTag).FeatureNone.Enable = 'on';
    mControls.Analysis.(eventTag).FeatureNone.BackgroundColor = 'g';
    mControls.Analysis.(eventTag).FeatureNone.Value = 1;
    mControls.Analysis.(eventTag).Peak.Enable = 'off';
    mControls.Analysis.(eventTag).Peak.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Trough.Enable = 'off';
    mControls.Analysis.(eventTag).Trough.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Foot.Enable = 'off';
    mControls.Analysis.(eventTag).Foot.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Hwave.Enable = 'off';
    mControls.Analysis.(eventTag).Hwave.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Iwave.Enable = 'off';
    mControls.Analysis.(eventTag).Iwave.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Jwave.Enable = 'off';
    mControls.Analysis.(eventTag).Jwave.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Kwave.Enable = 'off';
    mControls.Analysis.(eventTag).Kwave.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Lwave.Enable = 'off';
    mControls.Analysis.(eventTag).Lwave.BackgroundColor = [0.94,0.94,0.94];
    
    handlePartsAfter = {'None','None'};
    handlePartsBefore = {cbdata.OldValue.String,handleParts{2}};
else
    %% Feature Panel
    mControls.Analysis.(eventTag).FeatureNone.Enable = 'off';
    mControls.Analysis.(eventTag).FeatureNone.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).FeatureNone.Value = 0;
    allFeatures = mControls.Analysis.(eventTag).FeatureButtonGroup.Children;
    for ii = 1:length(allFeatures)
        featureHandle = allFeatures(ii);
        featureHandle.Enable = 'off';
        featureHandle.BackgroundColor = [0.94,0.94,0.94];
    end
    if strcmp(cbdata.NewValue.String,'BP') == 1
        mControls.Analysis.(eventTag).Peak.Enable = 'on';
        mControls.Analysis.(eventTag).Peak.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Peak.BackgroundColor = 'g';
        mControls.Analysis.(eventTag).Trough.Enable = 'on';
        mControls.Analysis.(eventTag).Lwave.Enable = 'off';
    elseif strcmp(cbdata.NewValue.String,'ECG') == 1
        mControls.Analysis.(eventTag).Peak.Enable = 'on';
        mControls.Analysis.(eventTag).Peak.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Peak.BackgroundColor = 'g';
    elseif contains(cbdata.NewValue.String,'BCG') == 1
        mControls.Analysis.(eventTag).Hwave.Enable = 'on';
        mControls.Analysis.(eventTag).Hwave.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Hwave.BackgroundColor = 'g';
        mControls.Analysis.(eventTag).Foot.Enable = 'on';
        mControls.Analysis.(eventTag).Iwave.Enable = 'on';
        mControls.Analysis.(eventTag).Jwave.Enable = 'on';
        mControls.Analysis.(eventTag).Kwave.Enable = 'on';
        mControls.Analysis.(eventTag).Lwave.Enable = 'on';
    elseif contains(cbdata.NewValue.String,'PPG') == 1
        mControls.Analysis.(eventTag).Peak.Enable = 'on';
        mControls.Analysis.(eventTag).Peak.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Peak.BackgroundColor = 'g';
        mControls.Analysis.(eventTag).Trough.Enable = 'on';
        mControls.Analysis.(eventTag).Foot.Enable = 'on';
    end
    if strcmp(cbdata.OldValue.String,'None') == 1
        handleParts = getHandle(mControls,eventTag);
        handlePartsBefore = {'None','None'};
        handlePartsAfter = handleParts;
    else
        handleParts = getHandle(mControls,eventTag);
        handlePartsBefore = {cbdata.OldValue.String,oldFeature};
        handlePartsAfter = handleParts;
    end
end


if strcmp(handlePartsBefore{1},'None') == 1
    newHandle = mPlots.Analysis.(eventTag).Features.([handlePartsAfter{1},handlePartsAfter{2}]);
    newFeatureName = [handlePartsAfter{1},handlePartsAfter{2}];
    set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,mAxes,mPlots,mControls,mParams})
elseif strcmp(handlePartsAfter{1},'None') == 1
    oldHandle = mPlots.Analysis.(eventTag).Features.([handlePartsBefore{1},handlePartsBefore{2}]);
    set(oldHandle,'ButtonDownFcn','')
else
    oldHandle = mPlots.Analysis.(eventTag).Features.([handlePartsBefore{1},handlePartsBefore{2}]);
    newHandle = mPlots.Analysis.(eventTag).Features.([handlePartsAfter{1},handlePartsAfter{2}]);
    newFeatureName = [handlePartsAfter{1},handlePartsAfter{2}];
    set(oldHandle,'ButtonDownFcn','')
    set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,mAxes,mPlots,mControls,mParams})
end


% fprintf(['Old: ' handlePartsBefore{1} '/' handlePartsBefore{2} '\n'])
% fprintf(['New: ' handlePartsAfter{1} '/' handlePartsAfter{2} '\n'])
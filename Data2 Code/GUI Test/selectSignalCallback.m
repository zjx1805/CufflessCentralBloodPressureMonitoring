function []=selectSignalCallback(source,cbdata,mAxes,mPlots,mControls,mParams)

% Perform specific action when a specific signal is selected

cbdata.OldValue.BackgroundColor = [0.94,0.94,0.94];
cbdata.NewValue.BackgroundColor = 'g';
eventTag = source.Tag;

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
    %% Mode Panel
    mControls.Analysis.(eventTag).ModeNone.Enable = 'on';
    mControls.Analysis.(eventTag).ModeNone.BackgroundColor = 'g';
    mControls.Analysis.(eventTag).ModeNone.Value = 1;
    mControls.Analysis.(eventTag).Remove.Enable = 'off';
    mControls.Analysis.(eventTag).Remove.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Update.Enable = 'off';
    mControls.Analysis.(eventTag).Update.BackgroundColor = [0.94,0.94,0.94];
    mControls.Analysis.(eventTag).Move.Enable = 'off';
    mControls.Analysis.(eventTag).Move.BackgroundColor = [0.94,0.94,0.94];
    %%
    
    handlePartsAfter = {'None','None','None'};
    handlePartsBefore = {cbdata.OldValue.String,handleParts{2},handleParts{3}};
else
    if strcmp(cbdata.OldValue.String,'None') == 1
        %% Feature Panel
        mControls.Analysis.(eventTag).FeatureNone.Enable = 'off';
        mControls.Analysis.(eventTag).FeatureNone.BackgroundColor = [0.94,0.94,0.94];
        mControls.Analysis.(eventTag).FeatureNone.Value = 0;
        mControls.Analysis.(eventTag).Peak.Enable = 'on';
        mControls.Analysis.(eventTag).Peak.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Peak.BackgroundColor = 'g';
        mControls.Analysis.(eventTag).Trough.Enable = 'on';
        mControls.Analysis.(eventTag).Foot.Enable = 'on';
        %% Mode Panel
        mControls.Analysis.(eventTag).ModeNone.Enable = 'off';
        mControls.Analysis.(eventTag).ModeNone.BackgroundColor = [0.94,0.94,0.94];
        mControls.Analysis.(eventTag).ModeNone.Value = 0;
        mControls.Analysis.(eventTag).Remove.Enable = 'on';
        mControls.Analysis.(eventTag).Remove.Value = 1; % To make sure at least one button in the button group is activated
        mControls.Analysis.(eventTag).Remove.BackgroundColor = 'g';
        mControls.Analysis.(eventTag).Update.Enable = 'on';
        mControls.Analysis.(eventTag).Move.Enable = 'on';
        %%
        handleParts = getHandle(mControls,eventTag);
        handlePartsBefore = {'None','None','None'};
        handlePartsAfter = handleParts;
    else
        handleParts = getHandle(mControls,eventTag);
        handlePartsBefore = {cbdata.OldValue.String,handleParts{2},handleParts{3}};
        handlePartsAfter = handleParts;
    end
end



if strcmp(handlePartsBefore{2},handlePartsAfter{2}) == 1
    oldHandle = mPlots.Analysis.(eventTag).Features.([handlePartsBefore{1},handlePartsBefore{2}]);
    newHandle = mPlots.Analysis.(eventTag).Features.([handlePartsAfter{1},handlePartsAfter{2}]);
    newMode = handlePartsAfter{3};
    newFeatureName = [handlePartsAfter{1},handlePartsAfter{2}];
%     newFeatureName
    set(oldHandle,'ButtonDownFcn','')
    set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,newMode,mAxes,mPlots,mControls,mParams})
elseif strcmp(handlePartsBefore{1},'None') == 1
    newHandle = mPlots.Analysis.(eventTag).Features.([handlePartsAfter{1},handlePartsAfter{2}]);
    newMode = handlePartsAfter{3};
    newFeatureName = [handlePartsAfter{1},handlePartsAfter{2}];
    set(newHandle,'ButtonDownFcn',{@featureMode,newFeatureName,newMode,mAxes,mPlots,mControls,mParams})
elseif strcmp(handlePartsAfter{1},'None') == 1
    oldHandle = mPlots.Analysis.(eventTag).Features.([handlePartsBefore{1},handlePartsBefore{2}]);
    set(oldHandle,'ButtonDownFcn','')
end


% manipulateFeature(oldHandle,newHandle,newMode,newFeatureName)
% fprintf(['Old: ' handlePartsBefore{1} '/' handlePartsBefore{2} '/' handlePartsBefore{3} '\n'])
% fprintf(['New: ' handlePartsAfter{1} '/' handlePartsAfter{2} '/' handlePartsAfter{3} '\n'])
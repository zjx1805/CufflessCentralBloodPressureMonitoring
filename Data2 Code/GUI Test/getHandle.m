function [handleParts]=getHandle(mControls,eventTag)

% Returns a cell array, indicating currently selected signal, feature and
% mode

signalSelected = mControls.Analysis.(eventTag).SignalButtonGroup.SelectedObject.String;
featureSelected = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
modeSelected = mControls.Analysis.(eventTag).ModeButtonGroup.SelectedObject.String;

if strcmp(featureSelected,'Peak') == 1
    feature = 'Max';
elseif strcmp(featureSelected,'Trough') == 1
    feature = 'Min';
elseif strcmp(featureSelected,'Foot') == 1
    feature = 'Foot';
else
    feature = '';
end

handleParts = {signalSelected,feature,modeSelected};
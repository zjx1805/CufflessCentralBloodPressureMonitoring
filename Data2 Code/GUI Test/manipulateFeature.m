
function []=manipulateFeature(oldHandle,newHandle,newAction,newFeatureName)
% Deprecated!
% function []=manipulateFeature(mPlots,mControls,eventTag)

% signalSelected = mControls.Analysis.(eventTag).SignalButtonGroup.SelectedObject.String;
% featureSelected = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
% actionSelected = mControls.Analysis.(eventTag).ActionButtonGroup.SelectedObject.String;
% featureNames = fieldnames(mPlots.Analysis.(eventTag).Features);
% if strcmp(signalSelected,'None') == 1
%     for ii = 1:length(featureNames)
%         featureName = featureNames{ii};
%         set(mPlots.Analysis.(eventTag).Features.(featureName),'ButtonDownFcn','');
%     end
% else
%     
%     if strcmp(featureSelected,'Peak') == 1
%         feature = 'Max';
%     elseif strcmp(featureSelected,'Trough') == 1
%         feature = 'Min';
%     elseif strcmp(featureSelected,'Foot') == 1
%         feature = 'Foot';
%     end
%     featureName = [signalSelected,feature];
%     actionName = actionSelected;
%     set(mPlots.Analysis.(eventTag).Features.(featureName),'ButtonDownFcn',{@featureAction,mPlots,featureName,actionName});
% end
% fprintf(['Selected signal: ' signalSelected '. Selected feature: ' featureSelected '. Selected action: ' actionSelected '\n'])
set(oldHandle,'ButtonDownFcn','')
set(newHandle,'ButtonDownFcn',{@featureAction,mPlots,newFeatureName,newAction})
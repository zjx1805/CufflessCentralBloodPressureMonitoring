function []=customParamEditCallback(source,cbdata,mPlots)

% Deals with custom parameters and save them in the figure application data

currentValue = str2num(source.String);
eventTag = source.Parent.Parent.Tag; % uitab's tag
signalParam = source.Tag;
defaultParams = getappdata(mPlots.Analysis.(eventTag).Parent,'defaultParams');
customParams = getappdata(mPlots.Analysis.(eventTag).Parent,'customParams');
defaultValue = defaultParams(signalParam);
fprintf(['Default Value is ' num2str(defaultValue) '\n'])
if all(currentValue == defaultValue)
    fprintf('They are the same!\n')
    source.ForegroundColor = 'k';
else
    fprintf('They are different!\n')
    source.ForegroundColor = 'r';
end
customParams(signalParam) = currentValue;
setappdata(mPlots.Analysis.(eventTag).Parent,'customParams',customParams)
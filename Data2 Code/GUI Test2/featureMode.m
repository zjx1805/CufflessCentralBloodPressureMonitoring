function []=featureMode(source,cbdata,featureName,mAxes,mPlots,mControls,mParams)

% Execute specific operations when a certain mode is chosen 

fs = mParams.Constant.fs;
SignalCode = mParams.Constant.SignalCode;
eventTag = source.Tag;
% featureName

allShades = findobj(mPlots.Analysis.(eventTag).Parent,'Tag','Shade');
delete(allShades)
cP = get(gca,'CurrentPoint');
featureXData = getappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc']);
featureYData = getappdata(mPlots.Analysis.(eventTag).Parent,featureName);
loc = find(abs((featureXData-1)/fs-cP(1,1)) == min(abs((featureXData-1)/fs-cP(1,1))));
locsToDelete = loc;
setappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete',locsToDelete)
%     (featureXData(loc)-1)/fs
%     fprintf([featureName ' @ ' num2str((featureXData(loc)-1)/fs) ' sec has been marked for deletion!\n'])
%     featureXData(loc)=[];featureYData(loc)=[];
%     setappdata(mPlots.Analysis.(eventTag).Parent,[featureName 'Loc'],featureXData);
%     setappdata(mPlots.Analysis.(eventTag).Parent,featureName,featureYData);
%     fprintf([featureName ' now have ' num2str(length(featureXData)) ' data points\n'])
srcloc = find(abs((source.XData)-cP(1,1)) == min(abs((source.XData)-cP(1,1))));
source.XData(srcloc)=[];source.YData(srcloc)=[];
entryCode = SignalCode(mControls.Analysis.(eventTag).SignalButtonGroup.SelectedObject.String);
setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
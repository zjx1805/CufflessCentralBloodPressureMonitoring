function []=selectActionCallback(source,cbdata,mAxes,mPlots,mControls,mParams)

% Perfom specific actions when a specific action button is selected

actionName = source.String;
eventTag = source.Parent.Tag;

fs = mParams.Constant.fs;
interventionLength = getappdata(mPlots.Analysis.(eventTag).Parent,'interventionLength');
startIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'startIdx');
currentWindowStartIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowStartIdx');
currentWindowEndIdx = getappdata(mPlots.Analysis.(eventTag).Parent,'currentWindowEndIdx');
SignalCode = mParams.Constant.SignalCode;
signalName = mControls.Analysis.(eventTag).SignalButtonGroup.SelectedObject.String;
featureSelected = mControls.Analysis.(eventTag).FeatureButtonGroup.SelectedObject.String;
if strcmp(featureSelected,'Peak') == 1
    featureName = 'Max';
elseif strcmp(featureSelected,'Trough') == 1
    featureName = 'Min';
elseif strcmp(featureSelected,'Foot') == 1
    featureName = 'Foot';
else
    featureName = featureSelected;
end
if strcmp(actionName,'Remove Features On Screen') == 1
    allShades = findobj(mPlots.Analysis.(eventTag).Parent,'Tag','Shade');
    delete(allShades)
    featureLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName featureName 'Loc']);
    feature = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName featureName]);
    mask = find(featureLoc>startIdx+currentWindowStartIdx-1 & featureLoc<startIdx+currentWindowEndIdx-1);
    locsToDelete = mask;
    setappdata(mPlots.Analysis.(eventTag).Parent,'locsToDelete',locsToDelete)
%     featureLoc(mask) = [];
%     feature(mask) = [];
%     setappdata(mPlots.Analysis.(eventTag).Parent,[signalName featureName 'Loc'],featureLoc);
%     setappdata(mPlots.Analysis.(eventTag).Parent,[signalName featureName],feature);
    set(mPlots.Analysis.(eventTag).Features.([signalName featureName]),'XData',NaN,'YData',NaN)
    fprintf([num2str(sum(double(mask)==1)) ' ' signalName featureName ' haven been removed!\n'])
    entryCode = SignalCode(signalName);
    setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
    analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
elseif strcmp(actionName,'Update Features On Screen') == 1
    allShades = findobj(mPlots.Analysis.(eventTag).Parent,'Tag','Shade');
    delete(allShades)
    signal = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName 'sig']);
%     isForBCG = false;
%     findCandidateFeature(signal,signalName,isForBCG,eventTag,mPlots,mParams)
    entryCode = SignalCode(signalName);
    setappdata(mPlots.Analysis.(eventTag).Parent,'entryCode',entryCode)
    setappdata(mPlots.Analysis.(eventTag).Parent,'updateButtonPushed',1)
    analyze(entryCode,eventTag,mAxes,mPlots,mControls,mParams)
elseif strcmp(actionName,'Go To SIGS Window') == 1
    allShades = findobj(mPlots.Analysis.(eventTag).Parent,'Tag','Shade');
    delete(allShades)
    SIGSNamesIdx = mControls.Analysis.(eventTag).SIGSNamesPopup.Value;
    SIGSNames = mControls.Analysis.(eventTag).SIGSNamesPopup.String;
    SIGSName = SIGSNames{SIGSNamesIdx};
    BPNamesIdx = mControls.Analysis.(eventTag).BPNamesPopup.Value;
    BPNames = mControls.Analysis.(eventTag).BPNamesPopup.String;
    BPName = BPNames{BPNamesIdx};
    referenceSignalIdx = mControls.Analysis.(eventTag).ReferenceSignalPopup.Value;
    referenceSignalNames = mControls.Analysis.(eventTag).ReferenceSignalPopup.String;
    referenceSignalName = referenceSignalNames{referenceSignalIdx};
    propertyNamesIdx = mControls.Analysis.(eventTag).PropertyNamesPopup.Value;
    propertyNames = mControls.Analysis.(eventTag).PropertyNamesPopup.String;
    propertyName = propertyNames{propertyNamesIdx};
    SIGSWindow = getappdata(mPlots.Analysis.(eventTag).Parent,[SIGSName,BPName,signalName,propertyName,'Window']);
    if any(isnan(SIGSWindow))
        fprintf([referenceSignalName '(' propertyName ') does not have enough detected features!\n'])
    else
        featureStartIdx = SIGSWindow(1); featureEndIdx = SIGSWindow(2);
        featureMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[referenceSignalName,'JWaveLoc']);
        featureSeg = featureMaxLoc(featureStartIdx:featureEndIdx);
        featureStartLocs = featureSeg(~isnan(featureSeg));
        featureValidStartLoc = featureStartLocs(1); featureValidEndLoc = featureStartLocs(end);
        startTime = (featureValidStartLoc-1)/fs; endTime = (featureValidEndLoc-1)/fs; duration = endTime-startTime;
        
        panValue = mParams.Constant.MaxPanValue; panLoc = (panValue-mParams.Constant.MinPanValue)/(mParams.Constant.MaxPanValue-mParams.Constant.MinPanValue);
        hscrollValue = featureValidStartLoc-round((panValue*fs-duration*fs)/2);
        hscrollLoc = ((hscrollValue-1)/fs-startIdx/fs)*fs/(interventionLength-panValue*fs-1);
        if hscrollLoc > 1
            hscrollLoc = 1;
        elseif hscrollLoc < 0 
            hscrollLoc = 0;
        end
        mControls.Analysis.(eventTag).hScrollSlider.Value = hscrollLoc;
        mControls.Analysis.(eventTag).hPanSlider.Value = panLoc;
        scrollbarCallback(mControls.Analysis.(eventTag).hScrollSlider,[],mAxes,mPlots,mControls,mParams) % mimic the user input
        BCGsigYlim = mAxes.Analysis.(eventTag).(signalName).YLim;
        mPlots.Analysis.(eventTag).BCGShade = rectangle(mAxes.Analysis.(eventTag).(signalName),...
            'Position',[max(0,startTime-0.1),BCGsigYlim(1),duration+0.2,BCGsigYlim(2)-BCGsigYlim(1)],'FaceColor',[[100,100,100]/256,0.5],'EdgeColor','none','Tag','Shade');
        uistack(mPlots.Analysis.(eventTag).BCGShade,'bottom')
    end
elseif strcmp(actionName,'Go To Feature Window') == 1
    if contains(signalName,'PPG') == 1
        allShades = findobj(mPlots.Analysis.(eventTag).Parent,'Tag','Shade');
        delete(allShades)
        referenceSignalIdx = mControls.Analysis.(eventTag).ReferenceSignalPopup.Value;
        referenceSignalNames = mControls.Analysis.(eventTag).ReferenceSignalPopup.String;
        referenceSignalName = referenceSignalNames{referenceSignalIdx};
        BPNamesIdx = mControls.Analysis.(eventTag).BPNamesPopup.Value;
        BPNames = mControls.Analysis.(eventTag).BPNamesPopup.String;
        BPName = BPNames{BPNamesIdx};
        PPGsigWindow = getappdata(mPlots.Analysis.(eventTag).Parent,[BPName,signalName,referenceSignalName,'Window']);
        if any(isnan(PPGsigWindow))
            fprintf([signalName,referenceSignalName,' does not have enough detected features!\n'])
        else
            featureStartIdx = PPGsigWindow(1); featureEndIdx = PPGsigWindow(2);
            featureMaxLoc = getappdata(mPlots.Analysis.(eventTag).Parent,[signalName,'MaxLoc']);
            featureSeg = featureMaxLoc(featureStartIdx:featureEndIdx);
            featureStartLocs = featureSeg(~isnan(featureSeg));
            featureValidStartLoc = featureStartLocs(1); featureValidEndLoc = featureStartLocs(end);
            startTime = (featureValidStartLoc-1)/fs; endTime = (featureValidEndLoc-1)/fs; duration = endTime-startTime;
%             [startTime,endTime]
            
            panValue = mParams.Constant.MaxPanValue; panLoc = (panValue-mParams.Constant.MinPanValue)/(mParams.Constant.MaxPanValue-mParams.Constant.MinPanValue);
            hscrollValue = featureValidStartLoc-round((panValue*fs-duration*fs)/2);
            hscrollLoc = max(0,((hscrollValue-1)/fs-startIdx/fs)*fs/(interventionLength-panValue*fs-1));
            if hscrollLoc > 1
                hscrollLoc = 1;
            end
            mControls.Analysis.(eventTag).hScrollSlider.Value = hscrollLoc;
            mControls.Analysis.(eventTag).hPanSlider.Value = panLoc;
            scrollbarCallback(mControls.Analysis.(eventTag).hScrollSlider,[],mAxes,mPlots,mControls,mParams) % mimic the user input
            PPGsigYlim = mAxes.Analysis.(eventTag).(signalName).YLim;
            mPlots.Analysis.(eventTag).([signalName,'Shade']) = rectangle(mAxes.Analysis.(eventTag).(signalName),...
                'Position',[max(0,startTime-0.1),PPGsigYlim(1),duration+0.2,PPGsigYlim(2)-PPGsigYlim(1)],'FaceColor',[[100,100,100]/256,0.5],'EdgeColor','none','Tag','Shade');
            uistack(mPlots.Analysis.(eventTag).([signalName,'Shade']),'bottom')
        end
        
    end
elseif strcmp(actionName,'Refresh Result') == 1
    refreshResult(mAxes,mPlots)
    fprintf('Result changed!\n')
end
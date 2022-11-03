function []=refreshResult(mAxes,mPlots)

BPNames = getappdata(mPlots.Result.Parent,'BPNames');
eventList = getappdata(mPlots.Result.Parent,'eventList');
% PAT = getappdata(mPlots.Result.Parent,'PAT');
PTT = getappdata(mPlots.Result.Parent,'PTT');
SIGS = getappdata(mPlots.Result.Parent,'SIGS');
% legendFontSize=7.5;
for ii = 1:length(BPNames)
    BPName = BPNames{ii};
    if strcmp(BPName,'DP') == 1
        BPCol = 3;
    elseif strcmp(BPName,'PP') == 1
        BPCol = 4;
    end
    
    %%% First Row
    set(mPlots.Result.(BPName).BCGScaleIJInt,'XData',SIGS.IJ.(BPName).BCGScale.Interval.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGScale.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleIJInt,['r=' num2str(SIGS.IJ.(BPName).BCGScale.Interval.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGScale.Interval.data(:,1)'*1000;SIGS.IJ.(BPName).BCGScale.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleIJIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleIJIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristIJInt,'XData',SIGS.IJ.(BPName).BCGWrist.Interval.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGWrist.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristIJInt,['r=' num2str(SIGS.IJ.(BPName).BCGWrist.Interval.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGWrist.Interval.data(:,1)'*1000;SIGS.IJ.(BPName).BCGWrist.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristIJIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristIJIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmIJInt,'XData',SIGS.IJ.(BPName).BCGArm.Interval.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGArm.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmIJInt,['r=' num2str(SIGS.IJ.(BPName).BCGArm.Interval.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGArm.Interval.data(:,1)'*1000;SIGS.IJ.(BPName).BCGArm.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmIJIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmIJIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckIJInt,'XData',SIGS.IJ.(BPName).BCGNeck.Interval.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGNeck.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckIJInt,['r=' num2str(SIGS.IJ.(BPName).BCGNeck.Interval.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGNeck.Interval.data(:,1)'*1000;SIGS.IJ.(BPName).BCGNeck.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckIJIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckIJIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGScaleIJAmp,'XData',SIGS.IJ.(BPName).BCGScale.Amplitude.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGScale.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleIJAmp,['r=' num2str(SIGS.IJ.(BPName).BCGScale.Amplitude.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGScale.Amplitude.data(:,1)'*1000;SIGS.IJ.(BPName).BCGScale.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleIJAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleIJAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristIJAmp,'XData',SIGS.IJ.(BPName).BCGWrist.Amplitude.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGWrist.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristIJAmp,['r=' num2str(SIGS.IJ.(BPName).BCGWrist.Amplitude.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGWrist.Amplitude.data(:,1)'*1000;SIGS.IJ.(BPName).BCGWrist.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristIJAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristIJAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmIJAmp,'XData',SIGS.IJ.(BPName).BCGArm.Amplitude.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGArm.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmIJAmp,['r=' num2str(SIGS.IJ.(BPName).BCGArm.Amplitude.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGArm.Amplitude.data(:,1)'*1000;SIGS.IJ.(BPName).BCGArm.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmIJAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmIJAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckIJAmp,'XData',SIGS.IJ.(BPName).BCGNeck.Amplitude.data(:,1)*1000,'YData',SIGS.IJ.(BPName).BCGNeck.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckIJAmp,['r=' num2str(SIGS.IJ.(BPName).BCGNeck.Amplitude.correlation)])
    newPos = reshape([SIGS.IJ.(BPName).BCGNeck.Amplitude.data(:,1)'*1000;SIGS.IJ.(BPName).BCGNeck.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckIJAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckIJAmpText.String] = eventList{:};
    
    %%% Second Row
    set(mPlots.Result.(BPName).BCGScaleJKInt,'XData',SIGS.JK.(BPName).BCGScale.Interval.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGScale.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleJKInt,['r=' num2str(SIGS.JK.(BPName).BCGScale.Interval.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGScale.Interval.data(:,1)'*1000;SIGS.JK.(BPName).BCGScale.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleJKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleJKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristJKInt,'XData',SIGS.JK.(BPName).BCGWrist.Interval.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGWrist.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristJKInt,['r=' num2str(SIGS.JK.(BPName).BCGWrist.Interval.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGWrist.Interval.data(:,1)'*1000;SIGS.JK.(BPName).BCGWrist.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristJKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristJKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmJKInt,'XData',SIGS.JK.(BPName).BCGArm.Interval.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGArm.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmJKInt,['r=' num2str(SIGS.JK.(BPName).BCGArm.Interval.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGArm.Interval.data(:,1)'*1000;SIGS.JK.(BPName).BCGArm.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmJKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmJKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckJKInt,'XData',SIGS.JK.(BPName).BCGNeck.Interval.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGNeck.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckJKInt,['r=' num2str(SIGS.JK.(BPName).BCGNeck.Interval.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGNeck.Interval.data(:,1)'*1000;SIGS.JK.(BPName).BCGNeck.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckJKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckJKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGScaleJKAmp,'XData',SIGS.JK.(BPName).BCGScale.Amplitude.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGScale.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleJKAmp,['r=' num2str(SIGS.JK.(BPName).BCGScale.Amplitude.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGScale.Amplitude.data(:,1)'*1000;SIGS.JK.(BPName).BCGScale.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleJKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleJKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristJKAmp,'XData',SIGS.JK.(BPName).BCGWrist.Amplitude.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGWrist.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristJKAmp,['r=' num2str(SIGS.JK.(BPName).BCGWrist.Amplitude.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGWrist.Amplitude.data(:,1)'*1000;SIGS.JK.(BPName).BCGWrist.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristJKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristJKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmJKAmp,'XData',SIGS.JK.(BPName).BCGArm.Amplitude.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGArm.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmJKAmp,['r=' num2str(SIGS.JK.(BPName).BCGArm.Amplitude.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGArm.Amplitude.data(:,1)'*1000;SIGS.JK.(BPName).BCGArm.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmJKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmJKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckJKAmp,'XData',SIGS.JK.(BPName).BCGNeck.Amplitude.data(:,1)*1000,'YData',SIGS.JK.(BPName).BCGNeck.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckJKAmp,['r=' num2str(SIGS.JK.(BPName).BCGNeck.Amplitude.correlation)])
    newPos = reshape([SIGS.JK.(BPName).BCGNeck.Amplitude.data(:,1)'*1000;SIGS.JK.(BPName).BCGNeck.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckJKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckJKAmpText.String] = eventList{:};
    
    %%% Third Row
    set(mPlots.Result.(BPName).BCGScaleIKInt,'XData',SIGS.IK.(BPName).BCGScale.Interval.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGScale.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleIKInt,['r=' num2str(SIGS.IK.(BPName).BCGScale.Interval.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGScale.Interval.data(:,1)'*1000;SIGS.IK.(BPName).BCGScale.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleIKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleIKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristIKInt,'XData',SIGS.IK.(BPName).BCGWrist.Interval.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGWrist.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristIKInt,['r=' num2str(SIGS.IK.(BPName).BCGWrist.Interval.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGWrist.Interval.data(:,1)'*1000;SIGS.IK.(BPName).BCGWrist.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristIKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristIKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmIKInt,'XData',SIGS.IK.(BPName).BCGArm.Interval.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGArm.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmIKInt,['r=' num2str(SIGS.IK.(BPName).BCGArm.Interval.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGArm.Interval.data(:,1)'*1000;SIGS.IK.(BPName).BCGArm.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmIKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmIKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckIKInt,'XData',SIGS.IK.(BPName).BCGNeck.Interval.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGNeck.Interval.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckIKInt,['r=' num2str(SIGS.IK.(BPName).BCGNeck.Interval.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGNeck.Interval.data(:,1)'*1000;SIGS.IK.(BPName).BCGNeck.Interval.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckIKIntText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckIKIntText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGScaleIKAmp,'XData',SIGS.IK.(BPName).BCGScale.Amplitude.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGScale.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScaleIKAmp,['r=' num2str(SIGS.IK.(BPName).BCGScale.Amplitude.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGScale.Amplitude.data(:,1)'*1000;SIGS.IK.(BPName).BCGScale.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScaleIKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScaleIKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristIKAmp,'XData',SIGS.IK.(BPName).BCGWrist.Amplitude.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGWrist.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristIKAmp,['r=' num2str(SIGS.IK.(BPName).BCGWrist.Amplitude.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGWrist.Amplitude.data(:,1)'*1000;SIGS.IK.(BPName).BCGWrist.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristIKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristIKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmIKAmp,'XData',SIGS.IK.(BPName).BCGArm.Amplitude.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGArm.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmIKAmp,['r=' num2str(SIGS.IK.(BPName).BCGArm.Amplitude.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGArm.Amplitude.data(:,1)'*1000;SIGS.IK.(BPName).BCGArm.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmIKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmIKAmpText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckIKAmp,'XData',SIGS.IK.(BPName).BCGNeck.Amplitude.data(:,1)*1000,'YData',SIGS.IK.(BPName).BCGNeck.Amplitude.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckIKAmp,['r=' num2str(SIGS.IK.(BPName).BCGNeck.Amplitude.correlation)])
    newPos = reshape([SIGS.IK.(BPName).BCGNeck.Amplitude.data(:,1)'*1000;SIGS.IK.(BPName).BCGNeck.Amplitude.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckIKAmpText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckIKAmpText.String] = eventList{:};
    
    %%% Fourth Row
    set(mPlots.Result.(BPName).BCGScalePTT,'XData',PTT.(BPName).PPGClipBCGScale.data(:,1)*1000,'YData',PTT.(BPName).PPGClipBCGScale.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGScalePTT,['r=' num2str(PTT.(BPName).PPGClipBCGScale.correlation)])
    newPos = reshape([PTT.(BPName).PPGClipBCGScale.data(:,1)'*1000;PTT.(BPName).PPGClipBCGScale.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGScalePTTText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGScalePTTText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGWristPTT,'XData',PTT.(BPName).PPGClipBCGWrist.data(:,1)*1000,'YData',PTT.(BPName).PPGClipBCGWrist.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGWristPTT,['r=' num2str(PTT.(BPName).PPGClipBCGWrist.correlation)])
    newPos = reshape([PTT.(BPName).PPGClipBCGWrist.data(:,1)'*1000;PTT.(BPName).PPGClipBCGWrist.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGWristPTTText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGWristPTTText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGArmPTT,'XData',PTT.(BPName).PPGClipBCGArm.data(:,1)*1000,'YData',PTT.(BPName).PPGClipBCGArm.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGArmPTT,['r=' num2str(PTT.(BPName).PPGClipBCGArm.correlation)])
    newPos = reshape([PTT.(BPName).PPGClipBCGArm.data(:,1)'*1000;PTT.(BPName).PPGClipBCGArm.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGArmPTTText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGArmPTTText.String] = eventList{:};
    
    set(mPlots.Result.(BPName).BCGNeckPTT,'XData',PTT.(BPName).PPGClipBCGNeck.data(:,1)*1000,'YData',PTT.(BPName).PPGClipBCGNeck.data(:,BPCol));
    title(mAxes.Result.(BPName).BCGNeckPTT,['r=' num2str(PTT.(BPName).PPGClipBCGNeck.correlation)])
    newPos = reshape([PTT.(BPName).PPGClipBCGNeck.data(:,1)'*1000;PTT.(BPName).PPGClipBCGNeck.data(:,BPCol)'*1.01],1,[]); newPos = mat2cell(newPos,[1],ones(1,length(eventList))*2);
    [mPlots.Result.(BPName).BCGNeckPTTText.Position] = newPos{:}; [mPlots.Result.(BPName).BCGNeckPTTText.String] = eventList{:};
    
end
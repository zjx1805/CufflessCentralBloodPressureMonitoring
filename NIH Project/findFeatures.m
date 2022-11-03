function [PTT,PAT,Bpoint,interceptLine,interceptPoint,DPinfo,SPinfo,DPfix,SPfix]=findFeatures(timeRange,fs,ECGMaxLoc,PPG,PPGMaxLoc,PPGMinLoc,ICGdzdt,ICGdzdtMaxLoc,BP,BPMaxLoc,BPMinLoc)

PTT=[];PAT=[];Bpoint=[];interceptLine=[];interceptPoint=[];DPfix=[];SPfix=[];DPinfo=[];SPinfo=[];

PeaksInBetween=find(ECGMaxLoc>=timeRange(1) & ECGMaxLoc<=timeRange(2)); % finding the number of ECG peaks (i.e., beats) during the specified time range
PeaksBefore=find(ECGMaxLoc<timeRange(1)); % finding the number of ECG peaks (i.e., beats) before the specified time range
for ii=(1:length(PeaksInBetween)-1)
    ECGcurrentPeakTime=ECGMaxLoc(ii+length(PeaksBefore)); % absolute time of each ECG peak
    ECGcurrentPeakIdx=fix(ECGcurrentPeakTime/(1/fs)+1); % absolute index of each ECG peak, i.e., the location of the peak point in the entire data range. fix() is used to drop the decimal
    
    ECGnextPeakTime=ECGMaxLoc(ii+length(PeaksBefore)+1);
    ECGnextPeakIdx=fix(ECGnextPeakTime/(1/fs)+1);
    % use intersecting tangent method to find the PPG foot between local
    % min/max point of PPG in that beat
    PPGtempStartLocRel=find(PPGMinLoc>=ECGcurrentPeakTime,1);
    PPGtempStartTime=PPGMinLoc(PPGtempStartLocRel);
    if PPGtempStartTime>ECGnextPeakTime
        PPGtempStartLocRel=ECGcurrentPeakIdx+find(PPG(ECGcurrentPeakIdx:ECGnextPeakIdx)==min(PPG(ECGcurrentPeakIdx:ECGnextPeakIdx)),1)-1;
        PPGtempStartIdx=PPGtempStartLocRel;
        PPGtempStartTime=(PPGtempStartIdx-1)*(1/fs);
        fprintf(['PPG min missing between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, using local min at ' num2str(PPGtempStartTime) ' sec instead!\n'])
    else
        if PPGMinLoc(PPGtempStartLocRel+1)<=ECGnextPeakTime
            fprintf(['Multiple PPG min found between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ...
                ' sec, using the first min at ' num2str(PPGtempStartTime) ' sec only!\n'])
        end
        PPGtempStartTime=PPGMinLoc(PPGtempStartLocRel);
        PPGtempStartIdx=fix(PPGtempStartTime/(1/fs)+1);
    end
    
    % If PPG peaks/foots are not found previously by findpeaks(), they are recovered here during the beat-by-beat analysis
    PPGtempEndLocRel=find(PPGMaxLoc>ECGcurrentPeakTime,1);
    PPGtempEndTime=PPGMaxLoc(PPGtempEndLocRel);
    if PPGtempEndTime>ECGnextPeakTime
        PPGtempEndLocRel=ECGcurrentPeakIdx+find(PPG(ECGcurrentPeakIdx:ECGnextPeakIdx)==max(PPG(ECGcurrentPeakIdx:ECGnextPeakIdx)),1)-1;
        PPGtempEndIdx=PPGtempEndLocRel;
        PPGtempEndTime=(PPGtempEndIdx-1)*(1/fs);
        fprintf(['PPG max missing between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, using local max at ' num2str(PPGtempEndTime) ' sec instead!\n'])
    else
        if PPGMaxLoc(PPGtempEndLocRel+1)<=ECGnextPeakTime
            fprintf(['Multiple PPG max found between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ...
                ' sec, using the first max at ' num2str(PPGtempEndTime) ' sec only!\n'])
        end
        PPGtempEndTime=PPGMaxLoc(PPGtempEndLocRel);
        PPGtempEndIdx=fix(PPGtempEndTime/(1/fs)+1);
    end
% Skip this beat for analysis if PPG min is after PPG max point    
    if PPGtempStartIdx>PPGtempEndIdx
        fprintf(['Location of PPG local min is after that of local max between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ...
            ' sec, thus this beat is skipped for analysis!\n'])
        continue
    end
    derTemp=diff(PPG(PPGtempStartIdx:PPGtempEndIdx))/(1/fs);
    maxDerLoc=find(derTemp==max(derTemp));
    maxDerLocAbs=PPGtempStartIdx+maxDerLoc-1; % find the maximum first derivative 
    maxDerTime=(maxDerLocAbs-1)*(1/fs);
    interceptTime=(-PPG(maxDerLocAbs)+PPG(PPGtempStartIdx))/max(derTemp)+maxDerTime; % use intersecting tangent method to find PPG foot
    if interceptTime-ECGcurrentPeakTime<0 % Skip the beat if PAT is negative
        fprintf(['PAT is negative between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, thus this beat is skipped for analysis!\n'])
        continue
    end
    PAT_Append=[interceptTime-ECGcurrentPeakTime,interceptTime,ECGcurrentPeakIdx,PPG(PPGtempEndIdx)];
    interceptLine_Append=[[PPGtempStartTime;interceptTime;maxDerTime;NaN],[PPG(PPGtempStartIdx);PPG(PPGtempStartIdx);PPG(maxDerLocAbs);NaN]];
    interceptPoint_Append=[interceptTime,PPG(PPGtempStartIdx)];

% If ICG dz/dt peaks/foots are not found previously by findpeaks(), they are recovered here during the beat-by-beat analysis 
    ICGtempEndLocRel=find(ICGdzdtMaxLoc>=ECGcurrentPeakTime,1);
    ICGtempEndTime=ICGdzdtMaxLoc(ICGtempEndLocRel);
    if ICGdzdtMaxLoc(ICGtempEndLocRel)>ECGnextPeakTime
        ICGtempEndLocRel=find(ICGdzdt(ECGcurrentPeakIdx:ECGnextPeakIdx)==max(ICGdzdt(ECGcurrentPeakIdx:ECGnextPeakIdx)),1);
        ICGtempEndIdx=ECGcurrentPeakIdx+ICGtempEndLocRel-1;
        ICGtempEndTime=(ICGtempEndIdx-1)*(1/fs);
        fprintf(['ICG dz/dt peak missing between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ...
            ' sec, using local peak at ' num2str(ICGtempEndTime) ' sec instead!\n'])
    else
        if ICGdzdtMaxLoc(ICGtempEndLocRel+1)<=ECGnextPeakTime
            fprintf(['Multiple ICG dz/dt peak found between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ...
                ' sec, using the first peak at ' num2str(ICGtempEndTime) ' sec only!\n'])
        end
        ICGtempEndTime=ICGdzdtMaxLoc(ICGtempEndLocRel);
        ICGtempEndIdx=fix(ICGtempEndTime/(1/fs)+1);
    end
    
    ICGtempStartIdx=ECGcurrentPeakIdx;
    if isempty(find(ICGdzdt(ICGtempStartIdx:ICGtempEndIdx))>0)
        fprintf(['No ICG dz/dt point is above zero between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, thus this beat is skipped for analysis!\n'])
        continue
    end
    zeroCrossingLoc=find(abs(ICGdzdt(ICGtempStartIdx:ICGtempEndIdx))==min(abs(ICGdzdt(ICGtempStartIdx:ICGtempEndIdx))));
    BpointTime=ECGMaxLoc(ii+length(PeaksBefore))+(zeroCrossingLoc-1)*(1/fs);
    BpointIdx=fix(BpointTime/(1/fs)+1);
    Bpoint_Append=[BpointIdx,BpointTime,ICGdzdt(BpointIdx)];
    if interceptTime-BpointTime<0 % Skip the beat for analysis if PTT is negative
        fprintf(['PTT is negative between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, thus this beat is skipped for analysis!\n'])
        continue
    end
    PTT_Append=[interceptTime-BpointTime,interceptTime,ECGcurrentPeakIdx,PPG(PPGtempEndIdx)];
    
% If DP are not found previously by findpeaks(), they are recovered here during the beat-by-beat analysis 
    DPtempTime=BPMinLoc(find(BPMinLoc>=ECGcurrentPeakTime,1));
    if DPtempTime>ECGnextPeakTime
        DPtempLocRel=find(BP(ECGcurrentPeakIdx:ECGnextPeakIdx)==min(BP(ECGcurrentPeakIdx:ECGnextPeakIdx)),1);
        DPtempIdx=ECGcurrentPeakIdx+DPtempLocRel-1;
        DPtempTime=(DPtempIdx-1)*(1/fs);
        DPfix=[DPfix;[DPtempTime,BP(DPtempIdx)]];
        DPinfo_Append=BP(DPtempIdx);
        fprintf(['DP missing between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, using local min BP at ' num2str(DPtempTime) ' sec instead!\n'])
    else
        DPtempIdx=fix(DPtempTime/(1/fs)+1);
        DPinfo_Append=BP(DPtempIdx);
    end
% If SP are not found previously by findpeaks(), they are recovered here during the beat-by-beat analysis 
    SPtempTime=BPMaxLoc(find(BPMaxLoc>=ECGcurrentPeakTime,1));
    if SPtempTime>ECGnextPeakTime
        SPtempLocRel=find(BP(DPtempIdx:ECGnextPeakIdx)==max(BP(DPtempIdx:ECGnextPeakIdx)),1);
        SPtempIdx=DPtempIdx+SPtempLocRel-1;
        SPtempTime=(SPtempIdx-1)*(1/fs);
        SPfix=[SPfix;[SPtempTime,BP(SPtempIdx)]];
        SPinfo_Append=BP(SPtempIdx);
        fprintf(['SP missing between ECG peaks from ' num2str(ECGcurrentPeakTime) ' to ' num2str(ECGnextPeakTime) ' sec, using local max BP at ' num2str(SPtempTime) ' sec instead!\n'])
    else
        SPtempIdx=fix(SPtempTime/(1/fs)+1);
        SPinfo_Append=BP(SPtempIdx);
    end
    
    PAT=[PAT;PAT_Append];
    interceptLine=[interceptLine;interceptLine_Append];
    interceptPoint=[interceptPoint;interceptPoint_Append];
    Bpoint=[Bpoint;Bpoint_Append];
    PTT=[PTT;PTT_Append];
    DPinfo=[DPinfo;DPinfo_Append];
    SPinfo=[SPinfo;SPinfo_Append];
end
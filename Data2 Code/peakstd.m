function [time,value]=peakstd(signal,sigPeakLoc,fs,windowSize,startTime)

time=zeros(size(sigPeakLoc));
peakstd=zeros(size(sigPeakLoc));
for ii=1:length(sigPeakLoc)
    locIdx=fix((sigPeakLoc(ii))*fs);
    stdleft=std(signal(max(1,locIdx-windowSize):locIdx));
    stdright=std(signal(locIdx:min(locIdx+windowSize,length(signal))));
%     peakstd(ii)=stdright;
    peakstd(ii)=min(stdleft,stdright);
%     peakstd(ii)=std(signal(max(1,locIdx-windowSize):min(locIdx+windowSize,length(signal))));
    time(ii)=startTime+sigPeakLoc(ii);
end

value=peakstd;

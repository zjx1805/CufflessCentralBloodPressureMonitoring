function [time,value]=peakstd(signal,sigPeakLoc,windowSize,startTime)

% Determines whether a candidate BPMax/BPMin is within Nexfin calibration
% process

time=zeros(size(sigPeakLoc));
peakstd=zeros(size(sigPeakLoc));
for ii=1:length(sigPeakLoc)
    locIdx=sigPeakLoc(ii);
    stdleft=std(signal(max(1,locIdx-windowSize):locIdx));
    stdright=std(signal(locIdx:min(locIdx+windowSize,length(signal))));
    peakstd(ii)=min(stdleft,stdright);
    time(ii)=startTime+sigPeakLoc(ii);
end

value=peakstd;

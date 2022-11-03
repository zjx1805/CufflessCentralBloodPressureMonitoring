function [sig]=expandSignal(sig,mask,map,totalLength)

% totalLength = length(BPMaxLoc) for test20170710
if ~any(mask)
    sig=NaN(totalLength,1);
else
    sig=sig(mask==1);
    sigTemp=NaN(max(map),1);
%     length(map)
%     length(sig)
    sigTemp(map,1)=sig;
    sig=sigTemp;
    sig(end+1:totalLength)=NaN;
end
function [sig]=expandSignal(sig,mask,map,totalLength)

if ~any(mask)
    sig=NaN(totalLength,1);
else
    sig=sig(mask==1);
    sigTemp=NaN(max(map),1);
    sigTemp(map,1)=sig;
    sig=sigTemp;
    sig(end+1:totalLength)=NaN;
end
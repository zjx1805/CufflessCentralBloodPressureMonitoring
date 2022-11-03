clear all;close all;clc
load temp

fs=1000;
figure(1);maximize(gcf);
subplot(5,1,1)
h = plot(timesig,PPGfingersig,'b-');grid on;grid minor;hold on

[PPGfingerMax,PPGfingerMaxLoc]=findpeaks(PPGfingersig,'MinPeakHeight',0,'MinPeakDistance',400,'MinPeakProminence',0.1);
[PPGfingerMin,PPGfingerMinLoc]=findpeaks(-PPGfingersig,'MinPeakHeight',0,'MinPeakDistance',400,'MinPeakProminence',0.1);
PPGfingerMaxLoc = PPGfingerMaxLoc+(startIdx-1);
PPGfingerMinLoc = PPGfingerMinLoc+(startIdx-1);
PPGfingerMin = -PPGfingerMin;

h1 = plot((PPGfingerMaxLoc-1)/fs,PPGfingerMax,'go');
h2 = plot((PPGfingerMinLoc-1)/fs,PPGfingerMin,'ro');

for ii = 1:length(PPGfingerMaxLoc)
    if isnan(PPGfingerMaxLoc(ii)) || isnan(PPGfingerMinLoc(ii))
        continue
    else
        PPGfingersigDRange = (PPGfingerMinLoc(ii):PPGfingerMaxLoc(ii))-(startIdx-1);
%         [length(PPGsig),PPGsigDRange(end)]
        PPGfingersigD = diff5(PPGfingersig(PPGfingersigDRange),1,1/fs);
        [maxD,maxDLoc] = max(PPGfingersigD);
        maxDList(ii) = maxD;
        maxDLocList(ii) = maxDLoc;
        xi = round((PPGfingerMin(ii)-PPGfingersig(PPGfingerMinLoc(ii)+maxDLoc-1-(startIdx-1)))/(maxD)*fs)+(PPGfingerMinLoc(ii)+(maxDLoc-1));
%         xi = (PPGfingerMin(ii)-PPGfingersig(PPGfingerMinLoc(ii)+maxDLoc-1-(startIdx-1)))/(maxD)+(PPGfingerMinLoc(ii)+(maxDLoc-1)-1)/fs;
        yi = PPGfingerMin(ii);
        PPGfingersigFoot(ii,1:2) = [xi,yi];
        plot((maxDLoc-1+PPGfingerMinLoc(ii)-1)/fs,PPGfingersig(maxDLoc-1+PPGfingerMinLoc(ii)-(startIdx-1)),'rx')
%         line([xi,xi+0.1],[yi,yi+0.1*maxD])
    end
end
h3 = plot((PPGfingersigFoot(:,1)-1)/fs,PPGfingersigFoot(:,2),'b^');
% h3 = plot(PPGfingersigFoot(:,1),PPGfingersigFoot(:,2),'b^');
%%
nn = 3576239+78-(startIdx-1);
(PPGfingersig(nn-2)-8*PPGfingersig(nn-1)+8*PPGfingersig(nn+1)-PPGfingersig(nn+2))/12*1000
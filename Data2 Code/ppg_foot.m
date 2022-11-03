%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates peaks and feet of the signal using windows
% [feet_idx, pks_idx] =  ppg_foot(sig, fs, foot_option)
%
% Inputs:
% 1. sig - signal for which feet and peaks need to be estimated
% 2. fs - Sampling rate
% 3. foot_option - the method of foot detection - 'tan' (tanline), 'min' (minima) or 'maxdd' (maximum double derivative)
% 'tan' (tanline) is generally the most robust method and the one I use most
%
% Outputs: 
% 1. feet_idx - sample numbers at which feet were detected
% 2. pks_idx - sample numbers at which peaks were detected
%
% Approach:
%
%
% Created by - Keerthana Natarajan
% Created on - 02/11/2016
%
% Version - 1.00
% 
% 
% 
%
%
% Modifications to make: Account for more variation in heart rate, What if there is noise in the signal?
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [feet_idx, pks_idx] =  ppg_foot(sig, fs, foot_option)
%% feet_idx and pks_idx are the sample numbers of the feet and peaks respectively
%% sig is the signal for which detection is to be done
%% fs is the sampling frequency
%% foot_option is the method of foot detection - 'tan', 'min' or 'maxdd' (maxdd is the maximum double derivative)
%% 'tan' (tanline) is generally the most robust method and the one I use most
%%


maxhr = round(Calc_HR(sig, fs))+5;
min_rr = (60/maxhr)*fs;

signorm = sig/(max(sig) - min(sig));
signorm = signorm - mean(signorm);

[~, vlocs] = findpeaks(-signorm, fs, 'MinPeakHeight', 0.05, 'MinPeakDistance', 0.4, 'MinPeakProminence', 0.05);
if isempty(vlocs)
    [~, vlocs] = findpeaks(-signorm, fs, 'MinPeakHeight', 0.05, 'MinPeakDistance', 0.4, 'MinPeakProminence', 0.05);
end
[~, plocs] = findpeaks(signorm, fs, 'MinPeakHeight', 0.05, 'MinPeakDistance', 0.4, 'MinPeakProminence', 0.05);
% remove bad detections
plocs(plocs < min(vlocs)) = [];
vlocs(vlocs > max(plocs)) = [];
for n = length(plocs):-1:1
    if min(abs(plocs(n) - vlocs)) > 0.7 || min(abs(plocs(n) - vlocs)) < 0.05
        plocs(n) = [];
    end
end
vlocs(vlocs > max(plocs)) = [];
for n = length(vlocs):-1:1
    if min(abs(plocs - vlocs(n))) > 0.7 || min(abs(plocs - vlocs(n))) < 0.05
        vlocs(n) = [];
    end
end
plocs(plocs < min(vlocs)) = [];

vals_idx = round(vlocs*fs);sig_vals = signorm(vals_idx);
pks_idx = round(plocs*fs);sig_pks = signorm(pks_idx);

t = [1:length(sig)]/fs;
% [sig_pks, pks_idx, sig_vals, vals_idx] = sigpeak(sig, fs, min_rr);
sig_pks1 = sig_pks;sig_vals1 = sig_vals;pks_idx1=pks_idx;vals_idx1 = vals_idx; %#ok<NASGU>
dpeaks = diff(pks_idx);
pks_idx(dpeaks < 0) = [];
sig_pks(dpeaks < 0) = [];
dvals = diff(vals_idx);
vals_idx(dvals < 0) = [];
sig_vals(dvals < 0) = [];
    
vals_idx(vals_idx < 0) = [];
pks_idx(pks_idx > length(sig)-0) = [];
sig_pks(pks_idx < min(vals_idx)) = [];
pks_idx(pks_idx < min(vals_idx)) = [];
sig_vals(vals_idx > max(pks_idx)) = [];
vals_idx(vals_idx > max(pks_idx)) = [];

for n = length(vals_idx):-1:1
    temp = pks_idx - vals_idx(n);
    temp(temp<0) = 9999;
    [temp, ~] = min(temp);
    
    temp1 = vals_idx - vals_idx(n);
    temp1(temp1<=0) = 9999;
    [temp1, ~] = min(temp1);
    
    if isempty(temp) || isempty(temp1) || (temp > min_rr) || (temp1 < temp)
        vals_idx(n) = [];
        sig_vals(n) = [];
    end
end
for n = length(pks_idx):-1:1
    temp = pks_idx(n) - vals_idx;
    temp(temp<0) = 9999;
    [temp, ~] = min(temp);
    
    temp1 = pks_idx(n) - pks_idx;
    temp1(temp1<=0) = 9999;
    [temp1, ~] = min(temp1);
    
    if isempty(temp) || isempty(temp1) || (temp > min_rr) || (temp1 < temp)
        pks_idx(n) = [];
        sig_pks(n) = [];
    end
end

if length(pks_idx) ~= length(vals_idx)
    keyboard;
end

if strcmpi(foot_option,'tan')
    tan_foot = nan(size(vals_idx));
    for n = 1:length(vals_idx)
        if vals_idx(n) - 0 < 1
            temp_start = 1;
            temp_end = pks_idx(n) + 0;
        elseif pks_idx(n) + 0 > length(sig)
            temp_end = length(sig);
            temp_start = vals_idx(n) - 0;
        else
            temp_start = vals_idx(n) - 0;
            temp_end = pks_idx(n) + 0;
        end
        sig_seg = sig(temp_start:temp_end);
        t_seg = t(temp_start:temp_end);
        
        sigd = diff5(sig_seg, 1);
        td = diff5(t_seg, 1);
        [~, idx] = max(sigd);
        dy = sigd./td;
        
        k = 0;Rcorr = 1;
        while ((k < min(idx, length(sigd)-idx)-1) && (Rcorr >= 0.999))
            k = k+1;
            tang = (t_seg(idx-k:idx+k)-t_seg(idx))*nanmean(dy(idx-k:idx+k))+sig_seg(idx);
            R = corrcoef(tang, sig_seg(idx-k:idx+k)).^2;
            Rcorr = R(1, 2);
        end
        tang = (t_seg-t_seg(idx))*nanmean(dy(idx-k:idx+k))+sig_seg(idx);
        horiz = ones(size(t_seg))*sig_seg(1);
%                 plot(t_seg, sig_seg);hold on;plot(t_seg(idx),sig_seg(idx),'ro');
%                 plot(t_seg, tang,'c.');plot(t_seg,horiz,'g.');
        %         keyboard;
        
        [foot_time, ~] = polyxpoly(t_seg,horiz,t_seg,tang);
        if isempty(foot_time)
%             keyboard;
            tan_foot(n) = vals_idx(n);
        else
            [~, foot_time_idx] = min(abs(t_seg - foot_time));
            tan_foot(n) = round(temp_start+foot_time_idx-1);
        end
        %         plot(t_seg(foot_time_idx),sig_seg(foot_time_idx),'ro');plot(t(tan_foot(n)), sig1(tan_foot(n)), 'k*');hold off;
        %         keyboard;
    end
    feet_idx = tan_foot;
elseif strcmpi(foot_option,'maxdd')
    max_dd = nan(size(vals_idx));
    
    for n = 1:length(vals_idx)
        foot_start = max(1, vals_idx(n) - (fs/10));
        foot_threshold = (sig_pks(n) - sig_vals(n))*0.25;
        sig_dip = sig(vals_idx(n):pks_idx(n));
        sig_dip(sig_dip < (min(sig_dip) + foot_threshold)) = 999;
        [~, idx] = min(sig_dip);
        foot_end = foot_start+(fs/10)+idx-1;
        sig_seg = sig(foot_start:foot_end);
        sigd = diff5(sig_seg, 1);
        sigdd = diff5(sig_seg, 2);
        sigdd(sigd <0) = -999;
        [~, idx] = max(sigdd);
        max_dd(n) = foot_start+idx-1;     
    end
    feet_idx = max_dd;
elseif strcmpi(foot_option,'min')
    feet_idx = vals_idx;
elseif strcmpi(foot_option,'zhang')
    
else
    keyboard;
end
% drop more abnormal detections
pks_idx(pks_idx < min(feet_idx)) = [];
feet_idx(feet_idx > max(pks_idx)) = [];

for m = length(pks_idx):-1:1
    if (min(pks_idx(m) - feet_idx(feet_idx < pks_idx(m))) > 0.5*fs) ||...
            min(abs(pks_idx(m) - feet_idx)) > 0.4*fs || min(abs(pks_idx(m) - feet_idx)) < 0.05*fs
        pks_idx(m, :) = [];
    end
end
pks_idx(pks_idx < min(feet_idx)) = [];
feet_idx(feet_idx > max(pks_idx)) = [];
for m = length(feet_idx):-1:1
    if (min(pks_idx(pks_idx > feet_idx(m)) - feet_idx(m)) > 0.5*fs) || ...
        min(abs(pks_idx - feet_idx(m))) > 0.4*fs || min(abs(pks_idx - feet_idx(m))) < 0.05*fs
        feet_idx(m, :) = [];
    end
end
pks_idx(pks_idx < min(feet_idx)) = [];
feet_idx(feet_idx > max(pks_idx)) = [];

if length(pks_idx) ~= length(feet_idx)
    pks_idx(pks_idx < min(feet_idx)) = [];
    feet_idx(feet_idx > max(pks_idx)) = [];
    if length(pks_idx) > length(feet_idx)
        closest_foot_before = nan(size(pks_idx));
        for m = length(pks_idx):-1:1
            feet_before = sort(feet_idx(feet_idx < pks_idx(m)));
            closest_foot_before(m) = max(feet_before);
        end
        [~, sort_idx] = sort(closest_foot_before);
        number_extra_pks = length(pks_idx) - length(feet_idx);
        pks_idx(sort_idx(end+1-number_extra_pks:end)) = [];
    elseif length(feet_idx) > length(pks_idx)
        closest_peak_after = nan(size(feet_idx));
        for m = length(feet_idx):-1:1
            peak_after = sort(pks_idx(pks_idx > feet_idx(m)));
            closest_peak_after(m) = min(peak_after);
        end
        [~, sort_idx] = sort(closest_peak_after);
        number_extra_feet = length(feet_idx) - length(pks_idx);
        feet_idx(sort_idx(1:number_extra_feet)) = [];
    end
end        
        
 if length(pks_idx) ~= length(feet_idx)       
    keyboard;
end
% figure(3);clf;
% plot(t', sig);hold on;
% plot(pks_idx/fs, sig(pks_idx), '*r');
% plot(vals_idx/fs, sig(vals_idx), 'k*');
% plot(feet_idx/fs, sig(feet_idx), 'co');xlabel('Time(s)');ylabel('Amplitude');hold off;
% pause;

end
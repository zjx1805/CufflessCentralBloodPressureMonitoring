%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates HR using fft for the signal
% heart_rate = Calc_HR(signal, Fs)
%
% Inputs:
% 1. Signal - signal for which Heart Rate needs to be estimated
% 2. Fs - Sampling rate
%
% Outputs: 
%
% Approach:
% Step1:
%
% Created by - Varun Agrawal
% Created on - 02/11/2013
%
% Version - 1.00
% Latest modifications: 
% 2. Updated peak HR to 2.6 (150 bpm) - V.A. (12/10/13)
% 1. Updated lower threshold for HR to be 0.4*60 -V.A. (9/6/13)
%
%
% Modifications to make: What if there is noise in the signal?
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function heart_rate = Calc_HR(signal, Fs)

low_threshold=1;
high_threshold=5;


signal = signal - mean(signal);
L = length(signal);
NFFT = 2^(nextpow2(L)+2);
Y = fft(signal, NFFT)/L;
f = Fs/2*linspace(0,1, NFFT/2+1);
abs_Y = abs(Y(1:round(high_threshold/f(2))));

[C, I] = max(abs_Y( ceil(low_threshold/f(2)):end));
peak_freq = (I + ceil(low_threshold/f(2)))*f(2);

% figure(111)
% plot(f,abs(Y(1:length(f))));  % Plots the frquency response
% keyboard

[C1, I1] = max(abs_Y( ceil(peak_freq/1.1/f(2)):round(peak_freq/1.25/f(2)) ));
if C < C1*2
    peak_freq_temp = (I1 + ceil(peak_freq/2.25/f(2)))*f(2);
    if peak_freq_temp>low_threshold
        peak_freq=peak_freq_temp;
    end
end


% if peak_freq > high_threshold*.9
%     [C1, I1] = max(abs_Y( ceil(low_threshold/f(2)):round(2/f(2)) ));
%     if C < C1*2
%         peak_freq = (I1 + ceil(low_threshold/f(2)))*f(2);
%     end
% end


heart_rate = peak_freq*60;

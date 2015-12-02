function [y,N,B,A]= passFilter(x,fs,fc,type,attentuation)
% Description: This function uses an elliptical filter
% to filter out high frequencies.
%
% [y,N,B,A] = lowpass(x,fs,fc)
%
% Variable Definition:
% x: Input signal
% fs: Input signal sampling frequency in Hz
% fc: cutoff frequency
%
% y: Filtered signal (output)
% N: Filter order
% B: Feedforward (FIR) coefficients
% A: Feedback (IIR) coefficients
Rp = 0.5;   % Ripple in dB (passband)
Rs = attentuation;    % Attenuation
mf = fs/2;  % Maximum frequency
Wp = fc/mf; % Cuttoff frequency
Ws = 1.2 * Wp; %Stopband frequency
% First, determine the minimum filter order to meet specifics
[N,Wn] = ellipord(Ws,Wp,Rp,Rs);
% Next, Design the filter (find the coefficients)
[B,A] = ellip(N,Rp,Rs,Wn,type);
% Now, apply the filter (filter the signal)
y = filtfilt(B,A,x);
% Plot the filter
%figure('Color',[1 1 1]);
%freqz(B,A,2^14,fs);
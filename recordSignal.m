clear; close all;

Fs = 192000;
T = 15;
t = linspace(0, T, Fs*T)';
Amp = 1;
f = 1000;
x = Amp*sin(2*pi*f*t);
windowLength = 6000;
win = hann(windowLength);
x(1:windowLength/2) = x(1:windowLength/2) .* win(1:windowLength/2);
x(end-windowLength/2+1:end) = x(end-windowLength/2+1:end) .* win(end-windowLength/2+1:end);

pa_wavplay(x, Fs, 1, 'asio')
% recnsamples = Fs*T + Fs;
% out = pa_wavplayrecord(x, 1, Fs, recnsamples, 1, 2, 1, 'asio');

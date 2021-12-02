clear; close all;

[sig, Fs] = audioread("data.wav");
Fs = 44100;
figure;
snr(sig)
figure;
thd(sig, Fs)
figure;
sinad(sig, Fs)
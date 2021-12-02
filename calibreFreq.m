clear; close all;

%% GUI Component
v = get(0, 'MonitorPositions');
XMIN = v(1, 3)*0.05; YMIN = v(1, 4)*0.1;
WIDTH = v(1, 3)*0.4; HEIGHT = v(1, 4)*0.4;
H.H0 = figure(...
    "Position", [XMIN YMIN WIDTH HEIGHT]);
ax = axes(H.H0,...
    "Position", [0.1 0.1 0.8 0.7]);
xlabel("Frequency [Hz]")
ylabel("Power [dB]")

xm = WIDTH*0.05; ym = HEIGHT - 40;
w = 100; h = 30;
H.B1 = uicontrol(...
    "Style", "togglebutton",...
    "Position", [xm ym w h],...
    "String", "Stop",...
    "FontSize", 14);

xm = xm + 100;
H.txt = uicontrol( ...
    "Style", "text",...
    "Position", [xm ym w h], ...
    "String", "000 Hz",...
    "FontSize", 18);

%% DSP
Fs = 48000;
fl = 1024;
aDR = audioDeviceReader(...
    'Driver', 'ASIO',...
    'Device', 'QUAD-CAPTURE',...
    'SampleRate', Fs,...
    'SamplesPerFrame', fl);

NFFT = 4096;
df = Fs/NFFT;
freqAxis = (0:df:Fs-df)';
freqArray = [25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
NumBands = 8;
win = hann(fl);
while ~H.B1.Value
    sig = aDR().*win;
    Spec = 20*log10(abs(fft(sig, NFFT)));
    semilogx(ax, freqAxis, Spec);
    grid(ax, "on")
    ylim([-80 60])
    xlabel_freq
    drawnow limitrate
end
H.B1.Value = 0;

release(aDR)
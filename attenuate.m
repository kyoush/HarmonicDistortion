clear; close all;

VmaxPk = 2;         % Maximum operating voltage
Fi = 2000;          % Sinusoidal frequency of 1kHz
Fs = 192000;        % Sample rate of 192kHz
Tstop = 50e-3;      % Duration of sinusoid
t = (0:1/Fs:Tstop)';   % Input time vector

% Allocate a table with 30 entries
nReadings = 30;
distortionTable = zeros(nReadings, 3);

% Compute the THD, SNR and SINAD for each of the attenuation settings
recnsamples = Tstop*Fs;
Amp = 1;
for i = 1:nReadings
    inputVbestAtten = db2mag(-i) * Amp * sin(2*pi*Fi*t);
    fprintf("dB Atten: %d\n", i)
    outputVbestAtten = pa_wavplayrecord(inputVbestAtten, 1, Fs, recnsamples, 1, 1, 1, 'asio');
    distortionTable(i, :) = [abs(thd(outputVbestAtten, Fs))
                             snr(outputVbestAtten, Fs)
                             sinad(outputVbestAtten, Fs)];
    % Plot results
    plot(distortionTable)
    xlabel('Input Attenuation (dB)')
    ylabel('Dynamic Range (dB)')
    legend('|THD|','SNR','SINAD','Location','best')
    title('Distortion Metrics vs. Input Attenuation')
    drawnow
end

% Plot results
plot(distortionTable)
xlabel('Input Attenuation (dB)')
ylabel('Dynamic Range (dB)')
legend('|THD|','SNR','SINAD','Location','best')
title('Distortion Metrics vs. Input Attenuation')
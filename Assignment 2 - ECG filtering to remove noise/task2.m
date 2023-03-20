% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load("ecg_signal_1.dat");

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load("ecg_signal_2.dat");

% Compute ECG 1 power spectrum
P_ecg1 = 1 / length(ecg1) * ( fft(ecg1) .* conj(fft(ecg1)) );

% Compute ECG 2 power spectrum
P_ecg2 = 1 / length(ecg2) * ( fft(ecg2) .* conj(fft(ecg2)) );

% Compute power spectrum frequency bins from 0 Hz to the Nyquist frequency
% For ECG 1
f1 = linspace(0, FS / 2, length(ecg1) / 2 + 1);
% ...and for ECG 2
f2 = linspace(0, FS / 2, length(ecg2) / 2 + 1);

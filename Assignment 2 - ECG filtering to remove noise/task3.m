% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load("ecg_signal_1.dat");

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load("ecg_signal_2.dat");

% Create moving average filter coefficients a and b:
b = 1 / 10 * ones(1, 10);
a = 1;
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b, a, ecg1);
% ...and ecg2
ecg2_filtered = filter(b, a, ecg2);

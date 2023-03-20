% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load("ecg_signal_1.dat");

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load("ecg_signal_2.dat");

% Create cascaded filter coefficients a and b using convolution
a = conv( 1, conv( [1, -0.995], 1 ) );
b = conv( 1 / 10 * ones(1, 10), conv( 1 / FS * [1, -1] / real(max(freqz(1 / FS * [1, -1], a))), [0.6310 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310] ) );
    
% Do the filtering using a, b, and ecg1
% For ecg1
ecg1_filtered = filter(b, a, ecg1);
% ...and ecg2
ecg2_filtered = filter(b, a, ecg2);

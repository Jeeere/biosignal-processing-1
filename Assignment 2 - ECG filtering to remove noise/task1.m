% The sampling rate is 1000 Hz
FS = 1000;

% Load ECG 1 into Nx1 vector from the file ecg_signal_1.dat
ecg1 = load("ecg_signal_1.dat");

% Load ECG 2 into Nx1 vector from the file ecg_signal_2.dat
ecg2 = load("ecg_signal_2.dat");

% Select the interval [2 s, 3s] samples from ECG 1
ecg1_interval = ecg1(2*FS:3*FS);

% Sample times for the interval 1
ecg1_interval_t =  2:1/FS:3;

% Select the interval [1 s, 2s] samples from ECG 2
ecg2_interval =  ecg2(1*FS:2*FS);

% Sample times for the interval 2
ecg2_interval_t =  1:1/FS:2;

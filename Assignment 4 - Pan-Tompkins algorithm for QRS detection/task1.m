% The sampling rate is 200 Hz 
FS = 200;

% Calculate the sample interval from FS
T = 1 / FS;

% Load the ECG from the file 'ECG.txt'
ECG = load('ECG.txt');

% Substract the first sample value to prevent P-T to amplify inital step
ECG = ECG - ECG(1);

% Lowpass filter The ECG (4.7)
b_lowpass = zeros(1, 13);
b_lowpass(1) = 1 / 32;
b_lowpass(7) = -1 / 16;
b_lowpass(13) = 1 / 32;

a_lowpass = [1,-2,1];

ECG_filtered1 = filter(b_lowpass, a_lowpass, ECG);

% Highpass filter the lowpass filtered ECG (4.11)
b_highpass = zeros(1, 33);
b_highpass(1) = -1 / 32;
b_highpass(17) = 1;
b_highpass(18) = -1;
b_highpass(33) = 1 / 32;

a_highpass = [1, -1];

ECG_filtered2 = filter(b_highpass, a_highpass, ECG_filtered1);

% Differential filter the high- and lowpass filtered ECG
b_diff = 1 / 8 * [1,2,0,-2,-1];
a_diff = 1;

ECG_filtered3 = filter(b_diff, a_diff, ECG_filtered2);

% Square the derivative filtered signal
ECG_filtered4 = ECG_filtered3.^2;

% Moving window integrator filter the squared signal (4.15 2. assign.)
% Window size
N = 30;
b_integ = 1 / N * ones(1, N);
a_integ = 1;

ECG_filtered5 = filter(b_integ, a_integ, ECG_filtered4);

% Set the blanking interval to 250 ms, but convert it to samples for the findQRS function
blankingInterval = 250 / 1000 / T;

% The amplitude threshold for QRS detection are set to these
treshold1 = 500; 
treshold2 = 2650; 

% Call the findQRS function 
[QRSStart_ECG, QRSEnd_ECG] = findQRS(ECG_filtered5, blankingInterval, treshold1, treshold2);

% Calculate the cumulative filter delays (in samples)
delay_lp = 25 / 1000 / T;
delay_hp = 80 / 1000 / T;
delays = delay_lp + delay_hp;

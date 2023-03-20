% Load the data from the file 'data6.mat'
% << INSERT YOUR CODE HERE >>
load("data6.mat");

% The ECG sampling rate is 1000 Hz
FS = 1000;

% QRS detector operates on 200 Hz signals
FS_QRS = 200;

% The number of subjects
N = numel(data);

% Windowing length
window = 50;

% Number of overlapped samples 
nbroverlap = 45;

% Specify nfft parameter as empty. 
nfft = [];

% Minimum spectrogram threshold
th = -30; 

% Using the pre-extracted cardiac cycles (struct 'cycles'), compute the spectrogram for each subject
% Store the results in a similar 1xN struct array called 'SPCs' with the fields s, f, t, and p corresponding to the outputs of the function 'spectrogram'
% E.g. SPCs(3).p is the power spectral density spectrogram (a matrix) of the subject 3.
SPCs = struct('s', [], 'f', [], 't', [], 'p', []);
for i = 1:N
    [SPCs(i).s, SPCs(i).f, SPCs(i).t, SPCs(i).p] = spectrogram(cycles(i).PCG, window, nbroverlap, nfft, FS,'MinThreshold',th,'yaxis');
end

% Using the full data (struct 'data'), find the QRS complexes using the function 'QRSDetection'
% Store only the QRS onset indice vectors of each subject in the elements of the 1xN cell array 'onsets'
% Note: QRS detection works at a lower data rate of 200 Hz instead of 1000 Hz, so you must resample the data first
%       Also you must map the detected onsets back to the original sampling rate by multiplying with the correct factor
onsets = cell(1, N);
for i = 1:N
    meme = resample(data(i).ECG, FS_QRS, FS);
    [onsets{i}, ~] = QRSDetection(meme);
    onsets{i} = onsets{i} * FS / FS_QRS;
end

% The systolic part of the PCG signal is expected to span this many samples starting from the QRS onset in each beat
segment_length = 300;

% Using the previously computed onsets, for each subject 
% pick all their PCG segments corresponding to the systolic parts in a 1xN cell array 'systoles'
% So, each cell corresponds to a subject, and contains a m-by-segment_length sized matrix of their m PCG segments
systoles = cell(1, N);
for i = 1:N
    systoles{i} = zeros(numel(onsets{i}), segment_length);
    for j = 1:numel(onsets{i})
        systoles{i}(j,:) = data(i).PCG(onsets{i}(j) : onsets{i}(j) + segment_length - 1);
    end
end

% For each subject, compute the power spectral density (PSD) of all the PCG segments separately
% Use the 'pwelch' function with the default arguments but specifying the sampling rate
% Store the results in a 1xN struct array 'PSDs' with the fields Pxx and F corresponding to the outputs of the pwelch function
% In addition, add the field Pxx_mean which is the average of all the PSD of that subject averaged across the beats
% Thus, PSDs(i).Pxx is a mxk matrix, PSDs(i).F is a kx1 vector, and PSDs(i).Pxx_mean is a 1xk vector
PSDs = struct('Pxx', [], 'F', [], 'Pxx_mean', []);
for i = 1:N
    for j = 1:numel(onsets{i})
        [PSDs(i).Pxx(j,:), PSDs(i).F] = pwelch(systoles{i}(j,:), [], [], [], FS);
    end
    PSDs(i).Pxx_mean = mean(PSDs(i).Pxx, 1);
end

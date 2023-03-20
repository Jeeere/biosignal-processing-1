% Load the data/variables from the file named spirometer.txt
spiro = load("spirometer.txt");

% The spirometer data 'spiro' is a 2Nx1 vector
% Resample the spirometer data into 50 Hz
spiro_resampled = resample(spiro, 5, 10);

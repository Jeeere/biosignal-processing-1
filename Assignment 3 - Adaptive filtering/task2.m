% Load problem2.mat to have access to variables abd_sig1 and mhb_ahead
load("problem2.mat");

% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = linspace(0, 20, 20 * FS);

% Estimate the time lag using cross correlation
% (Calculate cross correlation using the xcorr function and then
% use the max function to find the lag giving maximal correlation)
[c,lags] = xcorr( abd_sig1, mhb_ahead );
[~,d] = max(abs(c));
d = lags(d);

% Shift the chest ECG mhb_ahead back in time d samples padding with nearest value
mhb = circshift( mhb_ahead, d );
mhb(1:d) = mhb_ahead(1);

% Estimate c2 from abd_sig1 and mhb
c2_projection = ( abd_sig1.' * mhb ) / ( mhb.' * mhb );
c2_pinv = pinv(mhb) * abd_sig1;
c2 = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2 .* mhb;

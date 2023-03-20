% Load problem3.mat to have access to variables abd_sig1 and mhb_ahead
load("problem3.mat")

% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = linspace(0, 20, 20 * FS);

% Estimate the time lag using cross correlation with the 'xcorr' function
% Fit a spline to the cross correlation using 'spline' function, and then find the delay with maximum correlation using 'fnmin'
% NOTE: to use minimization function for maximization, please invert the objective function!
[c,lags] = xcorr( abd_sig1, mhb_ahead );
pp = spline(lags, -c);
[minval, d] = fnmin(pp);

% Shift the chest ECG mhb_ahead back in time d samples
% Use linear interpolation with extrapolation with the function 'interp1'
v = 1:length(mhb_ahead);
mhb = interp1(v(:), mhb_ahead, v(:) - d, 'linear', 'extrap');

% Estimate c2 from abd_sig1 and mhb
c2_projection = ( abd_sig1.' * mhb ) / ( mhb.' * mhb );
c2_pinv = pinv(mhb) * abd_sig1;
c2 = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2 .* mhb;

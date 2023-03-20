% Load problem1.mat to have access to variables abd_sig1 and mhb
load("problem1.mat");
% The sampling rates are 1000 Hz
FS = 1000;

% Calculate sample timing vector in seconds starting from 0
t = linspace(0, 20, 20 * FS);

% Estimate c2 from abd_sig1 and mhb using the scalar projection formula
c2_projection = ( abd_sig1.' * mhb ) / ( mhb.' * mhb );

% Estimate c2 from abd_sig1 and mhb using the pseudoinverse function (pinv)
c2_pinv = pinv(mhb) * abd_sig1;

% Estimate c2 from abd_sig1 and mhb using the backslash operator (\)
c2_operator = mhb \ abd_sig1;

% Calculate the fetal ECG by cancelling out the scaled mother's ECG using projection based estimation coefficient
fetus = abd_sig1 - c2_operator .* mhb;

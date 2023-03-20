% Load the data from the file problem3.mat
load("problem3.mat")

% Nx1 vectors flow1, flow2, and flow3 contain the model predictions
% Nx1 vector spiro_resampled contains the resampled reference spirometer data

% Compute the correlation coefficient for the model 1, between flow1 and spiro_resampled
x = flow1;
corr1 = sqrt(sum(x .* spiro_resampled - mean(x) * mean(spiro_resampled))^2 / (sum(x.^2 - mean(x)^2) * sum(spiro_resampled.^2 - mean(spiro_resampled)^2)));

% Compute the correlation coefficient for the model 2, between flow2 and spiro_resampled
x = flow2;
corr2 = sqrt(sum(x .* spiro_resampled - mean(x) * mean(spiro_resampled))^2 / (sum(x.^2 - mean(x)^2) * sum(spiro_resampled.^2 - mean(spiro_resampled)^2)));

% Compute the correlation coefficient for the model 3, between flow3 and spiro_resampled
x = flow3;
corr3 = sqrt(sum(x .* spiro_resampled - mean(x) * mean(spiro_resampled))^2 / (sum(x.^2 - mean(x)^2) * sum(spiro_resampled.^2 - mean(spiro_resampled)^2)));

% Compute the RMSE for the model 1, between flow1 and spiro_resampled
rmse1 = sqrt( sum( (spiro_resampled - flow1).^2 ) / 3000 );

% Compute the RMSE for the model 2, between flow2 and spiro_resampled
rmse2 = sqrt( sum( (spiro_resampled - flow2).^2 ) / 3000 );

% Compute the RMSE for the model 3, between flow3 and spiro_resampled
rmse3 = sqrt( sum( (spiro_resampled - flow3).^2 ) / 3000 );

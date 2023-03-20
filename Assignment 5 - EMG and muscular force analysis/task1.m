% The sampling rate is 2000 Hz 
FS = 2000;

% Load the signals from data.mat into the struct 'data'
% << insert loading code here >>
load('data.mat', 'data');

% Number of segments
N = numel(data);

% Calculate average force of each segment (1xN vector)
AF = cellfun(@part1, {data.force});

% Calculate EMG dynamic range in each segment (1xN vector)
DR = cellfun(@part2, {data.EMG});

% Calculate EMG mean squared value in each segment (1xN vector)
MS = cellfun(@part3, {data.EMG}, {data.length});

% Calculate EMG zero crossing rate in each segment (1xN vector)

ZCR = cellfun(@part4, {data.EMG}, {data.length});

% Calculate EMG turns rate in each segment (1xN vector)
TCR =cellfun(@part5, {data.EMG}, {data.length});

% Calculate the linear model coefficients for each parameter
% The models are in the form: parameter(force) = constant + slope * force,
% and the coefficients are stored in a 1x2 vectors: p_<param> = [slope constant]
% For example, p_DR(1) is the slope and p_DR(2) is the constant of the linear model mapping the average force into the dynamic range
% You can use the 'polyfit' (or the 'regress') command(s) to find the model coefficients
p_DR = polyval(polyfit(AF, DR, 1), AF);
p_MS = polyval(polyfit(AF, MS, 1), AF);
p_ZCR = polyval(polyfit(AF, ZCR, 1), AF);;
p_TCR = polyval(polyfit(AF, TCR, 1), AF);;

% Calculate correlation coefficients between the average forces and each of the parameters using 'corr'
c_DR = corr(AF', DR');
c_MS = corr(AF', MS');
c_ZCR = corr(AF', ZCR');
c_TCR = corr(AF', TCR');

function af = part1(force)
    af = mean(force);
end

function dr = part2(force)
    dr = max(force) - min(force);
end

function ms = part3(force, length)
    ms = sum(force.^2) / length;
end

function zcr = part4(emg, length)
    FS = 2000;

    zc = sum(abs(diff(sign(emg)))) / 2;
    zcr = zc / length * FS;
end

function tcr = part5(emg, length)
    FS = 2000;

    m = diff(emg(1:end-1)) .* diff(emg(2:end));
    idx = find(m <= 0) + 1;
    tcr = sum(abs(diff(emg(idx))) >= 0.1) / length * FS;
end

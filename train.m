%% 351 Language Classification -- Trainer
% KNN of Mel Frequency Cepstral Coefficients

mfccCount = 14602;

N_train = 10; % number of files to train
ENfiles = dir('./EN/*.mp3'); ENfiles = ENfiles(1:N_train);
CNfiles = dir('./CN/*.mp3'); CNfiles = CNfiles(1:N_train);
HNfiles = dir('./HN/*.mp3'); HNfiles = HNfiles(1:N_train);

mfcctrain = zeros(mfccCount, 1);
deltaTrain = zeros(mfccCount, 1);
deltadeltaTrain = zeros(mfccCount, 1);
trainLabels = {};
i = 1;
for file=ENfiles'
    [Y, fs] = audioread("./EN/" + file.name); % specify # of samples
    Y = audioNormalization_YW(Y, 0.5); % scales speech by peak value
    %trainLabels(i, :) = {'EN');
    
    [coeffs, delta, deltadelta] = mfcc(Y, fs); % mfcc @ 48kHz, plot not showing up?
    if(i==1) 
        break;
    end
    i = i + 1;
end



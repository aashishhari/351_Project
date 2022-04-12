%% 351 Language Classification -- Trainer
% KNN of Mel Frequency Cepstral Coefficients

mfccCount = 14602;

N_train = 10; % number of files to train
ENfiles = dir('./EN/*.mp3'); ENfiles = ENfiles(1:N_train);
CNfiles = dir('./CN/*.mp3'); CNfiles = CNfiles(1:N_train);
HNfiles = dir('./HN/*.mp3'); HNfiles = HNfiles(1:N_train);

ENlabels = cell(length(ENfiles), 2); ENlabels(:,1) = {'EN'}; % create labels, change?
CNlabels = cell(length(CNfiles), 2); CNlabels(:,1) = {'CN'};
HNlabels = cell(length(HNfiles), 2); HNlabels(:,1) = {'HN'};
trainLabels = [ENlabels; CNlabels; HNlabels];

mfccTrain = zeros(mfccCount, 1);
deltaTrain = zeros(mfccCount, 1);
deltadeltaTrain = zeros(mfccCount, 1);

%%
i = 1;
for file=ENfiles'
    [Y, fs] = audioread("./EN/" + file.name); % specify # of samples
    Y = audioNormalization_YW(Y, 0.5); % scales speech by peak value
    %trainLabels(i, :) = {'EN');
    [coeffs, delta, deltadelta] = mfcc(Y, fs); % mfcc @ 48kHz
    
    mfcctemp(1:20,:)=[]; %zero first 20 samples to account for weird delta spike
    deltatemp(1:20,:)=[]; 
    deltadeltatemp(1:20,:)=[]; 
    
    mfcc1d=reshape(mfcctemp.',1,[]); %resize array to 1d for training
    delta1d=reshape(deltatemp.',1,[]);
    deltadelta1d=reshape(deltadeltatemp.',1,[]);
    
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:); %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i = i + 1;
end



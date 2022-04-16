%% 351 Language Classification -- Trainer
% KNN of Mel Frequency Cepstral Coefficients

mfccCount = 14602;

N_train = 2; % number of files to train
ENfiles = dir('./EN/*.mp3'); ENfiles = ENfiles(1:N_train);
CNfiles = dir('./CN/*.mp3'); CNfiles = CNfiles(1:N_train);
HNfiles = dir('./HN/*.mp3'); HNfiles = HNfiles(1:N_train);

ENlabels = cell(length(ENfiles), 1); ENlabels(:,1) = {'EN'}; % create labels, change?
CNlabels = cell(length(CNfiles), 1); CNlabels(:,1) = {'CN'};
HNlabels = cell(length(HNfiles), 1); HNlabels(:,1) = {'HN'};
trainLabels = [ENlabels; CNlabels; HNlabels];

mfccTrain = zeros(mfccCount, 1);
deltaTrain = zeros(mfccCount, 1);
deltadeltaTrain = zeros(mfccCount, 1);

%%
i = 1;
for file=ENfiles'
    [Y, fs] = audioread("./EN/" + file.name); % specify # of samples
    Y = audioNormalization_YW(Y, 0.5); % scales speech by peak value
   
    [mfcc_coeffs, delta, deltadelta] = mfcc(Y, fs); % mfcc @ 48kHz
    
    mfcc_coeffs(1:20,:)=[]; %zero first 20 samples to account for weird delta spike
    delta(1:20,:)=[]; 
    deltadelta(1:20,:)=[]; 
    
    mfcc1d=reshape(mfcc_coeffs.',1,[]); %resize array to 1d for training
    delta1d=reshape(delta.',1,[]);
    deltadelta1d=reshape(deltadelta.',1,[]);
    
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:); %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i = i + 1;
end
for file=CNfiles'
    [Y, fs] = audioread("./CN/" + file.name); % specify # of samples
    Y = audioNormalization_YW(Y, 0.5); % scales speech by peak value

    [mfcc_coeffs, delta, deltadelta] = mfcc(Y, fs); % mfcc @ 48kHz
    
    mfcc_coeffs(1:20,:)=[]; %zero first 20 samples to account for weird delta spike
    delta(1:20,:)=[]; 
    deltadelta(1:20,:)=[]; 
    
    mfcc1d=reshape(mfcc_coeffs.',1,[]); %resize array to 1d for training
    delta1d=reshape(delta.',1,[]);
    deltadelta1d=reshape(deltadelta.',1,[]);
    
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:); %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i = i + 1;
end
for file=HNfiles'
    [Y, fs] = audioread("./HN/" + file.name); % specify # of samples
    Y = audioNormalization_YW(Y, 0.5); % scales speech by peak value

    [mfcc_coeffs, delta, deltadelta] = mfcc(Y, fs); % mfcc @ 48kHz
    
    mfcc_coeffs(1:20,:)=[]; %zero first 20 samples to account for weird delta spike
    delta(1:20,:)=[]; 
    deltadelta(1:20,:)=[]; 
    
    mfcc1d=reshape(mfcc_coeffs.',1,[]); %resize array to 1d for training
    delta1d=reshape(delta.',1,[]);
    deltadelta1d=reshape(deltadelta.',1,[]);
    
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:); %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i = i + 1;
end

mfccTrain=mfccTrain.';              %transpose matrix for training
deltaTrain=deltaTrain.';

[idx,weights]=relieff(mfccTrain,trainLabels,5);             %Determine most important KNN predictors
predictors = 2500;                                          %Decide predictor cutoff
mfcctraintrimmed = zeros(size(trainLabels,1),1);                            %empty matrix for trimmed mfcc, hard coded

for k = 1:1:predictors
    mfcctraintrimmed(:,k)=mfccTrain(:,idx(k));              %populate with most important predictors
end

Mdl=fitcknn(mfcctraintrimmed,trainLabels,"NumNeighbors",5);         %train model

% Cleanup
%clearvars -except mfccCount Mdl predictors




%% 351 Language Classification -- Tester
% KNN of Mel Frequency Cepstral Coefficients

TESTfiles = dir('./TestData/*.mp3');

%TESTfiles = TESTfiles(1:N_train);

%testfft=zeros(1,samples);
%testtime=zeros(1,samples);
mfcctest=zeros(mfccCount,1); %create empty test matrices
deltatest=zeros(mfccCount,1);

actual = {};
j = 1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning ground truth labels for confusion matrix
        actual(j,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual(j,:)={'EN'};
    elseif(contains(file.name,'hi'))
        actual(j,:)={'HN'};
    end
  
    [Y, fs] = audioread("./TestData/" + file.name);
    Y_n = audioNormalization_YW(Y, 0.5); % scales speech by peak value
    [mfcc_coeffs, delta] = mfcc(Y_n, fs); % computer mfcc @48kHz
   
    mfcc_coeffs(1:20,:)=[];
    delta(1:20,:)=[];        
   
    mfcctest1d=reshape(mfcc_coeffs.',1,[]); %change to 1d
    deltatest1d=reshape(delta.',1,[]);

    mfcctest(1:length(mfcctest1d),j)=mfcctest1d(:); %add to test array
    deltatest(1:length(deltatest1d),j)=deltatest1d(:);
   
    j=j+1;
end

mfcctest=mfcctest.'; %transpose
deltatest=deltatest.';

mfcctesttrimmed = zeros(size(TESTfiles,1),1); %empty trimmed mfcc array

for l = 1:1:predictors
    mfcctesttrimmed(:,l)=mfcctest(:,idx(l)); %populate with most important predictors
end

%% Plot Model
predicted = predict(Mdl,mfcctesttrimmed); %predict for test array with trained model
confusionchart(actual,predicted)    

%% EECS351 Project test

clear;
close all;

%samples = 1000000;                  
mfccCount = 14602;                  %number of mfcc's


cd EN\;                             %change folder to english training clips folder
ENfiles = dir('**/*.mp3');            %specify which files to read 

%^^^^^ change these two lines if your directories are different 

%fftTrain=zeros(1,samples);
%timeTrain=zeros(1,samples);
mfccTrain=zeros(mfccCount,1);               %create empty arrays
deltaTrain=zeros(mfccCount,1);              %change in mfcc (first derivative) (currently not used)
deltadeltaTrain=zeros(mfccCount,1);         %second derivative (currently not used)
trainLabels={};                               %empty labels for EN, CN training data

i=1;

for file = ENfiles'

    temp=audioNormalization_YW(audioread(strcat(ENfiles(i).folder,'\',file.name)),0.5); %normalize input audio
    %timeTrain(i,1:length(temp))=temp;                         
    %fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'EN'};                                    %assign label to all english training data 
    [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);      %get mfcc's, deltas, deltadeltas
    mfcctemp(1:20,:)=[];                                       %zero first 20 samples to account for weird delta spike
    deltatemp(1:20,:)=[]; 
    deltadeltatemp(1:20,:)=[]; 
    mfcc1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d for training
    delta1d=reshape(deltatemp.',1,[]);
    deltadelta1d=reshape(deltadeltatemp.',1,[]);   
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);                   %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i=i+1;
    
end

cd '..\CN\'                                 %change folder to chinese training clips
CNfiles = dir('**\*.mp3');                 %specify files to read

%^^^^^ change these two lines if your directories are different 

for file = CNfiles'

    temp=audioNormalization_YW(audioread(strcat(CNfiles(i-length(ENfiles)).folder,'\',file.name)),0.5);     %normalize audio
    %timeTrain(i,1:length(temp))=temp;                         
    %fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'CN'};                            %assign labels for chinese training data
    [mfcctemp,deltatemp]=mfcc(temp,48000);              %compute mfcc and first derivative 
    mfcctemp(1:20,:)=[];                                %zero first 20 samples to remove weird artifacts
    deltatemp(1:20,:)=[];        
    mfcc1d=reshape(mfcctemp.',1,[]);                    %change to 1d array for training
    delta1d=reshape(deltatemp.',1,[]);
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);            %add to training array
    deltaTrain(1:length(delta1d),i)=delta1d(:);

    i=i+1;

end

cd '..\HN\'
HNfiles = dir('**\*.mp3');                

%^^^^^ change these two lines if your directories are different 

for file = HNfiles'                              %repeat for hindi

    temp=audioNormalization_YW(audioread(strcat(HNfiles(i-length(ENfiles) ...
        -length(CNfiles)).folder,'\',file.name)),0.5);
    %timeTrain(i,1:length(temp))=temp;                         
    %fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'HN'};   
    [mfcctemp,deltatemp]=mfcc(temp,48000);
    mfcctemp(1:20,:)=[];
    deltatemp(1:20,:)=[];        
    mfcc1d=reshape(mfcctemp.',1,[]);
    delta1d=reshape(deltatemp.',1,[]);
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);
    deltaTrain(1:length(delta1d),i)=delta1d(:);

    i=i+1;

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

cd ..;
TESTfiles = dir('*.mp3');               %specify test files (I have them in the main matlab directory)

%testfft=zeros(1,samples);
%testtime=zeros(1,samples);
mfcctest=zeros(mfccCount,1);                                        %create empty test matrices
deltatest=zeros(mfccCount,1);

actual = {};

j=1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning ground truth labels for confusion matrix
        actual(j,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual(j,:)={'EN'};
    elseif(contains(file.name,'hi'))
        actual(j,:)={'HN'};
    end
    
    temp=audioNormalization_YW(audioread(file.name),0.5);           %normalize
    %testtime(j,1:length(temp))=temp;     
    %testfft(j,1:length(testtime(j,:)))=abs(fft(testtime(j,:)));
    [mfcctemp,deltatemp]=mfcc(temp,48000);                          %compute mfcc 
    mfcctemp(1:20,:)=[];
    deltatemp(1:20,:)=[];        
    mfcctest1d=reshape(mfcctemp.',1,[]);                            %change to 1d
    deltatest1d=reshape(deltatemp.',1,[]);

    mfcctest(1:length(mfcctest1d),j)=mfcctest1d(:);                 %add to test array
    deltatest(1:length(deltatest1d),j)=deltatest1d(:);
   
    j=j+1;

end

mfcctest=mfcctest.';                                %transpose
deltatest=deltatest.';

mfcctesttrimmed = zeros(size(TESTfiles,1),1);                     %empty trimmed mfcc array

for l = 1:1:predictors
    mfcctesttrimmed(:,l)=mfcctest(:,idx(l));        %populate with most important predictors
end


predicted = predict(Mdl,mfcctesttrimmed);                       %predict for test array with trained model
confusionchart(actual,predicted)    

%plot(1:length(fft(ans)), abs(dataFlip(fft(ans))));
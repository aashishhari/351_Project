%% EECS351 Project test

clear;
close all;

%samples = 1000000;                  
mfccCount = 14602;                  %number of mfcc's

cd EN\;                             %change folder to english folder
ENfiles = dir('**/*.mp3');            %specify files to read

%fftTrain=zeros(1,samples);
%timeTrain=zeros(1,samples);
mfccTrain=zeros(mfccCount,1);               %create empty arrays
deltaTrain=zeros(mfccCount,1);
deltadeltaTrain=zeros(mfccCount,1);
trainLabels={};                               %labels for EN, CN

i=1;

for file = ENfiles'

    temp=audioNormalization_YW(audioread(strcat(ENfiles(i).folder,'\',file.name)),0.5); %normalize
    %timeTrain(i,1:length(temp))=temp;                         
    %fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'EN'};
    [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);      %get mfcc's, deltas, deltadeltas
    mfcctemp(1:20,:)=[];                                       %zero first 20 samples to account for weird delta spike
    deltatemp(1:20,:)=[]; 
    deltadeltatemp(1:20,:)=[]; 
    mfcc1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d
    delta1d=reshape(deltatemp.',1,[]);
    deltadelta1d=reshape(deltadeltatemp.',1,[]);   
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);                   %add array to train array
    deltaTrain(1:length(delta1d),i)=delta1d(:);
    deltadeltaTrain=zeros(mfccCount,1);
    i=i+1;
    
end

cd '..\CN\'
CNfiles = dir('**\*.mp3');                 %repeat for chinese

for file = CNfiles'

    temp=audioNormalization_YW(audioread(strcat(CNfiles(i-length(ENfiles)).folder,'\',file.name)),0.5);
    %timeTrain(i,1:length(temp))=temp;                         
    %fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'CN'};   
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
mfcctraintrimmed = zeros(783,1);                            %empty matrix for trimmed mfcc

for k = 1:1:predictors
    mfcctraintrimmed(:,k)=mfccTrain(:,idx(k));              %populate with most important predictors
end



Mdl=fitcknn(mfcctraintrimmed,trainLabels,"NumNeighbors",5);         %train model

cd ..;
TESTfiles = dir('*.mp3');

%testfft=zeros(1,samples);
%testtime=zeros(1,samples);
mfcctest=zeros(mfccCount,1);                                        %create empty test matrices
deltatest=zeros(mfccCount,1);

actual = {};

j=1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning labels for confusion chart
        actual(j,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual(j,:)={'EN'};
    end
    
    temp=audioNormalization_YW(audioread(file.name),0.5);           %normalize
    %testtime(j,1:length(temp))=temp;     
    %testfft(j,1:length(testtime(j,:)))=abs(fft(testtime(j,:)));
    [mfcctemp,deltatemp]=mfcc(temp,48000);
    mfcctemp(1:20,:)=[];
    deltatemp(1:20,:)=[];        
    mfcctest1d=reshape(mfcctemp.',1,[]);
    deltatest1d=reshape(deltatemp.',1,[]);

    mfcctest(1:length(mfcctest1d),j)=mfcctest1d(:);
    deltatest(1:length(deltatest1d),j)=deltatest1d(:);
   
    j=j+1;

end

mfcctest=mfcctest.';                                %transpose
deltatest=deltatest.';

mfcctesttrimmed = zeros(200,1);

for l = 1:1:predictors
    mfcctesttrimmed(:,l)=mfcctest(:,idx(l));        %populate with most important predictors
end


predicted = predict(Mdl,mfcctesttrimmed);                       %predict with model
confusionchart(actual,predicted)    

%plot(1:length(fft(ans)), abs(dataFlip(fft(ans))));

%% EECS351 Project KNN test

clear;
close all;

samples = 1000000;
mfccCount = 14602;

cd EN\;                             %change folder to english folder
ENfiles = dir('**/*.mp3');            %specify files to read

fftTrain=zeros(1,samples);
timeTrain=zeros(1,samples);
mfccTrain=zeros(mfccCount,1);
trainLabels={};                               %labels for EN, CN

i=1;

for file = ENfiles'

    temp=audioread(strcat(ENfiles(i).folder,'\',file.name));
    timeTrain(i,1:length(temp))=temp;                         %concatenate audio clip into zero matrix x
    fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'EN'};
    mfcctemp=mfcc(temp,48000);
    mfcc1d=reshape(mfcctemp.',1,[]);
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);
    i=i+1;
    
end

cd '..\CN\'
CNfiles = dir('**\*.mp3');                 %repeat for chinese

for file = CNfiles'

    temp=audioread(strcat(CNfiles(i-length(ENfiles)).folder,'\',file.name));
    timeTrain(i,1:length(temp))=temp;                         %concatenate audio clip into zero matrix x
    fftTrain(i,1:length(timeTrain(i,:)))=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'CN'};   
    mfcctemp=mfcc(temp,48000);
    mfcc1d=reshape(mfcctemp.',1,[]);
    mfccTrain(1:length(mfcc1d),i)=mfcc1d(:);
    i=i+1;

end


mfccTrain=mfccTrain.';

Mdl=fitcauto(mfccTrain,trainLabels);

cd ..;
TESTfiles = dir('*.mp3');

testfft=zeros(1,samples);
testtime=zeros(1,samples);
mfcctest=zeros(mfccCount,1);

actual = {};

j=1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning labels for confusion chart
        actual(j,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual(j,:)={'EN'};
    end
    temp=audioread(file.name);
    testtime(j,1:length(temp))=temp;     
    testfft(j,1:length(testtime(j,:)))=abs(fft(testtime(j,:)));
    mfcctemp=mfcc(temp,48000);
    mfcctest1d=reshape(mfcctemp.',1,[]);
    mfcctest(1:length(mfcctest1d),j)=mfcctest1d(:);
   
    j=j+1;

end


mfcctest=mfcctest.';
predicted = predict(Mdl,mfcctest);                       %predict with model
confusionchart(actual,predicted)    



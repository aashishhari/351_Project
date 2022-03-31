%% EECS351 Project KNN test

clear;
close all;

cd EN\;                             %change folder to english folder
ENfiles = dir('**/*.opus');            %specify files to read

fftTrain=zeros(1,43200);
timeTrain=zeros(1,43200);
mfccTrain=zeros(1232,1);
trainLabels={};                               %labels for EN, CN

i=1;

for file = ENfiles'

    temp=audioread(strcat(ENfiles(i).folder,'\',file.name),[1,43200]);
    timeTrain(i,:)=temp;                         %concatenate audio clip into zero matrix x
    fftTrain(i,:)=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'EN'};
    mfcctemp=mfcc(temp,48000);
    mfccTrain(:,i)=mfcctemp(:);
    i=i+1;
    
end

cd '..\CN\'
CNfiles = dir('**\*.opus');                 %repeat for chinese

for file = CNfiles'

    temp=audioread(strcat(CNfiles(i-length(ENfiles)).folder,'\',file.name),[1,43200]);
    timeTrain(i,:)=temp;
    fftTrain(i,:)=abs(fft(timeTrain(i,:)));
    trainLabels(i,:)={'CN'};   
    mfcctemp=mfcc(temp,48000);
    mfccTrain(:,i)=mfcctemp(:);
    i=i+1;

end


mfccTrain=mfccTrain.';

Mdl=fitcsvm(mfccTrain,trainLabels);

cd ..;
TESTfiles = dir('*.opus');

testfft=zeros(1,43200);
testtime=zeros(1,43200);
mfcctest=zeros(1232,1);

actual = {};

j=1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning labels for confusion chart
        actual(j,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual(j,:)={'EN'};
    end
    temp=audioread(file.name,[1,43200]);
    testtime(j,:)=temp;  
    testfft(j,:)=abs(fft(testtime(j,:)));
    mfcctemp=mfcc(temp,48000);
    mfcctest(:,j)=mfcctemp(:);
    j=j+1;

end

cd Testing\;
TEST1files = dir('*.opus');

test1fft=zeros(1,43200);
test1time=zeros(1,43200);
mfcctest1=zeros(1232,1);
actual1 = {};
k=1;
for file = TEST1files'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning labels for confusion chart
        actual1(k,:)={'CN'};
    elseif(contains(file.name,'en'))
        actual1(k,:)={'EN'};
    end
    temp=audioread(file.name,[1,43200]);
    test1time(k,:)=temp;  
    test1fft(k,:)=abs(fft(test1time(k,:)));
    mfcctemp=mfcc(temp,48000);
    mfcctest1(:,k)=mfcctemp(:);
    k=k+1;

end

mfcctest=mfcctest.';
mfcctest1=mfcctest1.';
predicted = predict(Mdl,mfcctest);                       %predict with model
confusionchart(actual,predicted)    

predicted1 = predict(Mdl,mfcctest1);
figure(2);
confusionchart(actual1,predicted1);



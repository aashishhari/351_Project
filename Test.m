clear;
close all;

cd EN\;                             %change folder to english folder
ENfiles = dir('*.opus');            %specify files to read

x=zeros(1,36234);
y={};                               %labels for EN, CN

i=1;

for file = ENfiles'

    temp=abs(fft(audioread(file.name,[1,36234])));
    x(i,:)=temp;                         %concatenate audio clip into zero matrix x
    y(i,:)={'EN'};
    i=i+1;

end

cd '..\CN\'
CNfiles = dir('*.opus');                 %repeat for chinese

for file = CNfiles'

    temp=abs(fft(audioread(file.name,[1,36234])));
    x(i,:)=temp;
    y(i,:)={'CN'};    
    i=i+1;

end

Mdl=fitcknn(x,y,'NumNeighbors', 5, 'Standardize', 1);   %train model

cd ..;
TESTfiles = dir('*.opus');

test=zeros(1,36234);
actual = {};

j=1;
for file = TESTfiles'                               %concatenate test audio
    if(contains(file.name,'CN'))                    %assigning labels for confusion chart
        actual(j,:)={'CN'};
    elseif(contains(file.name,'EN'))
        actual(j,:)={'EN'};
    end
    temp=abs(fft(audioread(file.name,[1,36234])));
    test(j,:)=temp;  
    j=j+1;

end

predicted = predict(Mdl,test);                       %predict with model
confusionchart(actual,predicted)    

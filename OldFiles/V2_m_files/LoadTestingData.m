%% EECS351 load testing data

TESTfiles = dir('*.mp3');               %specify test files (I have them in the main matlab directory)

%testfft=zeros(1,samples);
%testtime=zeros(1,samples);
mfcctest=zeros(mfccCount,1);                                        %create empty test matrices
deltatest=zeros(mfccCount,1);
deltadeltatest=zeros(mfccCount,1);

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
    [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);                          %compute mfcc 
    mfcctemp(1:20,:)=[];
    deltatemp(1:20,:)=[];        
    mfcctest1d=reshape(mfcctemp.',1,[]);                            %change to 1d
    deltatest1d=reshape(deltatemp.',1,[]);
    deltadeltatest1d=reshape(deltadeltatemp.',1,[]);

    mfcctest(1:length(mfcctest1d),j)=mfcctest1d(:);                 %add to test array
    deltatest(1:length(deltatest1d),j)=deltatest1d(:);
    deltadeltatest(1:length(deltadeltatest1d),j)=deltadeltatest1d(:);
   
    j=j+1;

end

mfcctest=mfcctest.';                                %transpose
deltatest=deltatest.';
deltadeltatest=deltadeltatest.';
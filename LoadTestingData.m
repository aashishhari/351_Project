%% EECS351 load testing data
% audioNormalization_YW courtesy Yi-Wen Chen
% https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab

cd Testfiles\;
TESTfiles = dir('*.mp3');               %specify test files (I have them in the main matlab directory)

actual = {};

testindex=1;
for file = TESTfiles'                               %concatenate test audio
    
    temp=audioNormalization_YW(audioread(file.name),0.5);           %normalize
    if(length(temp) >= 200000)
        temp=temp(1:200000,:);
        ftemp=pitch(temp,48000,WindowLength=window,OverlapLength=overlap);

        %extract voiced segments courtesy MATLAB 
        %https://www.mathworks.com/help/audio/ug/speaker-identification-using-pitch-and-mfcc.html   
        [segments,~] = buffer(temp,window,overlap,"nodelay");
        ste = sum((segments.*hamming(window,"periodic")).^2,1);
        isSpeech = ste(:) > energyThreshold;
        zcr = zerocrossrate(temp,WindowLength=window,OverlapLength=overlap);
        isVoiced = zcr < zcrThreshold;
        voicedSpeech = isSpeech & isVoiced;
        ftemp(~voicedSpeech) = [];
        
        %smoothing
        inrange = (25 < ftemp) & (ftemp < 375);
        removeSaturation = ftemp(inrange);
        removeSaturation(1:round(length(ftemp)/10))=[];
        instdrange = (removeSaturation > mean(removeSaturation)-2*std(removeSaturation)) & ...
            (removeSaturation < mean(removeSaturation)+2*std(removeSaturation));
        removeOutliers = removeSaturation(instdrange);
        smooth=movmean(removeOutliers,5,'Endpoints','discard');
        %smooth=lowpass(smooth,8000,48000);

        %feature calculation
        delta=diff(smooth);
        p2p=peak2peak(smooth);
        avgdelta = mean(abs(delta));
        meddelta = median(abs(delta));
        dft=abs(fft(smooth));
        scalarfeatures = [p2p avgdelta meddelta];

        if(contains(file.name,'CN'))                    %assigning ground truth labels for confusion matrix
            actual(testindex,:)={'CN'};
            [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);                          %compute mfcc 
        elseif(contains(file.name,'en'))
            actual(testindex,:)={'EN'};
            [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);                          %compute mfcc 
        elseif(contains(file.name,'hi'))
            actual(testindex,:)={'HN'};
            [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);                          %compute mfcc 
    
        end
    
        mfcctemp(1:25,:)=[];
    
        mfcctest1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d for testing
        mfcctest1d=[mfcctest1d scalarfeatures];

        mfcctest(1:length(mfcctest1d),testindex)=mfcctest1d(:);                 %add to test array
   
        testindex=testindex+1;
    
    end

end

mfcctest=mfcctest.';
%mfcctest=gpuArray(mfcctest.');                                %transpose
if(size(mfcctest,2)>size(mfccTrain,2))
    mfcctest(:,size(mfccTrain,2)+1:size(mfcctest,2))=[];
elseif(size(mfcctest,2)<size(mfccTrain,2))
    mfccTrain(:,size(mfcctest,2)+1:size(mfccTrain,2))=[];

end


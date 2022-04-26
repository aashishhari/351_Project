%% EECS351 load training data 
% audioNormalization_YW courtesy Yi-Wen Chen
% https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab

clear;
close all;

window=round(0.04*48000);
overlap=round(0.025*48000);

energyThreshold = 0.1;
zcrThreshold = 5;

cd EN\;                             %change folder to english training clips folder
ENfiles = dir('**/*.mp3');            %specify which files to read 


trainLabels={};                               %empty labels for EN, CN training data

i=1;
trainindex = 1;
for file = ENfiles'
    temp=audioNormalization_YW(audioread(strcat(ENfiles(i).folder, ...
        '\',file.name)),0.5); %normalize input audio

    if(length(temp) >= 200000)
        temp=temp(1:200000,:);
        trainLabels(trainindex,:)={'EN'};                                    %assign label to all english training data 
        [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);      %get mfcc's, deltas, deltadeltas
        mfcctemp(1:25,:)=[];                                       %zero first 20 samples to account for weird delta spike
        deltatemp(1:25,:)=[]; 

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
        
        mfcc1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d for training
        mfcc1d=[mfcc1d scalarfeatures];
        mfccTrain(1:length(mfcc1d),trainindex)=mfcc1d(:);                   %add array to train array
        
        trainindex=trainindex+1;

    end
    
    i=i+1;
    
end

cd '..\CN\'                                 %change folder to chinese training clips
CNfiles = dir('**\*.mp3');                 %specify files to read

for file = CNfiles'
    temp=audioNormalization_YW(audioread(strcat(CNfiles(i-length(ENfiles)).folder ...
        ,'\',file.name)),0.5);     %normalize audio
 
    if(length(temp) >= 200000)
        temp=temp(1:200000,:);
        trainLabels(trainindex,:)={'CN'};                                    %assign label to all english training data 
        [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);      %get mfcc's, deltas, deltadeltas
        mfcctemp(1:25,:)=[];                                       %zero first 20 samples to account for weird delta spike
        deltatemp(1:25,:)=[]; 

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
        
        mfcc1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d for training
        mfcc1d=[mfcc1d scalarfeatures];
        mfccTrain(1:length(mfcc1d),trainindex)=mfcc1d(:);                   %add array to train array
        
        trainindex=trainindex+1;

    end

    i=i+1;

end


cd '..\HN\'
HNfiles = dir('**\*.mp3');                

for file = HNfiles'                              %repeat for hindi

    temp=audioNormalization_YW(audioread(strcat(HNfiles(i-length(ENfiles) ...
        -length(CNfiles)).folder,'\',file.name)),0.5);
    temp=resample(temp,3,2);
    if(length(temp) >= 200000)
        temp=temp(1:200000,:);
        trainLabels(trainindex,:)={'HN'};                                    %assign label to all english training data 
        [mfcctemp,deltatemp,deltadeltatemp]=mfcc(temp,48000);      %get mfcc's, deltas, deltadeltas
        mfcctemp(1:25,:)=[];                                       %zero first 20 samples to account for weird delta spike
        deltatemp(1:25,:)=[]; 

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
        
        mfcc1d=reshape(mfcctemp.',1,[]);                           %resize array to 1d for training
        mfcc1d=[mfcc1d scalarfeatures];
        mfccTrain(1:length(mfcc1d),trainindex)=mfcc1d(:);                   %add array to train array
        
        trainindex=trainindex+1;

    end
    
    i=i+1;
    
end

mfccTrain=mfccTrain.';              %transpose matrix for training

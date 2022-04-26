%% EECS351 experimental

close all;
windowsize=3;

filename="en_test (10).mp3";

hold off;

%^^^^^ change these two lines if your directories are different 

window=round(0.04*48000);
overlap=round(0.025*48000);
f0=pitch(audioNormalization_YW(audioread(filename),0.5) ...
    ,48000,WindowLength=window,OverlapLength=overlap);



energyThreshold = 0.1;
[segments,~] = buffer(audioNormalization_YW(audioread(filename),0.5),window,overlap,"nodelay");
ste = sum((segments.*hamming(window,"periodic")).^2,1);
isSpeech = ste(:) > energyThreshold;
zcrThreshold = 5;
zcr = zerocrossrate(audioNormalization_YW(audioread(filename),0.5),WindowLength=window,OverlapLength=overlap);
isVoiced = zcr < zcrThreshold;
voicedSpeech = isSpeech & isVoiced;
f0(~voicedSpeech) = [];

plot(f0,"*");

inrange = (75 < f0) & (f0 < 325);
removeSaturation = f0(inrange);
removeSaturation(1:20)=[];

instdrange = (removeSaturation > mean(removeSaturation)-2*std(removeSaturation)) & ...
    (removeSaturation < mean(removeSaturation)+2*std(removeSaturation));
removeOutliers = removeSaturation(instdrange);

figure(2);
plot(removeOutliers,"*");
sf0=movmedian(removeOutliers,5,'Endpoints','discard');
hold on;
plot(sf0);

ffiltered=lowpass(sf0,4000,48000);
plot(ffiltered);

hold off;

delta=diff(ffiltered);
figure(4);
plot(delta);

p2p=peak2peak(ffiltered);

avgdelta = mean(abs(delta));
meddelta = median(abs(delta));
figure(5);
plot(abs(delta));

dft=fft(ffiltered);

%{
num = [0 0 100];
dem = [1 2 100];
ffiltered=lowpass(f0,1000,48000);
figure(2);
plot(ffiltered);

delta=diff(ffiltered);
figure(3);
plot(delta);

dft=fft(ffiltered);
figure(4);
plot(abs(dft));
%}
%% EECS351 experimental

clear;
close all;
windowsize=3;

hold off;

%^^^^^ change these two lines if your directories are different 

window=round(0.04*48000);
overlap=round(0.025*48000);
f0=pitch(audioNormalization_YW(audioread("en_test_sample.mp3"),0.5) ...
    ,48000,WindowLength=window,OverlapLength=overlap);




energyThreshold = 0.05;
[segments,~] = buffer(audioNormalization_YW(audioread("en_test_sample.mp3"),0.5),window,overlap,"nodelay");
ste = sum((segments.*hamming(window,"periodic")).^2,1);
isSpeech = ste(:) > energyThreshold;
zcrThreshold = 10;
zcr = zerocrossrate(audioNormalization_YW(audioread("en_test_sample.mp3"),0.5),WindowLength=window,OverlapLength=overlap);
isVoiced = zcr < zcrThreshold;
voicedSpeech = isSpeech & isVoiced;
f0(~voicedSpeech) = [];

plot(f0,"*");

inrange = f0 < 300;
removeSaturation = f0(inrange);

figure(2);
plot(removeSaturation,"*");
sf0=movmedian(removeSaturation,5,'Endpoints','shrink');
hold on;
plot(sf0);

ffiltered=lowpass(sf0,4000,48000);
plot(ffiltered);

hold off;

delta=diff(ffiltered);
figure(4);
plot(delta);
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
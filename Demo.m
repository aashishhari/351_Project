%% EECS351 Team 12 Demo
clear;
close all;

load("trainedMdl_demo.mat");            %To save time, we directly load 
                                        %variables of interest obtained 
                                        %from running 'LoadTrainingData.m'
                                        %and 'LoadTestingData.m'
                                        %sequentially.

Numneighbors = 10;

[idx,weights]=relieff(mfccTrain,trainLabels,Numneighbors);             %Determine most important KNN predictors
predictors = 3000;                                          %Decide predictor cutoff

mfcctraintrimmed = zeros(size(trainLabels,1),1);                            %empty matrix for trimmed mfcc, hard coded

for k = 1:1:predictors
    mfcctraintrimmed(:,k)=mfccTrain(:,idx(k));              %populate with most important predictors
end

mfcctesttrimmed = zeros(size(mfcctest,1),1);                     %empty trimmed mfcc array

for l = 1:1:predictors
    mfcctesttrimmed(:,l)=mfcctest(:,idx(l));        %populate with most important predictors
end                                        
                                       
figure(1);
bar(idx,weights);                       %plot relieff weights (unsorted)
xlabel('Feature index');
ylabel('Weight');
title('Predictor Weights (unsorted)');

figure(2);
bar(weights(idx));                      %plot relieff weights (sorted)
xlabel('Feature index (sorted)');
ylabel('Weight');
title('Predictor Weights (sorted)');

Mdl=fitcknn(mfcctraintrimmed,trainLabels, "Numneighbors", Numneighbors);
Mdl2=fitcknn(mfccTrain,trainLabels, "Numneighbors", Numneighbors);

predicted = predict(Mdl,mfcctesttrimmed);                  
predicted2 = predict(Mdl2,mfcctest);                       

figure(3);
confusionchart(actual,predicted);    
title('Confusion Matrix (K=10, # predictors=3000)');            %with relieff

figure(4);
confusionchart(actual,predicted2);
title('Confusion Matrix (K=10, # predictors=all)');             %without relieff
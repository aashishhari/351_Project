%% EECS351 Team 12 Demo lite 
clear;
close all;

load("trainedMdl_demo_lite.mat");       %To save time, we directly load 
                                        %variables of interest obtained 
                                        %from running 'LoadTrainingData.m',
                                        %'LoadTestingData.m', and
                                        %'Testing.m' sequentially.

Numneighbors = 10;
                                       
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
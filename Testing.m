%% EECS351 Project test

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

Mdl=fitcknn(mfcctraintrimmed,trainLabels, "Numneighbors", Numneighbors);

predicted = predict(Mdl,mfcctesttrimmed);                       %predict for test array with trained model

confusionchart(actual,predicted)    

%% EECS351 Project test
%{
Numneighbors = 3;
[idx,weights]=relieff(mfccTrain,trainLabels,Numneighbors);             %Determine most important KNN predictors
predictors = 2500;                                          %Decide predictor cutoff

mfcctraintrimmed = zeros(size(trainLabels,1),1);                            %empty matrix for trimmed mfcc, hard coded

for k = 1:1:predictors
    mfcctraintrimmed(:,k)=mfccTrain(:,idx(k));              %populate with most important predictors
end

mfcctesttrimmed = zeros(size(TESTfiles,1),1);                     %empty trimmed mfcc array

for l = 1:1:predictors
    mfcctesttrimmed(:,l)=mfcctest(:,idx(l));        %populate with most important predictors
end
%}
%Mdl=fitcknn(mfcctraintrimmed,trainLabels,"NumNeighbors",Numneighbors);         %train model
Mdl=fitcecoc(mfccTrain,trainLabels);



%predicted = predict(Mdl,mfcctesttrimmed);                       %predict for test array with trained model
predicted = predict(Mdl,mfcctest);                       %predict for test array with trained model

confusionchart(actual,predicted)    

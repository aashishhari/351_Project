# Welcome to the EECS 351 Language Detection Project

## What are we doing?
In this repo, we're attempting to classify different languages based on short audio recordings from the Mozilla Common Voice Dataset: https://commonvoice.mozilla.org/en/datasets.

Here, we extract MFCC features and pitch, and next apply a machine learning algorithm, specificallyKNN, to classify our samples. In the past, we've tried SVM (Support Vector Machine) and binary classification but found KNN gives us the best results. In the future, we've considered to potentially implement GMM (Guassian Mixture Modeling) for hopefully an increase in accuracy.


## What's in this repo?

**demo.m** - This file takes a short bit to run, but takes the results generated from `loadTestingData.m` and `loadTrainingData.m` and computes a KNN model for the data **using** the relieff function 

**demo_lite.m** - T

**PitchAnalysis.m** - 

**testing.m:** - 

**loadTestingData.m:** - 

**loadTrainingData.m:** - 


> Contributors: Aashish Harikrishnan, Daniel Li, Andrew Lyandar, Shantanu Purandare

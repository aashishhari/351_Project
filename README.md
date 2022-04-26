# Welcome to the EECS 351 Language Detection Project

## What are we doing?
In this repo, we're attempting to classify different languages based on short audio recordings from the Mozilla Common Voice Dataset: https://commonvoice.mozilla.org/en/datasets.

Here, we extract MFCC features and pitch, and next apply a machine learning algorithm, specificallyKNN, to classify our samples. In the past, we've tried SVM (Support Vector Machine) and binary classification but found KNN gives us the best results. In the future, we've considered to potentially implement GMM (Guassian Mixture Modeling) for hopefully an increase in accuracy.


## What's in this repo?

**demo.m** - This file takes a short bit to run, ~90seconds, but reads the pre-generated results from `loadTestingData.m` and `loadTrainingData.m` and computes a KNN model for the data **using** the relieff function. Additionally, it generates a bar graph and two confusion charts.

**demo_lite.m** - This file is the same and produces the same output plots/results, but **does not** use the relieff function and therefore the runtime is shorter, a few seconds.

**PitchAnalysis.m** - This file extracts the Pitch features of the audio samples.

**testing.m:** - This file is the original script of `demo.m` and uses the workspace variables generated from 'loadTestingData.m` and `loadTrainingData.m` instead of using a pre-generated dataset.

**loadTrainingData.m:** - This file loads in the train mp3 audio files used for training and does some preprocessing (normalization, mfcc extraction).

**loadTestingData.m:** - This file does the same as above but using the test mp3 files.



> Contributors: Aashish Harikrishnan, Daniel Li, Andrew Lyandar, Shantanu Purandare

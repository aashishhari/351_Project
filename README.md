# Welcome to the EECS 351 Language Detection Project

## What are we doing?
In this repo, we're attempting to classify different languages based on short audio recordings from the Mozilla Common Voice Dataset: https://commonvoice.mozilla.org/en/datasets.

Here, we extract MFCC features and pitch, and next apply a machine learning algorithm, specificallyKNN, to classify our samples. In the past, we've tried SVM (Support Vector Machine) and binary classification but found KNN gives us the best results. In the future, we've considered to potentially implement GMM (Guassian Mixture Modeling) for hopefully an increase in accuracy.


## What's in this repo?

**demo.m** - This file takes a short bit to run, ~90seconds, but reads the pre-generated results from `loadTestingData.m` and `loadTrainingData.m` and computes a KNN model for the data **using** the relieff function. Additionally, it generates a bar graph and two confusion charts.

**demo_lite.m** - This file is the same and produces the same output plots/results, but **does not** use the relieff function and therefore the runtime is shorter, a few seconds.

**PitchAnalysis.m** - This file extracts the Pitch features of the audio samples.

**testing.m:** - This file is the original script of `demo.m` and uses the workspace variables generated from `loadTestingData.m` and `loadTrainingData.m` instead of using a pre-generated dataset.

**loadTrainingData.m:** - This file loads in the train mp3 audio files used for training and does some preprocessing (normalization, mfcc extraction).

**loadTestingData.m:** - This file does the same as above but using the test mp3 files.

## ZIP file
The corresponding datasets can be found in our ZIP file. The structure of the ZIP is indicated below:

In this ZIP:

/CN/ - Training .mp3 files (Mandarin)
||-> audioNormalization_YW.m - Normalization code, courtesy Yi-Wen Chen (https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab)
||-> .mp3 files

/Demo/ - Directory for demos and relevant data
- ||-> Demo.m - Project demo (includes relieff computation)
- ||-> Demo_lite.m - Project demo (loads pre-calculated relieff output)
- ||-> trainedMdl_demo.mat - Data loaded by Demo.m
- ||-> trainedMdl_demo_lite.mat - Data loaded by Demo_lite.m

/EN/ - Training .mp3 files (English)
||-> audioNormalization_YW.m - Normalization code, courtesy Yi-Wen Chen (https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab)
||-> .mp3 files

/HN/ - Training .mp3 files (Hindi)
||-> audioNormalization_YW.m - Normalization code, courtesy Yi-Wen Chen (https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab)
||-> .mp3 files

/Testfiles/ - .mp3 files for predicting (all 3 languages)
||-> audioNormalization_YW.m - Normalization code, courtesy Yi-Wen Chen (https://www.mathworks.com/matlabcentral/fileexchange/69958-audio-normalization-by-matlab)
||-> .mp3 files

LoadTestingData.m - Used for pre-loading all test .mp3 files

LoadTrainingData.m - Used for pre-loading all training .mp3 files

README.m - Readme file

Testing.m - Used for training models and predicting, outputs confusion matrix

## Contributors
Aashish Harikrishnan, Daniel Li, Andrew Lyandar, Shantanu Purandare

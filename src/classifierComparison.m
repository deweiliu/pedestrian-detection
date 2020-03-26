% Script to compare classifiers

%% Set up Environment
setupEnvir;

%% parameters
OUTPUT_DIR = fullfile(output, "classifier_comparison");
makedir(OUTPUT_DIR);

%% Training images Pre-processing
positives = preprocessing(positives);
negatives = preprocessing(negatives);

%% Feature Extraction on training set
allFeatures = featureExtraction(positives, negatives);
features = allFeatures.HOG(:, 3:end);
labels = allFeatures.HOG(:, 1);
labels = logical(tableToArray(labels));

%% random forest model parameter tuning
% Tunning parameter
rfFigure = rfParaTuning(features, labels);
filePath = fullfile(OUTPUT_DIR, 'random_forest_param_tunning.svg');
saveas(rfFigure, filePath);
fprintf("RF graph saved at %s\n", filePath);

%% random forest model
OPTIMISED_NUM_TREES = 30;
rfModel = randomForestTrain(features, labels, OPTIMISED_NUM_TREES);
rfPredictions = rfTest(rfModel);
rfConfusion = confusionchart(labels, rfPredictions);
title("Random Forest Confusion Matrix");
filePath = fullfile(OUTPUT_DIR, 'random_forest_confusion_matrix.svg');
saveas(rfConfusion, filePath);
fprintf("RF confusion matrix saved at %s\n", filePath);

%% svm model parameter tuning
svmParaTuning(allFeatures.HOG)
% Best parameters are selected
% BoxConstraint    KernelScale
% 1.2541           0.3364 

%% svm model testing
svmModel = svmTrain(allFeatures.HOG);
svmTest(svmModel)

% using cross validation on confusion matrix
crossValModel = crossval(svmModel);
svmPredictions = logical(kfoldPredict(crossValModel));
svmConfusion = confusionchart(labels, svmPredictions);
title("SVM Confusion Matrix");
filePath = fullfile(OUTPUT_DIR, 'svm_confusion_matrix.jpg');
saveas(svmConfusion, filePath);
fprintf("SVM confusion matrix saved at %s\n", filePath);

%% knn model parameter tuning
% Tunning parameter
knnFigure = knnParaTuning(features, labels);
filePath = fullfile(OUTPUT_DIR, 'knn_param_tunning.jpg');
saveas(knnFigure, filePath);
fprintf("KNN graph saved at %s\n", filePath);

%% knn model testing
K_VALUES = 41;
knnModel = knnTrain(features, labels, K_VALUES);
knnTest(knnModel)
knnPredictions = logical(resubPredict(knnModel));
knnConfusion = confusionchart(labels, knnPredictions);
title("KNN Confusion Matrix");
filePath = fullfile(OUTPUT_DIR, 'knn_confusion_matrix.jpg');
saveas(knnConfusion, filePath);
fprintf("KNN confusion matrix saved at %s\n", filePath);

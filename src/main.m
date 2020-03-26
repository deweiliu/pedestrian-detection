% Main matlab script

%% Set up Environment
setupEnvir;

%% Training images Pre-processing
positives = preprocessing(positives);
negatives = preprocessing(negatives);

%% Visualize processing images
IMAGE_INDEX = 1;
% If parameter is positives, IMAGE_INDEX must not exceed 2003.
% If parameter is negatives, IMAGE_INDEX must not exceed 997.
visualizeProcessingImages(positives, IMAGE_INDEX)

%% Feature Extraction on training set
features = featureExtraction(positives, negatives);

%% train svm model
svmModel = svmTrain(features.HOG);

%% Sliding windows
SLIDING_WIDTH = positives.nColumns;
SLIDING_HEIGHT = positives.nRows;
SLIDING_SCALES = [0.8, 1.2, 1.6, 2];
SLIDING_GAP_PERCENTAGE = 0.4; % 40 per cent
pedestrians.sliding = slidingwindows(pedestrians, SLIDING_WIDTH, SLIDING_HEIGHT, SLIDING_SCALES, SLIDING_GAP_PERCENTAGE);

%% Generating features for all testing images creating by sliding windows
pedestrians = featureExtractorPedestrians(pedestrians);

%% Making prediction on all testing images by fitted model (SVM KNN)
pedestrians = pedestriansPredictor(pedestrians, svmModel);

%% Extract information of pedestrians
THRESHOLD = 2; % Greater or equal to 1, integer
LABELLING_CONNECTIVITY = 4; % 8 or 4  # See https://uk.mathworks.com/help/images/ref/bwlabel.html
pedestrians.results = informationExtraction(pedestrians, THRESHOLD, LABELLING_CONNECTIVITY);

%% Visualize sliding windows images which are predicted as positive
FRAME_INDEX = 20; % It can be 1 to 100 corresponding which frame to visualize
visualizePrediction(pedestrians, FRAME_INDEX);

%% present the result
% Re-run this block to redisplay the result
FRAME_PER_SECOND = 5;
presentation(pedestrians, FRAME_PER_SECOND);

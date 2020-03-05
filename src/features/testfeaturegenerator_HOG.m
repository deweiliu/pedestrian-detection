%% Parameters
% input_image(image) - each image generated by sliding windows
%% Returns
% feature(matrix) - the feature generated by HOG of each image generated by sliding windows
function [features] = testfeaturegenerator_HOG(input_image)
[featureVector,~] = extractHOGFeatures(input_image,'CellSize',[12,12]);
features = featureVector;
end


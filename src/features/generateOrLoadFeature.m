function [result] = generateOrLoadFeature(metaTable, positives, negatives, file, featureFunc, args)
    if ~exist(file, "file") == 0
        fprintf('Found "%s" feature file, skipping generation and loading from file\n', file);
        result = readtable(file);
    else
        fprintf('No "%s" feature file found, generating a new one\n', file);
        result = [];
        fprintf('Generating features for positive data\n');
        for i=1:length(positives.images)
            image = positives.images(:,:,:,i);
            result = [result; featureFunc(image, args{:})];
        end
        fprintf('Generating features for negative data\n');
        for i=1:length(negatives.images)
            image = negatives.images(:,:,:,i);
            result = [result; featureFunc(image, args{:})];
        end
        
        % Convert to table
        result = array2table(result);
        
        % Add metadata (labels and image names)
        result = [metaTable, result];
        
        fprintf('Saving feature file...\n');
        writetable(result, file);
        fprintf('Finished saving "%s" feature file\n', file);
    end
end

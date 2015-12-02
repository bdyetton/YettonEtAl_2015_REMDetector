function featureMatrix = genFeaturesToTest(featureTable,featureNames)
    featureMatrix = zeros(size(featureNames,2),0);
    for col = 1:size(featureTable,2)
        featureMatrix = [featureMatrix ismember(featureNames,featureTable.(col))];
    end
end
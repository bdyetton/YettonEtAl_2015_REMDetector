function labels = classifyREM(completeSet)
    addpath(genpath([pwd '/ECOC/ECOC Library CODE 0.1']));
    load('ECOCSettings.mat')
    featuresToUse = genFeaturesToTest(readtable([pwd '/featuresToUseE.csv'],'ReadVariableNames',false),completeSet.featureNames);
    data2classify = completeSet.extractedFeatures(logical(featuresToUse(:,1)),:);
    warning('off','all');
    [result,confusion,labels]=Decoding([data2classify' zeros(size(data2classify',1),1)],classes,ECOC,'ADA','classifiers','LAP');
    warning('on','all');
end

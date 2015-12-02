%------Load detectors file---------------------------------
load('../Data/WorkingData/allDetectorResults4.mat','-mat')

%------import mat files and score data---------------------
load('../Data/WorkingData/dataSet3.mat','-mat');
numSubs = 5;
detectorNames = fieldnames(allDetectorResults);

for i = 1:length(detectorNames)
    detector = detectorNames{i,1};
    fprintf('Checking detector: %s\n', detector)
    if strncmp(detector,'MachineLearning',length('MachineLearning')) %% dont do machine learners...
        wins = [];
        for subject = 1:numSubs 
            wins = [wins allDetectorResults.(detector).locs{subject}];
        end
        allDetectorStruct.winREMs{i,1} = wins;
        %allDetectorStruct.winRecall{i,1} = allDetectorResults.(detector).meanRecall;
        %allDetectorStruct.winPrecision{i,1} = allDetectorResults.(detector).meanPrecision;
        %allDetectorStruct.winF1{i,1} = calcF1(allDetectorResults.(detector).meanRecall, allDetectorResults.(detector).meanPrecision);
    else
        allDetectorStruct.winREMs{i,1} = zeros(1,length(dataSet.winIndexData));
        for win = 1:length(dataSet.winIndexData)
            sub = dataSet.subjectNum(1,win);
            subLocs = allDetectorResults.(detector).locs{sub};
            temp = subLocs(subLocs >= dataSet.winIndexData{win}(1));
            locsInWindow = temp(temp < dataSet.winIndexData{win}(end)); 
            allDetectorStruct.winREMs{i,1}(win) = length(locsInWindow);
        end
    end
    confuseMat = createConfusion(dataSet.goldStandard,allDetectorStruct.winREMs{i,1});
    [recall,precision,actualREMs,detectedREMs]=trueStats(confuseMat);
    allDetectorStruct.winRecall{i,1} = recall;%sum(allDetectorStruct.winTP{i,1})/(sum(allDetectorStruct.winTP{i,1})+sum(allDetectorStruct.winFN{i,1}));
    allDetectorStruct.winPrecision{i,1} = precision;%sum(allDetectorStruct.winTP{i,1})/(sum(allDetectorStruct.winTP{i,1})+sum(allDetectorStruct.winFP{i,1}));
    allDetectorStruct.winF1{i,1} = calcF1(allDetectorStruct.winRecall{i,1}, allDetectorStruct.winPrecision{i,1});  
end

%mean combination
comb = zeros(size(allDetectorStruct.winREMs{1,1}));
for i = 1:length(detectorNames)
    comb = comb + allDetectorStruct.winREMs{i,1};  
end
comb = round(comb./length(detectorNames));
comb(comb==4)=3;
%comb(comb==3)=2;
allDetectorResults.CombinatoryAlgorithmAv.locs = comb;
confuseMat = createConfusion4Class(dataSet.goldStandard,comb);
%[recall,precision]=trueStats(confuseMat)
%f1 = calcF1(recall,precision)

%weighted combination
comb = zeros(size(allDetectorStruct.winREMs{1,1}));
F1Total = 0;
for i = 1:length(detectorNames)
    comb = comb + allDetectorStruct.winREMs{i,1}.*allDetectorStruct.winF1{i,1};  
    F1Total = F1Total + allDetectorStruct.winF1{i,1};
end
comb = comb./F1Total;
comb(comb>2.9) = 3;
comb((comb<=2.9) & (comb>1.75)) = 2;
%comb(comb>1.9) = 2;
comb((1.75>=comb) & (comb>0.45)) = 1;
comb(comb<=0.45) = 0;
allDetectorResults.CombinatoryAlgorithmF1.locs = comb;

confuseMat = createConfusion4Class(dataSet.goldStandard,comb)
[recall,precision]=trueStats(confuseMat)
f1 = calcF1(recall,precision)
save('../Data/WorkingData/allDetectorResults5','allDetectorResults')
    


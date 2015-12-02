function output = featureExtractFreq_shannonEntropy(inputFreqArray)
    output = -sum(abs(inputFreqArray).*log2(abs(inputFreqArray)));
end
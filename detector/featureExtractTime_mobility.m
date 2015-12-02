function output = featureExtractTime_mobility(inputArray)
%This feature is defined as the standard deviation of the first derivative of signal to that of the original signal
output = std(diff(inputArray))/std(inputArray);
end
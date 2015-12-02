function output = featureExtractTime_complexity(inputArray)
%Complexity. This feature is defined as the ratio of the mobility of the first derivative of signal to the mobility of signal
mobilitySig = std(diff(inputArray))/std(inputArray);
mobilityDev = std(diff(diff(inputArray)))/std(diff(inputArray));
output = mobilityDev/mobilitySig;
end
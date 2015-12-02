function output = featureExtractTime_coastline(inputArray)
%Coastline. This feature is defined as the sum of the absolute values of
%distances from one data point to the next and can be expressed as:
output = sum(inputArray(2:end) - inputArray(1:(end-1)));
end
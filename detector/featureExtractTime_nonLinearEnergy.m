function output = featureExtractTime_nonLinearEnergy(inputArray)
    %nonLinearEnergy. 
    temp = sum(inputArray(2:(end-1)).^2 - inputArray(1:(end-2)).*inputArray(3:end));
    output = 1/(length(inputArray)-2)*temp;
end
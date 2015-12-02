function [riseAngle,riseSlope] = riseSlope(sig)
%find the rise slope across a signal (in degrees)
    derivOfSig = [0 zscore(diff(sig))]; %first point has not idff
    windowSize = 51;
    riseSlope = zeros(size(sig));
    riseAngle = zeros(size(sig));
    for i = (windowSize+1):(length(derivOfSig)-windowSize)
        riseSlope(i) = mean(derivOfSig((i-windowSize):i));
        riseAngle(i) = atan2d(riseSlope(i),1);
   end
end
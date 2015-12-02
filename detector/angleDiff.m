function angleDiff = angleDiff(sig)
%find the angle of kink at all points on a signal
    derivOfSig = [0 zscore(diff(sig))]; %first point has not idff
    angleDiff = zeros(size(derivOfSig));
    windowSize = 51;
    for i = (windowSize+1):(length(derivOfSig)-windowSize)
        riseSlope = mean(derivOfSig((i-windowSize):i));
        fallSlope = mean(derivOfSig(i:(i+windowSize)));
        riseAngle = atan2d(riseSlope,1);
        fallAngle = atan2d(fallSlope,1);
        angleDiff(i) = abs(riseAngle - fallAngle);
   end
end
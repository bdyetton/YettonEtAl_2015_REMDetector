function locs = findControlPoints(derivOfSig,angleCriteron)
%find the points where the riseslope and fallslope of a location kink at 90
%degrees (or pi rads). AngleCriterion is in radians, and should be pi for
%doman study
    locs = [];
    windowSize = 32;
    for i = (windowSize+1):(length(derivOfSig)-windowSize)
        riseSlope = mean(derivOfSig((i-windowSize):i));
        fallSlope = mean(derivOfSig(i:(i+windowSize)));
        riseAngle = atan2(riseSlope,1);
        fallAngle = atan2(fallSlope,1);
        if abs(fallAngle-riseAngle) > angleCriteron
            locs(end+1) = i;
        end
    end
end
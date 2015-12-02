function [peak,width,prom,riseSlope,fallSlope,isPeakNeg] = featureExtractTime_amplitude_P(sig,plotting)
%finds the min and max peaks above thresh
    warning('off','all')
    [peaksMax,peaksMaxLoc,widthMax,promMax] = findpeaks(sig);
    [peaksMin,peaksMinLoc,widthMin,promMin] = findpeaks(-sig);
    if(plotting)
        plot(1:length(sig),sig,peaksMaxLoc,peaksMax,'*g',peaksMinLoc,-peaksMin,'*r')
    end
    [peakMin,locMin] = max(peaksMin);
    [peakMax,locMax] = max(peaksMax);
    peakMaxLoc = peaksMaxLoc(locMax);
    peakMinLoc = peaksMinLoc(locMin);
    
    if isempty(peakMax)
        peakMax = 0;
    end
    
    if isempty(peakMin)
        peakMin = 0;
    end
    
    if abs(peakMax) > abs(peakMin)
        isPeakNeg = false;
        peak = peakMax;
        width = widthMax(locMax);
        prom = promMax(locMax);
        [riseSlope,fallSlope] = slopeHelper(sig,peakMaxLoc,peak,prom,[0.5 1]);
    elseif abs(peakMax) < abs(peakMin)
        isPeakNeg = true;
        peak = peakMin;
        width = widthMin(locMin);
        prom = promMin(locMin);
        [riseSlope,fallSlope] = slopeHelper(-sig,peakMinLoc,peak,prom,[0.5 1]);
    else
        isPeakNeg = false;
        peak=0;
        width=0;
        prom =0;
        riseSlope =0;
        fallSlope =0;
    end
    warning('on','all')
end
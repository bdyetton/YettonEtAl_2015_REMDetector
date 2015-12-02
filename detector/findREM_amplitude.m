function [locs,peaksOut] = findREM_amplitude(sig,thresh)
%finds the min and max peaks above thresh
    warning('off','all')
    sigNeg = sig;
    sigNeg(sigNeg>(-thresh))=0;
    sigPos = sig;
    sigPos(sigPos<thresh)=0;
    [peaksMax,peaksMaxLoc,widthMax,promMax] = findpeaks(sigPos);
    [peaksMin,peaksMinLoc,widthMin,promMin] = findpeaks(-sigNeg);
    peaks = [peaksMax peaksMin];
    [locs,sortIndexs] = sort([peaksMaxLoc peaksMinLoc]);
    peaksOut = peaks(sortIndexs);
%     if(plotting)
%         plot(1:length(sig),sig,peaksMaxLoc,peaksMax,'*g',peaksMinLoc,-peaksMin,'*r')
%     end
%     [peakMin,locMin] = max(peaksMin);
%     [peakMax,locMax] = max(peaksMax);
%     peakMaxLoc = peaksMaxLoc(locMax);
%     peakMinLoc = peaksMinLoc(locMin);
%     if abs(peakMax) > abs(peakMin) %large peak
%         isPeakNeg = false;
%         peak = peakMax;
%         width = widthMax(locMax);
%         prom = promMax(locMax);
%         [riseSlope,fallSlope] = slopeHelper(sig,peakMaxLoc,peak,prom,[0.5 1]);
%     elseif abs(peakMax) < abs(peakMin) %large trough
%         isPeakNeg = true;
%         peak = peakMin;
%         width = widthMin(locMin);
%         prom = promMin(locMin);
%         [riseSlope,fallSlope] = slopeHelper(-sig,peakMinLoc,peak,prom,[0.5 1]);
%     else
%         isPeakNeg = false;
%         peak=0;
%         width=0;
%         prom =0;
%         riseSlope =0;
%         fallSlope =0;
%     end
%     warning('on','all')
end
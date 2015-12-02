function [peakDiff] = featureExtractTime_ampOfDeriv(sig,plotting)
    sigDiff = [0 abs(diff(sig))];
    [peakDiff,locMax]=max(sigDiff);
    if plotting
        plot(1:length(sig),sig,'r-',1:length(sig),sigDiff,'g',locMax,peakDiff,'b*');
    end
end
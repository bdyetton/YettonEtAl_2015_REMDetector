function [sig] = flipIfPeakNeg(sig)
    warning('off','all')
    [peaksMax] = findpeaks(sig);
    [peaksMin] = findpeaks(-sig);
    [peakMin] = max(peaksMin);
    [peakMax] = max(peaksMax);
    if abs(peakMax) < abs(peakMin) %large trough
        sig = -sig;
    end
    warning('on','all')
end
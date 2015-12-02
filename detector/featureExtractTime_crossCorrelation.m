function peakXcor = featureExtractTime_crossCorrelation(sigA,sigB,plotting)
crossCor = xcorr(sigA,sigB);
[peakVal,~] = findpeaks(crossCor);
if isempty(peakVal)
    peakXcor = 0;
else
    peakXcor = max(peakVal);
end
if plotting
    subplot(3,1,1)
    plot(sigA)
    subplot(3,1,2)
    plot(sigB)
    subplot(3,1,3)
    plot(1:length(crossCor),crossCor,find(crossCor == peakXcor),peakXcor,'*')
end
   
end
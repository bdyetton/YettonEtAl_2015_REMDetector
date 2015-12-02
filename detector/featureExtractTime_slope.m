function [rise,fall] = featureExtractTime_slope(sig,samplesRise,samplesFall,plotting)
    [peaksPos,peakLocArrayPos] = findpeaks(sig);     
    [peaksNeg,peakLocArrayNeg] = findpeaks(-sig);
    if max(peaksPos) > max(peaksNeg)
        peak = max(peaksPos);
        peakLoc = peakLocArrayPos(peak==peaksPos);      
    else
        peak = -max(peaksNeg);
        peakLoc = peakLocArrayNeg(-peak==peaksNeg);
    end
   
    if peakLoc > samplesRise
        riseStart = (peakLoc-samplesRise);
    else
        riseStart = 1;
    end
    riseSig = sig(riseStart:peakLoc);
    
    if peakLoc+samplesFall < length(sig)
        fallEnd = peakLoc+samplesFall;
    else
        fallEnd = length(sig);
    end
    fallSig = sig(peakLoc:fallEnd);
    
    %deal with corner cases
    if ~isempty(riseSig) %peak is at the start of the window, so we cant calc a rise...
        riseCoeff = polyfit(1:length(riseSig),riseSig,1);
        rise = riseCoeff(1);
    else
        rise = 0;
    end
    if ~isempty(fallSig)
        fallCoeff = polyfit(1:length(fallSig),fallSig,1);
        fall = fallCoeff(1);
    else
        fall = 0;
    end

    if plotting
        plot(1:length(sig),sig,'-',riseStart:peakLoc,polyval([rise (-length(riseSig)*rise+peak)],1:length(riseSig)),'--',...
            peakLoc:fallEnd,polyval([fall peak],1:length(fallSig)),'--')
    end    
end
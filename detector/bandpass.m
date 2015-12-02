function sig = bandpass(sig,highCutoff, lowCutoff,sampleRate)
    if ~exist('sampleRate')
        sampleRate = 256;
    end
    if (highCutoff) 
        sig = passFilter(sig,sampleRate,highCutoff,'low',40); 
    end;
    if (lowCutoff) 
        sig = passFilter(sig,sampleRate,lowCutoff,'high',40); 
    end;
end
function lables = windowize(locsInSamples,windowBounds)
%WINDOWIZE take REM locations (in samples) and convert to num REM movements per window,
%where window is a cell array of window
    lables = zeros(1,length(windowBounds));
    for win = 1:length(windowBounds)
        temp = locsInSamples(locsInSamples >= windowBounds{win}(1));
        locsInWindow = temp(temp < windowBounds{win}(end)); 
        REMs = length(locsInWindow);
        lables(win) = REMs;
    end
end


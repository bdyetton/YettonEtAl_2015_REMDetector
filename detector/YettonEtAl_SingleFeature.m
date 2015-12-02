function locs = SingleFeatureREMReqs(LOCAndROCSig)
locs = [];        
%%filtering
sigLeft = bandpass(LOCAndROCSig(1,:),8,0.5);
sigRight = bandpass(LOCAndROCSig(2,:),8,0.5);

%% Find potential REM
[LOClocs, LOCpeaks] = findREM_amplitude(sigLeft,36);
[ROClocs, ROCpeaks] = findREM_amplitude(sigRight,36);

%% Combine LOC/ROC
if length([LOClocs ROClocs]) < 2
    return;
else
    [locs, channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[LOCpeaks ROCpeaks],0,20);
end

end
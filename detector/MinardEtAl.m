function locs = MinardREMReqs(LOCAndROCSig)
locs = []; 
%This file replicates the amp and filtering method employed by Minard & Krausman, 1971

%Requirements for REM:
% - Bandpass LOC and ROC (0.3Hz – 8Hz)
% - Rise slope requriements
% - Out of phase requirements
% - Synchrony to 50ms

        
        %% filtering
sigLeft = bandpass(LOCAndROCSig(1,:),8,0.3);
sigRight = bandpass(LOCAndROCSig(2,:),8,0.3);

%% find rise slope
riseSlopeLeft = riseSlope(sigLeft);
riseSlopeRight = riseSlope(sigRight);    

%% Find potential REM
[LOClocs, LOCpeaks] = findREM_amplitude(riseSlopeLeft,50);
[ROClocs, ROCpeaks] = findREM_amplitude(riseSlopeRight,50);

%% Combine LOC/ROC
if length([LOClocs ROClocs]) < 2
    disp('Signal amplitue to low')
    return;
end


[locs,channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[LOCpeaks ROCpeaks],0,12.8);
%enforce syncrony
locs = locs(channels(:,1) & channels(:,end));

%% Out of phase requirement
locs = locs((sigLeft(locs)>0) ~= (sigRight(locs)>0));
end

function locsOut = ThresholdingMethodREMReqs(LOCAndROCSig)
locsOut = []; 
%This file replicates the amp and filtering method employed by Agarwal et
%al 2005

%Requirements for REM:
% - Bandpass LOC and ROC (1Hz – 5Hz)
% - Amplitude requirement on negative product of LOC and ROC
% - Cross correlation requirement
% - Slope angle requirement (kink)
% - Basic Artifact rejection

%% filtering
sigLeft = bandpass(LOCAndROCSig(1,:),5,0.5);
sigRight = bandpass(LOCAndROCSig(2,:),5,0.5);

%% Get Angle 
angleDiffSigLeft = angleDiff(sigLeft);
angleDiffSigRight = angleDiff(sigRight);    
    
 %% Find potential REM
[LOClocs, peaks] = findREM_amplitude(sigLeft,21.2);
[ROClocs, peaks] = findREM_amplitude(sigRight,21.2);

%% Combine LOC/ROC
if length([LOClocs ROClocs]) < 2
    return;
else
[locs,channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[sigLeft(LOClocs) sigRight(ROClocs)],0,30);

%% Enfornce Syncrony
locs = locs(channels(:,1) & channels(:,2));
end
        
%% Cross correlation criterons
L = 128; %window 1/2 size was 0.5 secs
xCorrAtLoc = zeros(size(locs));
ticker = 0;
for loc = 1:length(locs)
    ticker = ticker + 1;
    winStart = locs(loc) - L;
    winEnd = locs(loc) + L;
    if winStart < 1 continue; end
    if winEnd > length(sigLeft) continue; end
    xCorrAtLoc(ticker) = max(xcorr(sigLeft(winStart:winEnd),-sigRight(winStart:winEnd)));        
end                    
xCorrReq = xCorrAtLoc>7000;

%angle requirements       
angleDiffAtLocLeft = angleDiffSigLeft(int32(locs));
angleDiffAtLocRright = angleDiffSigRight(int32(locs));
angleReq = (angleDiffAtLocLeft > 76) & (angleDiffAtLocRright > 76);
            
%% dwt criterons
L = 256;
dwtAtLoc = zeros(size(locs));
ticker = 0;
for loc = 1:length(locs)
    ticker = ticker + 1;
    winStart = locs(loc) - L;
    winEnd = locs(loc) + L;
    if winStart < 1 continue; end
    if winEnd > length(sigLeft) continue; end
    dwtAtLoc(ticker) = max(dwtHaarTransform(sigLeft(winStart:winEnd))); %TODO try both left and right.        
end
        
dwtReq = dwtAtLoc>2.2;

%% artifact rejection (> 500uV)
artReq = (sigLeft(locs) < 500 | sigRight(locs) < 500);

% combine requirements and apply to REM locations
allReq = angleReq' & dwtReq & artReq' & xCorrReq;
locsOut = locs(allReq);
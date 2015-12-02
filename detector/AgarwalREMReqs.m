function locs = AgarwalREMReqs(LOCAndROCSig)
locs = []; 
%This file replicates the amp and filtering method employed by Agarwal et
%al 2005

%Requirements for REM:
% - Bandpass LOC and ROC (1Hz – 5Hz)
% - Amplitude requirement on negative product of LOC and ROC
% - Cross correlation requirement
% - Slope angle requirement (kink)
% - Basic Artifact rejection

%% filtering
sigLeft = bandpass(LOCAndROCSig(1,:),5,1);
sigRight = bandpass(LOCAndROCSig(2,:),5,1);

%% Create Negative product
sigNegP = -sigLeft.*sigRight;

%% Cross correlation criterons
L = 128; %window 1/2 size was 0.5 secs
xcorrSig = zeros(size(sigLeft));
for i = (L+1):(length(sigLeft)-L)
    xcorrSig(i) = max(xcorr(sigLeft((i-L):(i+L)),-sigRight((i-L):(i+L))));        
end

%% Get Angle 
angleDiffSigLeft = angleDiff(sigLeft);
angleDiffSigRight = angleDiff(sigRight);

     %% Find potential REM
[locs, peaks] = findREM_amplitude(sigNegP,320);

xCorrAtLoc = xcorrSig(int32(locs));
xCorrReq = xCorrAtLoc>7200;
        
%angle requirements       
angleDiffAtLocLeft = angleDiffSigLeft(int32(locs));
angleDiffAtLocRright = angleDiffSigRight(int32(locs));

angleCrit1 = (angleDiffAtLocLeft > 45) & (angleDiffAtLocRright > 45);
angleCrit2 = (angleDiffAtLocLeft > 30) & (angleDiffAtLocRright > 60);
angleCrit3 = (angleDiffAtLocLeft > 60) & (angleDiffAtLocRright > 30);
angleReq = angleCrit1 | angleCrit2 | angleCrit3;

%% artifact rejection (> 500uV)
artReq = (sigLeft(locs) < 500 | sigRight(locs) < 500);

% combine requirements and apply to REM locations
allReq = angleReq & xCorrReq & artReq;
locs = locs(allReq);
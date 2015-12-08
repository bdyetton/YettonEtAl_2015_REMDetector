function [locs] = SmithREMReqs(LOCAndROCSig)
locs = []; 
%This file replicates the amp and filtering method employed by Ktonas and
%Smith 1978

%Requirements for REM:
% - Bandpass LOC and ROC (0.3Hz – 8Hz)
% - 50uV in one channel
% - 30uV in the other
% - Out of phase, syncronous (conjugate)

%%filtering
sigLeft = bandpass(LOCAndROCSig(1,:),8,0.3);
sigRight = bandpass(LOCAndROCSig(2,:),8,0.3);

%% Find potential REM
[LOClocs, LOCpeaks] = findREM_amplitude(sigLeft,26);
[ROClocs, ROCpeaks] = findREM_amplitude(sigRight,26);

%% Combine LOC/ROC
if length([LOClocs ROClocs]) < 2
   return;
else
[locs,channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[LOCpeaks ROCpeaks],0,12.6);

%% Enfornce Syncrony
locs = locs(channels(:,1) & channels(:,end));
end

%% Out of phase requirement
locs = locs((sigLeft(locs)>0) ~= (sigRight(locs)>0));

%% Threshold Requirements (one channel over 30uV, other channel over 50uV)
locs = locs(((abs(sigLeft(locs)) > 30) & (abs(sigRight(locs)) > 50)) | (abs(sigLeft(locs) > 50) & abs(sigRight(locs) > 30)));

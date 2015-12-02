function locs = McPartlandREMReqs(LOCAndROCSig)
locs = []; 
%This file replicates the amp and syncrony method employed by McPartland Et
%Al, 1973

%Requirements for REM:
% - Lowpass LOC and ROC (15Hz) 
% - Amplitude over 15uV in both channels
% - Out of phase requirements
% - Synchrony to 65ms
      
%%filtering
sigLeft = bandpass(LOCAndROCSig(1,:),15,0);
sigRight = bandpass(LOCAndROCSig(2,:),15,0);
        
%% Find potential REM
[LOClocs, LOCpeaks] = findREM_amplitude(sigLeft,15);
[ROClocs, ROCpeaks] = findREM_amplitude(sigRight,15);
        
%% Combine LOC/ROC
if length([LOClocs ROClocs]) < 2
    return;
else
    [locs, channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[LOCpeaks ROCpeaks],0,16.2);

    %% Enforce Syncrony
    locs = locs(channels(:,1) & channels(:,end));
end
        
%% Out of phase requirement
locs = locs((sigLeft(locs)>0) ~= (sigRight(locs)>0));
end

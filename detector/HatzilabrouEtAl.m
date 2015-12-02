function locs = HatzilREMReqs(LOCAndROCSig)
locs = []; 
%This file replicates the matched filtering method employed by Hatzilabrou et al, 1994 

%Requirements for REM:
% - Bandpass filter (0.5-10Hz), 
% - windowize
% - Remove DC offset
% - Smooth using hamming window
% - Compare smoothed window to template REM via Magnitude Squared Correlation
load('templateREM.mat','-mat');    
%%filtering
sigLeft = bandpass(LOCAndROCSig(1,:),25,0);
sigRight = bandpass(LOCAndROCSig(2,:),25,0);

%% Windowize
L = 128;
cL = zeros(size(sigLeft));
cR = zeros(size(sigRight));
for i=(1+L):(length(sigLeft)-L) %windowize
    currentWinL = sigLeft((i-L):(i+L-1));
    currentWinR = sigRight((i-L):(i+L-1));
    currentWinL = zscore(currentWinL); %power normalize, zero offset
    currentWinR = zscore(currentWinR); 
    hamWinL = hamming(2*L).*currentWinL';
    hamWinR = hamming(2*L).*currentWinR';
    template = templateREM(1,1:256);
    hamTemplate = hamming(2*L).*template';
    cL(i) = sum(hamTemplate'.*hamWinL',2)/sum(hamTemplate'.*hamTemplate',2);
    cR(i) = sum(hamTemplate'.*hamWinR',2)/sum(hamTemplate'.*hamTemplate',2);
end
negProduct = -cL.*cR;

%% Find potential REM
[locs, peaks] = findREM_amplitude(negProduct,0.0005);

%% Monocular test
locs = locs((abs(sigLeft(locs)) > 23) & (abs(sigRight(locs)) > 23));
end
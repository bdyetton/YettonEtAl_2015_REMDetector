function locs = DomanEtAl(LOCAndROCSig)
%This file replicates the amp and filtering method employed by Doman et
%al 1995

%Requirements for REM:
% - Lowpass filter (8Hz)
% - Find points where slope changes 90 degrees in one channel. 
% - Label these as REM if it is high amplitude, 
%   and there is a synchronous, high amplitude, 
%   opposite polarity signal in other channel

%%Filtering
sigLeft = bandpass(LOCAndROCSig(1,:),8,0);
sigRight = bandpass(LOCAndROCSig(2,:),8,0);

%% differentiate
diffLeft = zscore(diff(sigLeft));
diffRight = zscore(diff(sigRight));

%% find control points
controlPointsLeft = findControlPoints(diffLeft,pi()/2);
controlPointsRight = findControlPoints(diffRight,pi()/2);

%% Remove bad control points
LOClocs = testControlPoints(controlPointsLeft,controlPointsRight,sigLeft(controlPointsLeft),sigRight(controlPointsRight));
ROClocs = testControlPoints(controlPointsRight,controlPointsLeft,sigRight(controlPointsRight),sigLeft(controlPointsLeft));
             
[locs,channels] = clusterLocs([LOClocs ROClocs],[ones(size(LOClocs))*1 ones(size(ROClocs))*2],[sigLeft(LOClocs) sigRight(ROClocs)],0,16);

%% Enforce Syncrony 
locs = locs(channels(:,1) & channels(:,2));
        
end
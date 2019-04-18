function [locsInSeconds, numRemInWindow, windowStartsInSeconds, windowEndsInSeconds, density] = runDetectorCommandLine(edfFile, remStartAndEnd, detector2Run,locChannel,rocChannel)
%% detectors2Run should be a subset of the following strings, or an empty array []:
if ~exist('detector2Run','var') || isempty(detector2Run)
    detector2Run = 'HatzilabrouEtAl';
end

if ~exist('locChannel','var') 
    locChannel=1;
end

if ~exist('rocChannel','var') 
    rocChannel=2;
end

[hdr, record] = edfread(edfFile);
edf.hdr = hdr;
edf.record = record;
if mean(mean(record,2)) < 0
    record = record*1000;
    warning('Data apears to be recorded in Volts, but should be in milliVolts. Converting V->mV. This warning will only appear once.')
end

if isstr(remStartAndEnd)
    remStartAndEnd = readtable(remStartAndEnd);
    startTimes = remStartAndEnd.StartREM;
    endTimes = remStartAndEnd.EndREM;
else
    startTimes = remStartAndEnd(:,0);
    endTimes = remStartAndEnd(:,1);
end
n_remperiods = length(startTimes);
%Output containers:
numRemInWindowCont = cell(n_remperiods,1);
windowStartsInSecondsCont = cell(n_remperiods,1);
windowEndsInSecondsCont = cell(n_remperiods,1);
locsInSamplesCont = cell(n_remperiods,1);

for remperiod = 1:n_remperiods
    if ((endTimes(remperiod) - startTimes(remperiod)) < 257) %less than one second long
        if (startTimes(remperiod) ~= 0 && endTimes(remperiod) ~=0)
            continue; 
        end
    end
    fprintf('\n Extracting for rem period %i of %i\n', remperiod,length(startTimes)); 
    fprintf('\tLoading Data\n')
    parsedData = importAndParseDataSimple(edf, locChannel,rocChannel,startTimes(remperiod),endTimes(remperiod));
    fprintf('\tRunning %s',detector2Run)
    if strcmp(detector2Run,'YettonEtAl_MachineLearning')               
        disp('         YettonEtAl_MachineLearning 1 of 2: Extracting features...')
        featureData = extractFeatures(parsedData);
        disp('         YettonEtAl_MachineLearning 2 of 2: Classifing data')
        classifiedData = classifyREM(featureData);
        numRemInWindowCont{remperiod} = classifiedData;
        windowStartsInSecondsCont{remperiod} = cellfun(@(x) x(1)-1, parsedData.winIndexData)/256;
        windowEndsInSecondsCont{remperiod} = cellfun(@(x) x(end)-1, parsedData.winIndexData)/256;
        locsInSamplesCont{remperiod} = nan;
    else
        detector = str2func(detector2Run);
        locsInSamples = detector(parsedData.rawTimeData);
        locsInSamplesCont{remperiod} = locsInSamples;
        numRemInWindowCont{remperiod} = windowize(locsInSamples,parsedData.winIndexData);
        windowStartsInSecondsCont{remperiod} = cellfun(@(x) x(1)-1, parsedData.winIndexData)/256;
        windowEndsInSecondsCont{remperiod} = cellfun(@(x) x(end)-1, parsedData.winIndexData)/256;
    end      
end
locsInSeconds = [locsInSamplesCont{:}]/256;
numRemInWindow = [numRemInWindowCont{:}];
windowStartsInSeconds = vertcat(windowStartsInSecondsCont);
windowEndsInSeconds = vertcat(windowEndsInSecondsCont);
density = remDensity(numRemInWindow); 
end

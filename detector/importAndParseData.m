function dataSet = importAndParseData(psgFileToLoad,locChannel,rocChannel,startREM,endREM)
settings.SAMPLE_RATE = 256; %Sample Rate
settings.SAMPLING_MULTIPLIER = 200; %x2 times 100 for some reason from scoring programs output
settings.LOW_FILTER_CUTOFF_FREQ = 5;
settings.HIGH_FILTER_CUTOFF_FREQ = .3;
settings.FILTER_ATENUATION = 40; %dB
settings.SAME_TIME_SEC = 0.120; %the time differnece we call 'same rem' by other raters (120ms)

settings.WIN_SIZE_SECS = 1; %window size in secs
settings.WIN_SIZE = round(settings.SAMPLE_RATE*settings.WIN_SIZE_SECS); %win size in samples
settings.WIN_OVERLAP_FRACTION = 0; %percentage of window overlap
settings.WIN_OVERLAP = round(settings.WIN_OVERLAP_FRACTION*settings.WIN_SIZE); %window overlab in samples (both sides)
settings.CENTER_PERIOD = settings.WIN_SIZE-settings.WIN_OVERLAP; %the amount of samples between each windows center

%------Read in PSG Data and Filter---------------------
psgData = load(psgFileToLoad,'-mat');
if ~exist('startREM','var') || startREM == 0
   startREM = 1; 
end
if ~exist('endREM','var') || endREM == 0
    endREM = length(psgData.record); 
end


if isstr(locChannel) 
    locChannelNum = find(strcmp(locChannel,psgData.hdr.label));
else
    locChannelNum = locChannel;
end

if isstr(rocChannel) 
    rocChannelNum = find(strcmp(rocChannel,psgData.hdr.label));
else
    rocChannelNum = rocChannel;
end

psgTemp1L = passFilter(psgData.record(locChannelNum,startREM:endREM),settings.SAMPLE_RATE,settings.LOW_FILTER_CUTOFF_FREQ,'low',settings.FILTER_ATENUATION); %20Hz cutoff filter
psgTemp1R = passFilter(psgData.record(rocChannelNum,startREM:endREM),settings.SAMPLE_RATE,settings.LOW_FILTER_CUTOFF_FREQ,'low',settings.FILTER_ATENUATION);
psgTemp2L = passFilter(psgTemp1L,settings.SAMPLE_RATE,settings.HIGH_FILTER_CUTOFF_FREQ,'high',settings.FILTER_ATENUATION); %0.5Hz cutoff highpass filter
psgTemp2R = passFilter(psgTemp1R,settings.SAMPLE_RATE,settings.HIGH_FILTER_CUTOFF_FREQ,'high',settings.FILTER_ATENUATION);
psgChannelDataL = psgTemp2L;
psgChannelDataR = psgTemp2R;

%% Create windows (of raw data and scores)
numSamples = length(psgChannelDataL); %total number of samples
secondsOfSamples = numSamples/settings.SAMPLE_RATE;
minsOfSamples = secondsOfSamples/60;
%Extract features of interest and return threshholded results from raw data
numWindows = floor(numSamples/(settings.WIN_SIZE-settings.WIN_OVERLAP));
featureWindowsIndex = cell(1,numWindows-1);
psgWindowData = cell(2,numWindows-1);
psgWindowFreqData = cell(3,numWindows-1);
%1=left
%2=right
%3=neg product

for winIndex = 1:numWindows-1
    winStart = (winIndex-1)*settings.CENTER_PERIOD+1; %the start of a window in samples
    winEnd = ((winIndex-1)*settings.CENTER_PERIOD)+settings.WIN_SIZE+1;
    psgWindowData{1,winIndex} = psgChannelDataL(winStart:winEnd)-mean(psgChannelDataL(winStart:winEnd)); %remove DC offset
    psgWindowData{2,winIndex} = psgChannelDataR(winStart:winEnd)-mean(psgChannelDataR(winStart:winEnd));
    psgWindowData{3,winIndex} = (-psgWindowData{1,winIndex}).*psgWindowData{2,winIndex};
    psgWindowFreqData{1,winIndex} = fft(psgWindowData{1,winIndex});
    psgWindowFreqData{2,winIndex} = fft(psgWindowData{2,winIndex});
    psgWindowFreqData{3,winIndex} = fft(psgWindowData{3,winIndex});
    featureWindowsIndex{winIndex} = [winStart:winEnd];
end

%% Tidy and printout
% save important vars
dataSet.rawTimeData = [psgData.record(locChannelNum,startREM:endREM) ; psgData.record(rocChannelNum,startREM:endREM)];
dataSet.timeData = psgWindowData;
dataSet.freqData = psgWindowFreqData;
dataSet.winIndexData = featureWindowsIndex;
dataSet.settings = settings;

end

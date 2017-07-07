function runDetector(detectors2Run,locChannel,rocChannel)
%% detectors2Run should be a subset of the following strings, or an empty array []:
if ~exist('detectors2Run','var') || isempty(detectors2Run)
    detectors2Run = {
        'YettonEtAl_MachineLearning',...
        'SmithEtAl',...
        'AgarwalEtAl',...
        'MinardEtAl',...
        'YettonEtAl_SingleFeature',...
        'HatzilabrouEtAl',...
        'YettonEtAl_Threshold'        
        };
end

if ~exist('locChannel','var') 
    locChannel=1;
end

if ~exist('rocChannel','var') 
    rocChannel=2;
end

disp('Converting EDF to mat files')
[edfs,outputLocation] = edf2matMultiSelect();
edfs = edfs(~cellfun(@isempty, edfs));
outputFileName = [outputLocation 'remDetectorOutput' datestr(now, 'dd-mmm-yyyy-hhMM')];
[fileName,filePath]=uigetfile('*.csv','Select Rem start and End .csv file','MultiSelect', 'off');
startAndEnd = true;
if ~fileName
    startAndEnd = false;
else
    remStartAndEnd = readtable([filePath fileName]);
end
windowLabels = cell(length(detectors2Run),length(edfs));
locsInSamples = cell(length(detectors2Run),length(edfs));
windowLocationsInSamples = cell(length(detectors2Run),length(edfs));
i = 1;
for i_edf=1:length(edfs)
    fprintf('Parsing file data ')
    [~,name,~] = fileparts(edfs{i_edf});
    name = [name '.edf'];
    fprintf('\n\n----------Working on %s (file %i of %i)-----------\n',name,i_edf,length(edfs))
    startTimes = [0];
    endTimes = [0];
    if (startAndEnd)
        startTimes = remStartAndEnd.StartREM(strcmp(name,remStartAndEnd.Name));
        endTimes = remStartAndEnd.EndREM(strcmp(name,remStartAndEnd.Name));
        if isempty(startTimes)
            warning('No start and end times found for files, using defaults...');
            startTimes = [0];
            endTimes = [0];
        end
    end
    
    for remperiod = 1:length(startTimes)
        if ((endTimes(remperiod) - startTimes(remperiod)) < 257)
            if (startTimes(remperiod) ~= 0 && endTimes(remperiod) ~=0)
                continue; 
            end
        end
        rem.fileNames{i,1} = [name sprintf('_period%i',remperiod)];
        fprintf('\n%s period %i of %i\n',name,remperiod,length(startTimes)); 
        fprintf('\tLoading Data\n')
        parsedData = importAndParseData(edfs{i_edf},locChannel,rocChannel,startTimes(remperiod),endTimes(remperiod));
        for currentDetector = 1:length(detectors2Run);
            fprintf('\tRunning %s (%i of %i)\n',detectors2Run{currentDetector},currentDetector,length(detectors2Run))
            if strcmp(detectors2Run{currentDetector},'YettonEtAl_MachineLearning')               
                disp('         YettonEtAl_MachineLearning 1 of 2: Extracting features...')
                featureData = extractFeatures(parsedData);
                disp('         YettonEtAl_MachineLearning 2 of 2: Classifing data')
                classifiedData = classifyREM(featureData);
                windowLabels{currentDetector,i} = classifiedData;
                windowLocationsInSamples{currentDetector,i} = parsedData.winIndexData;
            else
                detector = str2func(detectors2Run{currentDetector});
                locsInSamples{currentDetector,i} = detector(parsedData.rawTimeData);
                windowLabels{currentDetector,i} = windowize(locsInSamples{currentDetector,i},parsedData.winIndexData);
                windowLocationsInSamples{currentDetector,i} = parsedData.winIndexData;
            end      
            rem.density(i,currentDetector) = remDensity(windowLabels{currentDetector,i}); 
        end
        i = i+1;
    end
    remTable = struct2table(rem);
    %remTable.Properties.VariableNames = ['fileName' detectors2Run'];
    save([outputFileName '.mat'],'remTable','windowLabels','windowLocationsInSamples','locsInSamples');
    writetable(remTable,[outputFileName '.csv']);
end
end
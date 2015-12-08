function runDetector(detectors2Run)
%% detectors2Run should be a list of 
if ~exist('detectors2Run','var')
    detectors2Run = {
        'YettonEtAl_MachineLearning',...
        'SmithEtAl',...
        'AgarwalEtAl',...
        'MinardEtAl',...
        'DomanEtAl',...
        'YettonEtAl_SingleFeature',...
        'HatzilabrouEtAl',...
        'YettonEtAl_Thresholding'        
        };
end
disp('Converting EDF to mat files')
[edfs,outputLocation] = edf2matMultiSelect();
[fileName,filePath]=uigetfile('*.csv','Select Rem start and End .csv file','MultiSelect', 'off');
startAndEnd = true;
if ~fileName
    startAndEnd = false;
else
    remStartAndEnd = readtable([filePath fileName]);
end
lables = cell(length(detectors2Run),length(edfs));
locs = cell(length(detectors2Run),length(edfs));
i = 1;
for i_edf=1:length(edfs)
    fprintf('Parsing file data ')
    [~,name,~] = fileparts(edfs{i_edf});
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
        parsedData = importAndParseData(edfs{i_edf} ,startTimes(remperiod),endTimes(remperiod));
        for currentDetector = 1:length(detectors2Run);
            fprintf('\tRunning %s (%i of %i)\n',detectors2Run{currentDetector},currentDetector,length(detectors2Run))
            if strcmp(detectors2Run{currentDetector},'YettonEtAl_MachineLearning')               
                disp('         YettonEtAl_MachineLearning 1 of 2: Extracting features...')
                featureData = extractFeatures(parsedData);
                disp('         YettonEtAl_MachineLearning 2 of 2: Classifing data')
                classifiedData = classifyREM(featureData);
                lables{currentDetector,i} = classifiedData;
            else
                detector = str2func(detectors2Run{currentDetector});
                locs{currentDetector,i} = detector(parsedData.rawTimeData);
                lables{currentDetector,i} = windowize(locs{currentDetector,i},parsedData.winIndexData); 
            end      
            rem.density(i,currentDetector) = remDensity(lables{currentDetector,i}); 
        end
        i = i+1;
    end
end
remTable = struct2table(rem);
remTable.Properties.VariableNames = ['fileName' detectors2Run];
save([outputLocation '/remDetectorOutput' datestr(now, 'dd-mmm-yyyy') '.mat'],'remTable','lables');
writetable(remTable,[outputLocation '/remDetectorOutput' datestr(now, 'dd-mmm-yyyy') '.csv']);
end
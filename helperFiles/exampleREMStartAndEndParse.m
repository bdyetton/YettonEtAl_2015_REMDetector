fileName = 'Subject1.xlsx'; %Import the excell scoring file for a specific subject.
[~,subIdentifier,~] = fileparts(fileName);
subStageData = readtable(fileName);
currentStageLabels = {'0','1','2','SWS','REM'}; %This is the stage labels currently used in the .xlsx file
newStageLabels = [0,1,2,3,5]; %These are the stage name the REM chunk/period/bout finder expects Wake=0, stage1=1, stage2 = 2, SWS = 3, REM = 5
%The only stage that is really important to get correct is 5. All REM must be marked with the number
%5
subStageData = changeStageLabels(table2cell(subStageData(:,2)),currentStageLabels,newStageLabels); %This function finds and replaces the 'currentStageLabels' with the corresponding entry of 'newStageLabels'
REMChunks1 = createREMStartAndEndTable(subStageData,subIdentifier); %generate the REMStartAndEnd table for this subject, IMPORTANT: the subIdentier should match there .EDF file name

%If you want, you can put the above in a loop, or concatinate onto the 'REMChunks' table;
%Here is another subject, but this time there stages are manually entered through matlab:
subStageData = [1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 5 5 5 5 5 5 5 5 5 5];
subIdentifier = 'Subject2';
%For this subject, the 
REMChunks2 = createREMStartAndEndTable(subStageData,subIdentifier); %generate the REMStartAndEnd table for this subject, IMPORTANT: the subIdentier should match there .EDF file name

%Combine the 2 subjects into one table
REMChunks = [REMChunks1 ; REMChunks2];

%Write out to file. When running the detector, please point it to this file
writetable(REMChunks,'remStartAndEnd.csv');
function [REMchunks,REMlength] = createREMStartAndEndTable(stages,fileName,sampleRate,epochLength)
%Formats a table for the 'REMStartAndEndFile' sampleing rate should be 256 (default), epoch length defaults to
%30 but could be anything. 'stage' is an array of stages for each epoch like [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 2 2 2 2]. 
if ~exist('sampleRate','var')
    sampleRate = 256;
end
if ~exist('epochLength','var')
    epochLength = 30;
end
if size(stages,1) > size(stages,2)
    stages = stages';
end
out = consecutiveValues(stages);
out = out{1};
REMstart = out.startSeqs(out.vals==5);
REMend = out.endSeqs(out.vals==5);
REMlength = out.lengthSeqs(out.vals==5);

REMstart=REMstart';
REMend=REMend';
REMstart(:,2)=(REMstart(:,1)-1)*sampleRate*epochLength; 
REMend(:,2)=REMend(:,1)*sampleRate*epochLength-1;
REMchunks=array2table([(1:length(REMstart(:,1)))' REMstart(:,1) REMend(:,1) REMstart(:,2) REMend(:,2)]); 
REMchunks.Properties.VariableNames = {'REMperiod','StartEpoch','EndEpoch','StartREM','EndREM'};
REMchunks.Name = repmat({fileName},length(REMstart(:,1)),1); 
REMchunks = [REMchunks(:,end) REMchunks(:,1:(end-1))];
end

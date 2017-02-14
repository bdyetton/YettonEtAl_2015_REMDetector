% use to get REM chunks to run through REM detector

out = consecutiveValues(stageData.stages');
out = out{1};
REMstart = out.startSeqs(out.vals==5);
REMend = out.endSeqs(out.vals==5);
REMlength = out.lengthSeqs(out.vals==5);

REMstart=REMstart';
REMend=REMend';
REMstart(:,2)=(REMstart(:,1)-1)*256*30; 
REMend(:,2)=REMend(:,1)*256*30-1;
REMchunks=[REMstart(:,1) REMend(:,1) REMstart(:,2) REMend(:,2)];
close all; clear all;
subNum =608;
dir_ = 'C:\Users\Lizzie\Documents\Analyzer\Siesta Fiesta Satellite\excel scored files\vmrk file created\';
files = dir([dir_ '*.xls*']);

stages =xlsread(sprintf('SF%i.xls',subNum),'GraphData');
stages = stages(:,2);

out = consecutiveValues(stages');
out = out{1};
REMstart = out.startSeqs(out.vals==5);
REMend = out.endSeqs(out.vals==5);
REMlength = out.lengthSeqs(out.vals==5);

REMstart=REMstart';
REMend=REMend';
REMstart(:,2)=(REMstart(:,1)-1)*256*30; 
REMend(:,2)=REMend(:,1)*256*30-1;
REMchunks=[REMstart(:,1) REMend(:,1) REMstart(:,2) REMend(:,2)];

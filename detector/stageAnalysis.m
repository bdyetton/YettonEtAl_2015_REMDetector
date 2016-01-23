[stageData,txt] = xlsread('scoreData.xlsx');
varData = readtable('varData.xlsx');
[stageData,stageInfo] = convertToStandardStageNums(stageData);
[stageData,varData] = cleanData(stageData,stageInfo,varData);
[BMI,gender] = getSQData(varData);

stageInfo.sleepStageNums = [stageInfo.wakeNum stageInfo.stage1Num stageInfo.stage2Num stageInfo.SWSNum stageInfo.REMNum];
stageInfo.sleepStageNames = {'Wake', 'Stage1','Stage2','SWS','REM'};

%stageData = interpolateSmallStages(stageData,1,'forward'); %get rid of single epochs
%stageData = interpolateSmallStages(stageData,1,'back'); %get rid of single epochs

%% split into stages
% beforeLightsOutTotal = sum(stageData==stageInfo.beforeLightsOutNum,1);
% afterLightsOnTotal = sum(stageData==stageInfo.afterLightsOnNum,1);
% padding = sum(stageData==stageInfo.paddingNum,1);
% afterLightsOnTotal = padding + afterLightsOnTotal;
% wakeTotal = sum(stageData==stageInfo.wakeNum,1);
% wakeAndLightsOn = wakeTotal + afterLightsOnTotal;
% stage1Total = sum(stageData==stageInfo.stage1Num,1);
% stage2Total = sum(stageData==stageInfo.stage2Num,1);
% SWSTotal = sum(stageData==stageInfo.SWSNum,1);
% REMTotal = sum(stageData==stageInfo.REMNum,1);

goodData = BMI>0 & gender>0;
stageData = stageData(goodData,:);
varData = varData(goodData,:);
BMI = BMI(goodData);
gender = gender(goodData);
BNData = formatDataForBN(stageData,varData,BMI,gender);
save('Data/Output/BNData.mat','BNData');

%% Lets look at the dist of time of each stage chunk
%stageStats(stageData,stageInfo,stageInfo.REMNum,'REM');

%For all stages together
% transitionProbs(stageData,stageInfo,stageInfo.wakeNum,'Wake','cum');
% transitionProbs(stageData,stageInfo,stageInfo.stage1Num,'Stage1','cum');
% transitionProbs(stageData,stageInfo,stageInfo.stage2Num,'Stage2','cum');
% transitionProbs(stageData,stageInfo,stageInfo.SWSNum,'SWS','cum');
% transitionProbs(stageData,stageInfo,stageInfo.REMNum,'REM','cum');

%Wake over periods
% for period = 1:5
%     transitionProbs(stageData,stageInfo,stageInfo.wakeNum,'Wake','cum',period);
% end

% for period = 1:5
%     transitionProbs(stageData,stageInfo,stageInfo.stage2Num,'Stage2','cum',period);
% end

%proportion of stages over time
% time = 0:0.5:(size(stageData,2)*0.5-0.5);
% area(([wakeAndLightsOn ; stage1Total ; stage2Total ; SWSTotal ; REMTotal]./numSubs)')
% ylim([0 1])
% xlim([0 size(wakeTotal,2)])
% legend({'wake', 'stage1', 'stage2', 'SWS', 'REM',});
% figure
% subplot(1,2,1)
% mymap = [1 1 1 %wake
%         1 0 0 %stage 1
%         0 1 0 %stage 2
%         0 0 1 %SWS
%         0 0 0 %REM
%         0.9 0.9 0.9]; %Lights On
% ax = imagesc(stageData);
% colormap(mymap)
% caxis([0 6])
% 
% subplot(1,2,2)
% set(gca,'visible','off')
% c = colorbar
% caxis( [1 6] );
% c.Ticks = [1.4,2.3,3.1,3.9,4.8,5.5]
% c.TickLabels = {'Wake', 'S1', 'S2', 'SWS', 'REM', 'Lights On'};

% xt = get(gca, 'XTick');
% set(gca, 'XTick', xt, 'XTickLabel', {'Machine 1' 'Machine 2' 'Machine 3' 'Machine 4' 'Machine 5'})
% yd = get(hBar, 'YData');
% yjob = {'Job A' 'Job B' 'Job C'};
% barbase = cumsum([zeros(size(D,1),1) D(:,1:end-1)],2);
% joblblpos = D/2 + barbase;
% for k1 = 1:size(D,1)
%     text(xt(k1)*ones(1,size(D,2)), joblblpos(k1,:), yjob, 'HorizontalAlignment','center')
% end



clear;
fileNames = cell(0);
dir_ = 'Data\Input\ScoreFiles\NP\';
files = dir([dir_ '*.xls*']);
fileNames = [fileNames cellfun(@(x) [dir_ x],{files.name},'UniformOutput',false);];

dir_ = 'Data\Input\ScoreFiles\SF\';
files = dir([dir_ '*.xls*']);
fileNames = [fileNames cellfun(@(x) [dir_ x],{files.name},'UniformOutput',false);];

scoring.fileNames = cell(length(fileNames),1);
scoring.stage = cell(length(fileNames),1);
vars.vars = cell(length(fileNames),1);
maxLen = 0;
beforeLightsOutNum = -1; %user defined as 7
afterLightsOnNum = 0; %user defined as 7
ticker = 0;
for f=1:length(fileNames)
    if isempty(strfind(fileNames{f},'xls')) continue; end;
    ticker = ticker+1;
    scoring.fileNames{ticker}=fileNames{f};
    [nums] = xlsread(fileNames{f},'GraphData','Stage');
    [~,txts,raws] = xlsread(fileNames{f},'list');
    scoring.stage{ticker} = nums(nums~=beforeLightsOutNum & nums~=afterLightsOnNum);
    varNames = txts(:,1)';
    vars.vars{ticker} = raws(:,3); 
    if length(scoring.stage{ticker})> maxLen
        maxLen = length(scoring.stage{ticker});
    end;
%     if f>5 
%         break
%     end
end

vars.vars = [vars.vars{:}]';
varNames = cellfun(@(x) strrep(x,'_','i'),varNames,'UniformOutput',false);
varNames = cellfun(@(x) strrep(x,'/','_'),varNames,'UniformOutput',false);
varNames = cellfun(@(x) strrep(x,'(','_'),varNames,'UniformOutput',false);
varNames = cellfun(@(x) strrep(x,')','_'),varNames,'UniformOutput',false);
varNames = cellfun(@(x) strrep(x,',','_'),varNames,'UniformOutput',false);
varNames = cellfun(@(x) strrep(x,' ',''),varNames,'UniformOutput',false);

varNames = varNames(:,1:664);
varTable = cell2table(vars.vars);
varTable = varTable(:,1:664);
varTable.Properties.VariableNames = varNames;
varTable.Properties.RowNames = scoring.fileNames(isempty(scoring.fileNames));
writetable(varTable,'varData.xlsx');

%pad with zeros
for f=1:length(scoring.fileNames)
   scoring.stage{f} = [scoring.stage{f}'  -2*ones(1,maxLen-length(scoring.stage{f}))];
end
scoring.stage = cell2mat(scoring.stage);
t = struct2table(scoring);
writetable(t,'scoreData.xlsx'); 
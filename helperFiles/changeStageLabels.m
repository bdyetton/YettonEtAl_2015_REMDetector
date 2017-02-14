function stageDataOut = changeStageLabels(stageData,currentLabels,newLabels)
    stageDataOut = nan(size(stageData));
    for lab = 1:length(currentLabels) 
        if ischar(stageData{1})
            stageDataOut(strcmp(stageData,currentLabels{lab})) = newLabels(lab);
        else
            stageDataOut(stageData == currentLabels(lab)) = newLabels(lab);
        end
    end
end
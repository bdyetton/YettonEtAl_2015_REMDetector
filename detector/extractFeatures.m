function extractedFeaturesSet = extractFeatures(dataSet)

LOC_INDEX = 1;
ROC_INDEX = 2;
NEGP_INDEX = 3;

featureNames={
'AMP_C';
'XCOR';
'WAV_C';
'WIDTH_C';
'PPROM_C';
'AMP_L';
'WIDTH_L';
'PPROM_L';
'WAV_L';
'RISE_L';
'FALL_L';
'LVAR_L';
'NLNRG_L';
'TKURT_L';
'AMP_R';
'WIDTH_R';
'PPROM_R';
'WAV_R';
'RISE_R';
'FALL_R';
'COAST_R';
'NLNRG_R';
'TSKEW_R';
'TKURT_R';
'SSKEW_L';
'SKURT_L';
'SENTR_L';
'DTW_L';
'DTW_C';
'DSI_L';
'FSI_L';
'BBDI_L';
'DSI_R';
'FSI_R';
'BBDI_R';
'DSI_C';
'FSI_C';
'BBDI_C';
'AMP2_L';
'AMP2_R';
'LOC1_R';
'LOC1_L';
'LOC2_R';
'LOC2_L';
};

NUM_FEATURES = length(featureNames); %note that human scores are included

load('templateREM.mat','-mat');

% %----------Run features extraction on windows---------
numWindows = size(dataSet.timeData,2);
extractedFeaturesMatrix = zeros(NUM_FEATURES,numWindows);

plotting = 0;
mL = 10;
mNP = mL;
tauL = 5;
tauNP = tauL;

%% Extract Features
%initTime=GetSecs();
cumLoopTime = 0;
timing = 1;
reverseStr = '';
format long
for winIndex = 1:(numWindows-1);
%for winIndex = 2:4 %win extactor returns zero when end of loc or roc is reached
    tic
    %-1--Amplitude Peaks--------
    [peakOne,peakTwo]=featureExtractTime_amplitude2peak(dataSet.timeData{LOC_INDEX,winIndex},plotting);
    extractedFeaturesMatrix(strcmp('AMP_L',featureNames),winIndex) = peakOne.peak;
    extractedFeaturesMatrix(strcmp('PPROM_L',featureNames),winIndex) = peakOne.prom;
    extractedFeaturesMatrix(strcmp('WIDTH_L',featureNames),winIndex) = peakOne.width;
    extractedFeaturesMatrix(strcmp('RISE_L',featureNames),winIndex) = peakOne.riseSlope;
    extractedFeaturesMatrix(strcmp('FALL_L',featureNames),winIndex) = peakOne.fallSlope;
    extractedFeaturesMatrix(strcmp('AMP2_L',featureNames),winIndex) = peakTwo.peak;
    extractedFeaturesMatrix(strcmp('LOC1_L',featureNames),winIndex) = peakOne.loc;
    extractedFeaturesMatrix(strcmp('LOC2_L',featureNames),winIndex) = peakTwo.loc;
    isPeakNegL = peakOne.isPeakNeg;
    
    [peakOne,peakTwo]=featureExtractTime_amplitude2peak(dataSet.timeData{ROC_INDEX,winIndex},plotting);
    extractedFeaturesMatrix(strcmp('AMP_R',featureNames),winIndex) = peakOne.peak;
    extractedFeaturesMatrix(strcmp('PPROM_R',featureNames),winIndex) = peakOne.prom;
    extractedFeaturesMatrix(strcmp('WIDTH_R',featureNames),winIndex) = peakOne.width;
    extractedFeaturesMatrix(strcmp('RISE_R',featureNames),winIndex) = peakOne.riseSlope;
    extractedFeaturesMatrix(strcmp('FALL_R',featureNames),winIndex) = peakOne.fallSlope;
    extractedFeaturesMatrix(strcmp('AMP2_R',featureNames),winIndex) = peakTwo.peak;
    extractedFeaturesMatrix(strcmp('LOC1_R',featureNames),winIndex) = peakOne.loc;
    extractedFeaturesMatrix(strcmp('LOC2_R',featureNames),winIndex) = peakTwo.loc;
    isPeakNegR = peakOne.isPeakNeg;
    
    [peakOne,peakTwo]=featureExtractTime_amplitude2peak(dataSet.timeData{NEGP_INDEX,winIndex},plotting);
    extractedFeaturesMatrix(strcmp('AMP_C',featureNames),winIndex) = peakOne.peak;
    extractedFeaturesMatrix(strcmp('PPROM_C',featureNames),winIndex) = peakOne.prom;
    extractedFeaturesMatrix(strcmp('WIDTH_C',featureNames),winIndex) = peakOne.width;
    extractedFeaturesMatrix(strcmp('RISE_C',featureNames),winIndex) = peakOne.riseSlope;
    extractedFeaturesMatrix(strcmp('FALL_C',featureNames),winIndex) = peakOne.fallSlope;
    
    %-2--Neg Cross-Corellation------
    extractedFeaturesMatrix(strcmp('XCOR',featureNames),winIndex) = featureExtractTime_crossCorrelation(-dataSet.timeData{LOC_INDEX,winIndex},dataSet.timeData{ROC_INDEX,winIndex},plotting);
    
    %-3--Wavelet----------------
    extractedFeaturesMatrix(strcmp('WAV_L',featureNames),winIndex) = featureExtractNonLinear_haar(dataSet.timeData{LOC_INDEX,winIndex},plotting);
    extractedFeaturesMatrix(strcmp('WAV_R',featureNames),winIndex) = featureExtractNonLinear_haar(dataSet.timeData{ROC_INDEX,winIndex},plotting);
    extractedFeaturesMatrix(strcmp('WAV_C',featureNames),winIndex) = featureExtractNonLinear_haar(dataSet.timeData{NEGP_INDEX,winIndex},plotting);

    extractedFeaturesMatrix(strcmp('LVAR_L',featureNames),winIndex) = featureExtractTime_localVariance(dataSet.timeData{LOC_INDEX,winIndex});
    extractedFeaturesMatrix(strcmp('NLNRG_L',featureNames),winIndex) = featureExtractTime_nonLinearEnergy(dataSet.timeData{LOC_INDEX,winIndex});
    extractedFeaturesMatrix(strcmp('TKURT_L',featureNames),winIndex) = featureExtractFreqAndTime_kurtosis(dataSet.timeData{LOC_INDEX,winIndex});
    
    extractedFeaturesMatrix(strcmp('COAST_R',featureNames),winIndex) = featureExtractTime_coastline(dataSet.timeData{ROC_INDEX,winIndex});
    extractedFeaturesMatrix(strcmp('NLNRG_R',featureNames),winIndex) = featureExtractTime_nonLinearEnergy(dataSet.timeData{ROC_INDEX,winIndex});
    extractedFeaturesMatrix(strcmp('TSKEW_R',featureNames),winIndex) = featureExtractFreqAndTime_skewness(dataSet.timeData{ROC_INDEX,winIndex});
    extractedFeaturesMatrix(strcmp('TKURT_R',featureNames),winIndex) = featureExtractFreqAndTime_kurtosis(dataSet.timeData{ROC_INDEX,winIndex});
       
    extractedFeaturesMatrix(strcmp('SSKEW_L',featureNames),winIndex) = featureExtractFreqAndTime_skewness(abs(dataSet.freqData{LOC_INDEX,winIndex}));
    extractedFeaturesMatrix(strcmp('SKURT_L',featureNames),winIndex) = featureExtractFreqAndTime_kurtosis(abs(dataSet.freqData{LOC_INDEX,winIndex}));
    extractedFeaturesMatrix(strcmp('SENTR_L',featureNames),winIndex) = featureExtractFreq_shannonEntropy(dataSet.freqData{LOC_INDEX,winIndex});

    %---Dynamic Time Warping
    extractedFeaturesMatrix(strcmp('DTW_L',featureNames),winIndex) = featureExtractNonLinear_dtw(simpleFlipIfPeakNeg(dataSet.timeData{LOC_INDEX,winIndex},isPeakNegL),templateREM(LOC_INDEX,:),plotting);
    extractedFeaturesMatrix(strcmp('DTW_C',featureNames),winIndex) = featureExtractNonLinear_dtw(dataSet.timeData{NEGP_INDEX,winIndex},templateREM(NEGP_INDEX,:),plotting);        

    %---Non-Linear Features----
    warning('off','all')
    [DSI_L,FSI_L,BBDI_L] = Similarity_features(simpleFlipIfPeakNeg(dataSet.timeData{LOC_INDEX,winIndex},isPeakNegL),templateREM(LOC_INDEX,:),mL,tauL);
    extractedFeaturesMatrix(strcmp('DSI_L',featureNames),winIndex) = DSI_L;
    extractedFeaturesMatrix(strcmp('FSI_L',featureNames),winIndex) = FSI_L;
    extractedFeaturesMatrix(strcmp('BBDI_L',featureNames),winIndex) = BBDI_L;
    [DSI_R,FSI_R,BBDI_R] = Similarity_features(simpleFlipIfPeakNeg(dataSet.timeData{ROC_INDEX,winIndex},isPeakNegR),templateREM(ROC_INDEX,:),mL,tauL);
    extractedFeaturesMatrix(strcmp('DSI_R',featureNames),winIndex) = DSI_R;
    extractedFeaturesMatrix(strcmp('FSI_R',featureNames),winIndex) = FSI_R;
    extractedFeaturesMatrix(strcmp('BBDI_R',featureNames),winIndex) = BBDI_R;
    [DSI_C,FSI_C,BBDI_C] = Similarity_features(dataSet.timeData{NEGP_INDEX,winIndex},templateREM(NEGP_INDEX,:),mNP,tauNP);
    extractedFeaturesMatrix(strcmp('DSI_C',featureNames),winIndex) = DSI_C;
    extractedFeaturesMatrix(strcmp('FSI_C',featureNames),winIndex) = FSI_C;
    extractedFeaturesMatrix(strcmp('BBDI_C',featureNames),winIndex) = BBDI_C;
    warning('on','all')
       
    if timing
        if mod(winIndex,30) %print every 30 cycles
            msg = sprintf('          Processed %.3f percent', 100*winIndex/(numWindows-1));
            fprintf([reverseStr, msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg));
        end
    end
end
%fprintf('-------Features Extracted, Total time to complete: %.2f-------\n',(GetSecs()-initTime)/60);

%now we can save
extractedFeaturesSet = dataSet;
extractedFeaturesSet.featureNames = featureNames;
extractedFeaturesSet.extractedFeatures = extractedFeaturesMatrix;

end
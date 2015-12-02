function corOut = featureExtractTime_correlation(sigA,sigB)
cors = corrcoef(sigA,sigB);
corOut = cors(1,2);
end
function Out = featureExtractTime_pca(X)
% Copyright (c) 2015, MathWorks, Inc.
    [~,Y] = pca(X,'NumComponents',1)
    if length(Y)
        Out=Y(1);
    else
        Out = 0;
    end
end
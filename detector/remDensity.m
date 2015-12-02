function [ density ] = remDensity( classifiedData )
    %REMDENSITY calulate the rem density (in REM/second) of classified data
    density = sum(classifiedData)/(length(classifiedData)/60);
end


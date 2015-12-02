function sig = simpleFlipIfPeakNeg(sig,isPeakNeg)
if isPeakNeg
    sig = -sig;
end
end
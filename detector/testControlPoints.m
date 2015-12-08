function locsOut = testControlPoints(locs1,locs2,sig1,sig2)
    %1=left, 2=right, but can be changed to test for each channel
    locsOut = [];
    for i=2:length(locs1)
        %if abs(sig1(i-1) - sig1(i)) > 20 %last control point in this channel was 20uV different
            if abs(locs1(i) - locs1(i-1)) < 307 %last control point in this channel was within 1.2 seconds
                indexOfLastLocsOnOtherChannel = (locs2 <= locs1(i)) & (locs2 >= (locs1(i)-100)); %all locs in other chaneel before current loc and not greater than 100ms before
                ampOfLastLocOnOtherChannel = sig2(indexOfLastLocsOnOtherChannel);
                if any(ampOfLastLocOnOtherChannel)
                    if abs(sig1(i) - ampOfLastLocOnOtherChannel(end)) > 70 %last loc in other channel must be larger than
                        if (ampOfLastLocOnOtherChannel(end) > 0) ~= (sig1(i) > 0) %if locs in opposite dirrections
                            locsOut(end+1)=locs1(i);
                        end
                    end
                end
            end
        %end
    end
end
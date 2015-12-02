function [locOut,levelsOut] = clusterLocs(locs,levels,peaks,type,thresh)
    %See matlab docs on clustering for more info...
    locs = [locs' zeros(size(locs'))];
    distanceBetweenLocs = pdist(locs);
    linkagesBetweenLocs = linkage(distanceBetweenLocs);
    clusterGroups = cluster(linkagesBetweenLocs,'cutoff',thresh,'criterion','distance');
    clusteredLocs = cell(max(clusterGroups),1);
    clusteredPeaks = cell(max(clusterGroups),1);
    clusteredLevels = cell(max(clusterGroups),1);
    locOut = zeros(max(clusterGroups),1);
    levelsOut = zeros(max(clusterGroups),max(levels));
    for i = 1:max(clusterGroups)
        clusteredLocs{i} = locs(clusterGroups==i);
        clusteredLevels{i} = levels(clusterGroups==i);
        if type ==0
            clusteredPeaks{i} = peaks(clusterGroups==i);
            [~,peakLoc] = max(clusteredPeaks{i});
            locOut(i) = clusteredLocs{i}(peakLoc);
        else %the location at type takes precedence in location
            if (clusteredLocs{i}==type)
                locOut(i) = clusteredLocs{i}(clusteredLocs{i}==type);
            else
                locOut(i) = mean(clusteredLocs{i}); %if it doesnt exsist, then take the mean...
            end
        end
        
        for lev = 1:max(levels)
            levelsOut(i,lev) = sum(clusteredLevels{i}==lev);
        end
    end
    [locOut,sortIndex] = sort(locOut);
    levelsOut = levelsOut(sortIndex,:);
    
end
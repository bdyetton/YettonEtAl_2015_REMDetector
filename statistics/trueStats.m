function [recall,precision,TP,FP,FN] = trueStats(FullConfuse)
    if length(FullConfuse) > 3
        TP = FullConfuse(2,2)+FullConfuse(3,2)+FullConfuse(2,3)+2*FullConfuse(3,3)...
            +3*FullConfuse(4,4) + 2*FullConfuse(4,3) + FullConfuse(4,2) + 2*FullConfuse(3,4) + FullConfuse(2,4);
        FN = FullConfuse(2,1)+FullConfuse(3,2)+2*FullConfuse(3,1) + 3*FullConfuse(4,1)...
             +3*FullConfuse(4,1)+2*FullConfuse(4,2)+FullConfuse(4,3);
        FP = FullConfuse(1,2)+FullConfuse(1,3)*2+FullConfuse(2,3)+...
            3*FullConfuse(1,4)+2*FullConfuse(2,4)+FullConfuse(3,4);
        TN = FullConfuse(1,1);
    elseif length(FullConfuse)>2
        TP = FullConfuse(2,2)+FullConfuse(3,2)+2*FullConfuse(3,3)+FullConfuse(2,3);
        FN = FullConfuse(2,1)+FullConfuse(3,2)+2*FullConfuse(3,1);
        FP = FullConfuse(1,2)+FullConfuse(1,3)*2+FullConfuse(2,3);
        TN = FullConfuse(1,1);
    else
        TP = FullConfuse(2,2);
        FN = FullConfuse(2,1);
        FP = FullConfuse(1,2);
        TN = FullConfuse(1,1);    
    end
    recall = TP/(TP+FN);
    precision = TP/(TP+FP);
    
end
function confuseMat = createConfusion2Class(goldStandard,singleResults)

confuseMat = zeros(2,2);
confuseMat(1,1) = sum((goldStandard==0) & (singleResults==0));
confuseMat(1,2) = sum((goldStandard==0) & (singleResults==1));

confuseMat(2,1) = sum((goldStandard==1) & (singleResults==0));
confuseMat(2,2) = sum((goldStandard==1) & (singleResults==1));

end
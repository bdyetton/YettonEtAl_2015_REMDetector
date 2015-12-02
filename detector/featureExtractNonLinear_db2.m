function peakDb2 = featureExtractNonLinear_db2(sig,plotting)
    [A1,D1]=dwt(sig,'db2');
    [A2,D2]=dwt(A1,'db2');
    [A3,D3]=dwt(A2,'db2');
    [A4,D4]=dwt(A3,'db2');
    [A5,D5]=dwt(A4,'db2');
    [A6,D6]=dwt(A5,'db2');
    
%     Gamma=idwt([],D1,'db2');
% 
%     Beta=idwt([],D2,'db2');
%     Beta=idwt(Beta,[],'db2');
% 
%     Alpha=idwt([],D3,'db2');
%     Alpha=idwt(Alpha,[],'db2');
%     Alpha=idwt(Alpha,[],'db2');
% 
%     Theta=idwt([],D4,'db2');
%     Theta=idwt(Theta,[],'db2');
%     Theta=idwt(Theta,[],'db2');
%     Theta=idwt(Theta,[],'db2');
%     
%     more=idwt([],D5,'db2');
%     more=idwt(more,[],'db2');
%     more=idwt(more,[],'db2');
%     more=idwt(more,[],'db2');
%     more=idwt(more,[],'db2');
    
    more2=idwt([],D6,'db2');
    more2=idwt(more2,[],'db2');
    more2=idwt(more2,[],'db2');
    more2=idwt(more2,[],'db2');
    more2=idwt(more2,[],'db2');
    more2=idwt(more2,[],'db2');

    if plotting
        subplot(8,1,1)
        plot(sig)
%         subplot(8,1,2)
%         plot(Gamma)
%         subplot(8,1,3)
%         plot(Beta)
%         subplot(8,1,4)
%         plot(Alpha)
%         subplot(8,1,5)
%         plot(Theta)
%         subplot(8,1,6)
%         plot(more) 
%         subplot(8,1,7)
        subplot(8,1,2)
        plot(more2)      
    end
    peakDb2 = max(abs(more2));
end

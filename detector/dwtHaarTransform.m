function Theta = dwtHaarTransform(sig)
    [A1,D1]=dwt(sig,'haar');
    [A2,D2]=dwt(A1,'haar');
    [A3,D3]=dwt(A2,'haar');
    [A4,D4]=dwt(A3,'haar');
    
%     Gamma=idwt([],D1,'haar');
% 
%     Beta=idwt([],D2,'haar');
%     Beta=idwt(Beta,[],'haar');
% 
%     Alpha=idwt([],D3,'haar');
%     Alpha=idwt(Alpha,[],'haar');
%     Alpha=idwt(Alpha,[],'haar');

    Theta=idwt([],D4,'haar');
    Theta=idwt(Theta,[],'haar');
    Theta=idwt(Theta,[],'haar');
    Theta=idwt(Theta,[],'haar');

%     if plotting
%         subplot(6,1,1)
%         plot(sig)
%         subplot(6,1,2)
%         plot(Gamma)
%         subplot(6,1,3)
%         plot(Beta)
%         subplot(6,1,4)
%         plot(Alpha)
%         subplot(6,1,5)
%         plot(Theta)
%     end
end

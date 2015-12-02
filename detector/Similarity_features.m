function [Sim_H,Sim_F,Dis_B] = Similarity_features(S,Sref,m,tau)

Nref = length(Sref);
Aref = zeros(m,Nref-(m-1)*tau);
for k=1:Nref-tau*(m-1)
    Aref(:,k)=Sref(k:tau:k+(m-1)*tau)';
end

[U,~,~] = svd(Aref);

Xref = Aref'*U;
Xref = Xref';


R=[];
cc=1;
for i=1:Nref-tau*(m-1)
    for j=1:i-1
        R(cc)=norm(Xref(:,i)-Xref(:,j));
        cc=cc+1;
    end
end
R=sort(R);
I=round(0.3*length(R));
r=R(I);


N = length(S);
A = zeros(m,N-(m-1)*tau);
for k=1:N-tau*(m-1)
    A(:,k)=S(k:tau:k+(m-1)*tau)';
end
X = A'*U;
X = X';

CxxH = heaviside_correlation(X,X,N,N,m,tau,r);
CyyH = heaviside_correlation(Xref,Xref,Nref,Nref,m,tau,r);
CxyH = heaviside_correlation(X,Xref,N,Nref,m,tau,r);
Sim_H = CxyH/sqrt(CxxH*CyyH);

CxxF = gaussian_correlation(X,X,N,N,m,tau,r);
CyyF = gaussian_correlation(Xref,Xref,Nref,Nref,m,tau,r);
CxyF = gaussian_correlation(X,Xref,N,Nref,m,tau,r);
Sim_F = CxyF/sqrt(CxxF*CyyF);

Dis_B = bhattacharyya(X,Xref);
% CxxB = bhattacharyya(X,X);
% CyyB = bhattacharyya(Xref,Xref);
% CxyB = bhattacharyya(X,Xref);
% Dis_B = CxyB/sqrt(CxxB*CyyB);



end

function Cxy = heaviside_correlation(x,y,Nx,Ny,M,t,r)
Cxy=0;
for i=1:(Ny-(M-1)*t)
    for j=1:(Nx-(M-1)*t)
        Cxy=Cxy+1/(Ny*Nx)*((norm(y(:,i)-x(:,j)))<r);
    end
end
end

function Cxy = gaussian_correlation(x,y,Nx,Ny,M,t,r)
Cxy=0;
for i=1:(Ny-(M-1)*t)
    for j=1:(Nx-(M-1)*t)
        Cxy=Cxy+1/(Ny*Nx)*exp(-((norm(y(:,i)-x(:,j)))^2)/r^2);
    end
end
end

function d = bhattacharyya(X1,X2)

X1 = X1';
X2 = X2';

mu1 = mean(X1);
C1 = cov(X1);
mu2 = mean(X2);
C2 = cov(X2);
C = (C1+C2)/2;
dmu = (mu1-mu2)/chol(C);
try
    d = 0.125*dmu*dmu'+0.5*log(det(C/chol(C1*C2)));
catch
    d = 0.125*dmu*dmu'+0.5*log(abs(det(C/sqrtm(C1*C2))));
    warning('MATLAB:divideByZero','Data are almost linear dependent. The results may not be accurate.');
end
% d = 0.125*(mu1-mu2)/C*(mu1-mu2)'+0.5*log(det(C)/(sqrt(det(C1)*det(C2))));
end
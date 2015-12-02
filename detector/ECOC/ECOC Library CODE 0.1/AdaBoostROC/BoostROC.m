%##########################################################################

% <ECOCs Library. Coding and decoding designs for multi-class problems.>
% Copyright (C) 2008 Sergio Escalera sergio@maia.ub.es

%##########################################################################

% This file is part of the ECOC Library.

% ECOC Library is free software; you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation; either version 2 of the License, or (at your option) any later version. 

% This program is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR 
% A PARTICULAR PURPOSE. See the GNU General Public License for more details. 

% You should have received a copy of the GNU General Public License along with
% this program. If not, see <http://www.gnu.org/licences/>.

%##########################################################################

function [alpha,feature,p,thr]=BoostROC(clase1, clase2, T, test)

if nargin<4
    test.c1=zeros(1,size(clase1,2));
    test.c2=ones(1,size(clase1,2));
end

[Nc1,dim]=size(clase1);
Nc2=size(clase2,1);
TOL=1.0e-16;
onesD=ones(dim,1);
N=floor(0.9*min(Nc1,Nc2));
initHyp=1;
w2=ones(1,Nc2);
w1=ones(1,Nc1);
old_err=1;

for t=initHyp:T
    tw=sum(w1)+sum(w2);
    w1=w1/tw;
    w2=w2/tw;
    [weak.thr,weak.p] = SingleWeakLearnerROC(clase1,w1,clase2,w2);
    dummy=ones(size([clase1;clase2],1),1);
    clases = (dummy*weak.p).*[clase1;clase2]<dummy*(weak.p.*weak.thr);
    error=sum([w1,w2]'*ones(size(clase1,2),1)'.*(clases~=[ones(size(clase1));zeros(size(clase2))]),1);
    [val,featureO]=min(error);
    err(t)=val;
    feature(t)=featureO;
    thr(t)=weak.thr(featureO);
    p(t)=weak.p(featureO);
    betaO=err(t)/(1-err(t));
    beta(t)=betaO;
    alpha(t)=-log10(betaO+eps);
    fe= (p(t)*clase1(:,featureO) < p(t)*thr(t));     
    w1=w1.*(betaO.^(fe))'; 
    nfe= (p(t)*clase2(:,featureO) >= p(t)*thr(t)); 
    w2=w2.*(betaO.^(nfe))'; 
    cout=StrongEvalROC([clase1;clase2],alpha,feature,p,thr);
    erRATEO=sum(cout~=[ones(Nc1,1);zeros(Nc2,1)])/(Nc1+Nc2);
    erRATE(t)=erRATEO;
    cout=StrongEvalROC([test.c1;test.c2],alpha,feature,p,thr);
    erTESTO=sum(cout~=[ones(size(test.c1,1),1);zeros(size(test.c2,1),1)])/(size(test.c1,1)+size(test.c2,1));
    erTEST(t)=erTESTO;
    if err(t)>=0.5
        return;
    end
    if erRATE(t)<eps
        return;
    end
end
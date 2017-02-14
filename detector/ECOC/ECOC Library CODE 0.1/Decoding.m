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

function [result,confusion,labels]=Decoding(TestData,classes,ECOC,base,folder_classifiers,decoding)

alpha=0;
feature=0;
x=zeros([1 size(ECOC,2)]);

switch decoding
    case 'BDEN',
        inc=0.005;
        sigma=2000;
        range_i=0;
        range_d=1;
        area=1/3;
        [X,Y]=ramp_gaussian(sigma,range_i,inc,range_d);
        y=ones([1 length(Y)]);
        x_1=range_i:inc:range_d;
        counter=1;
        for j=0:inc:(range_d-range_i)
            y_1(counter)=j/2;
            counter=counter+1;
        end
        x_2=range_i:inc:range_d;
        counter=1;
        for j=(range_d-range_i):-1*inc:0
            y_2(counter)=j/2;
            counter=counter+1;
        end
    case 'PD',
        dictionary=[];
        for i=1:length(classes)
            dictionary(i)=2^(sum(ECOC(i,:)==0));
        end
        c=(2^size(ECOC,2))-sum(dictionary);
        cq=(2^size(ECOC,2));
        alfa=c/(cq*length(classes));
        A=[];
        B=[];
        switch base
            case 1,
                clear NMC_classifier FirstSet SecondSet
                load([folder_classifiers '/NMC_classifier_' num2str(i,'%d') '.mat']);
            case 2,
                clear FirstSet SecondSet alpha feature p thr;
                load([folder_classifiers '/ADA_classifier_' num2str(i,'%d') '.mat']);
            case 3,
                load([folder_classifiers '/Custom_classifier_' num2str(i,'%d') '.mat']);
        end
        for i=1:size(ECOC,2)
            out=[];
            target=[];
            prior1=0;
            prior0=0;
            aux=0;
            for j=1:length(classes)
                if ECOC(j,i)~=0
                    pos=find(TestData(:,size(TestData,2))==classes(j));
                    samples=TestData(pos,1:size(TestData,2)-1);
                    for k=1:size(samples,1)
                        switch base
                            case 1,
                                out(i)=NMCTest(samples(k,:),NMC_classifier);
                            case 2,
                                out(i)=StrongEvalROC(samples(k,:),alpha,feature,p,thr);
                            case 3,
                                out(i)=Custom_test(samples(k,:),Custom_classifier);
                        end
                        if ECOC(j,i)==1
                            target(end+1)=1;
                            prior1=prior1+1;
                        else
                            target(end+1)=0;
                            prior0=prior0+1;
                        end
                    end
                end
            end
            [A(i),B(i)]=AB(out,target,prior1,prior0);
        end
    case {'LLW','ELW'},
        for z=1:size(ECOC,2)
            w1=[];
            w2=[];
            switch base
                case 'NMC', % Nearest Mean Classifier
                    try,
                        clear NMC_classifier FirstSet SecondSet
                        load([folder_classifiers '/NMC_classifier_' num2str(z,'%d') '.mat']);
                    catch,
                        error('Exit: Can not find classifier.');
                    end
                    for i=1:size(FirstSet,1)
                        w1(i)=NMCTest(FirstSet(i,:),NMC_classifier);
                    end
                    for i=1:size(SecondSet,1)
                        w2(i)=NMCTest(SecondSet(i,:),NMC_classifier);
                    end
                case 'ADA', % Adaboost
                    try,
                        clear FirstSet SecondSet alpha feature p thr;
                        load([folder_classifiers '/ADA_classifier_' num2str(z,'%d') '.mat']);
                    catch,
                        error('Exit: Can not find classifier.');
                    end
                    for i=1:size(FirstSet,1)
                        w1(i)=StrongEvalROC(FirstSet(i,:),alpha,feature,p,thr);
                    end
                    for i=1:size(SecondSet,1)
                        w2(i)=StrongEvalROC(SecondSet(i,:),alpha,feature,p,thr);
                    end
                case 'CUSTOM', % Custom
                    try,
                        load([folder_classifiers '/Custom_classifier_' num2str(z,'%d') '.mat']);
                    catch,
                        error('Exit: Can not find classifier.');
                    end
                    for i=1:size(FirstSet,1)
                        w1(i)=Custom_test(FirstSet(i,:),Custom_classifier);
                    end
                    for i=1:size(SecondSet,1)
                        w2(i)=Custom_test(SecondSet(i,:),Custom_classifier);
                    end
            end
            weights(z)=(sum(w1==1)+sum(w2==-1))/(length(w1)+length(w2));
        end

end

confusion=zeros([length(classes) length(classes)]);
hits=0;
labels=zeros([1 size(TestData,1)]);
for i=1:size(TestData,1)
    minimum=Inf;
    for z=1:size(ECOC,2)
        switch base
            case 'NMC' % Nearest Mean Classifier
                clear NMC_classifier FirstSet SecondSet
                load([folder_classifiers '/NMC_classifier_' num2str(z,'%d') '.mat']);
                x(z)=NMCTest(TestData(i,1:size(TestData,2)-1),NMC_classifier);
            case 'ADA' % Adaboost
                clear FirstSet SecondSet alpha feature p thr;
                load([folder_classifiers '/ADA_classifier_' num2str(z,'%d') '.mat']);
                x(z)=StrongEvalROC(TestData(i,1:size(TestData,2)-1),alpha,feature,p,thr);
            case 'CUSTOM' % Custom
                load([folder_classifiers '/Custom_classifier_' num2str(z,'%d') '.mat']);
                x(z)=Custom_test(TestData(i,1:size(TestData,2)-1),Custom_classifier);
            otherwise,
                error('Exit: Base classifier bad defined.');
        end
    end
    if strcmp(decoding,'IHD')
        class=IHD(x,ECOC);
    elseif strcmp(decoding,'PD')
        class=PD(x,ECOC,A,B,alfa);
    else
        for k=1:size(ECOC,1)
            switch decoding,
                case 'HD', % Hamming decoding
                    d=HD(x,ECOC(k,:));
                case 'ED', % Euclidean decoding
                    d=ED(x,ECOC(k,:));
                case 'LAP', % Laplacian decoding
                    d=LD(x,ECOC(k,:));
                case 'BDEN', % Beta-density decoding
                    d=BD(x,ECOC(k,:),X,Y,x_1,y_1,x_2,y_2,area);
                case 'AED', % Attenuated Euclidean decoding
                    d=AED(x,ECOC(k,:));
                case 'LLB', % Linear Loss-based decoding
                    d=LLB(x,ECOC(k,:));
                case 'ELB', % Exponential Loss-based decoding
                    d=ELB(x,ECOC(k,:));
                case 'LLW', % Linear Loss-Weighted decoding
                    d=LLW(x,ECOC(k,:),abs(ECOC(k,:).*weights)./sum(abs(ECOC(k,:).*weights)));
                case 'ELW', % Exponential Loss-Weighted decoding
                    d=ELW(x,ECOC(k,:),abs(ECOC(k,:).*weights)./sum(abs(ECOC(k,:).*weights)));
                otherwise,
                    error('Exit: Decoding type bad defined.');
            end
            if d<=minimum
                minimum=d;
                class=k;
            end
        end
    end
    labels(i)=classes(class);
    if classes(class)==TestData(i,size(TestData,2))
        hits=hits+1;
    end
    confusion(find(classes==TestData(i,size(TestData,2))),class)=confusion(find(classes==TestData(i,size(TestData,2))),class)+1;
end
result=hits/size(TestData,1);

%##########################################################################

function d=HD(x,y)
    d=sum(abs((x-y)))/2;

%##########################################################################

function d=ED(x,y)
    d=sqrt(sum((x-y).^2));

%##########################################################################
    
function d=LD(x,y)
    C=sum(x==y);
    E=sum(x~=y)-sum(y==0);
    K=2;
    d=(C+E+K)/(C+1);

%##########################################################################

function [x,y]=ramp_gaussian(sigma,range_left,inc,range_right)

x=range_left:inc:range_right;
for i=1:length(x)
   y(i)=exp((-0.5*(x(i)^2))/(sigma^2)); 
end

function d=BD(x,y,X,Y,x_1,y_1,x_2,y_2,area)

x_s=x_1;
if x(1)==y(1)
    y_s=y_1;
else
    if y(1)==0
        y_s=Y;
    else
        y_s=y_2;
    end
end
for i=2:length(x)
    if x(i)==y(i)
        y_s=y_s.*y_1;
    else
        if x(i)==0
            y_s=y_s.*Y;
        else
            y_s=y_s.*y_2;
        end
    end
end
area_2=sum(y_s);
required_area=area_2*area;
[maximum,pos]=max(y_s);
count=maximum;
count_left=1;
out=1;
while (count<required_area & out)
    if (pos-count_left)>0
        count=count+y_s(pos-count_left);
        count_left=count_left+1;
    else
        out=0;
    end
end
count_left=count_left+1;
if count_left>pos
    count_left=pos-1;
end
d=1-x_s(pos-count_left);

%##########################################################################

function d=AED(x,y)
    d=sqrt(sum((x-y).*abs(y).^2));

%##########################################################################

function class=IHD(x,ECOC)

delta=zeros([size(ECOC,1) size(ECOC,1)]);
for i=1:size(ECOC,1)
    for j=1:size(ECOC,1)
            delta(i,j)=sum(abs(ECOC(i,:)-ECOC(j,:)))/2;
    end
end
for i=1:size(ECOC,1)
    L(i)=sum(abs(x-ECOC(i,:)))/2;
end
q=inv(delta)*L';
[maximum,pos]=max(q);
class=pos;

%##########################################################################

function d=LLB(x,y)

d=sum(-1*(x.*y));

%##########################################################################

function d=ELB(x,y)

d=sum(exp(-1*(x.*y)));

%##########################################################################

function [A,B]=AB(out,target,prior1,prior0)

A=0;
B=log((prior0+1)/(prior1+1));
hiTarget=(prior1+1)/(prior1+2);
loTarget=1/(prior0+2);
lambda=1e-3;
olderr=1e300;
pp(1:length(out))=(prior1+1)/(prior0+prior1+2);
count=0;
for it = 1:100
    a=0;
    b=0;
    c=0;
    d=0;
    e=0;
    for i=1:length(out)
        if (target(i))
            t=hiTarget;
        else
            t=loTarget;
        end
        d1=pp(i)-t;
        d2=pp(i)*(1-pp(i));
        a = a+out(i)*out(i)*d2;
        b = b+d2;
        c = c+out(i)*d2;
        d = d+out(i)*d1;
        e = e+d1;
    end
    if (abs(d)< 1e-9 && abs(e) < 1e-9 )
        break;
    end
    oldA=A;
    oldB=B;
    err=0;
    while (1)
        det=(a+lambda)*(b+lambda)-c*c;
        if (det==0)
            lambda = lambda*10;
            continue;
        end
        A=oldA+((b+lambda)*d-c*e)/det;
        B=oldB+((a+lambda)*e-c*d)/det;
        err=0;
        for i=1:length(out)
            p=1/(1+exp(out(i)*A+B));
            pp(i)=p;
            err=err-1*(t*log(p)+(1-t)*log(1-p));
        end
        if (err<olderr*(1+1e-7))
            lambda=lambda*0.1;
            break;
        end
        lambda=lambda*10;
        if (lambda>=1e6)
            break;
        end
    end
    diff=err-olderr;
    scale=0.5*(err+olderr+1);
    if (diff>-1e-3*scale && diff<1e-7*scale)
        count=count+1;
    else
        count=0;
    end
    olderr=err;
    if (count==3)
        break;
    end
end

function class=PD(x,ECOC,A,B,alfa)
    
distan=Inf;
class=[];
for i=1:size(ECOC,1)
    counter=1;
    for j=1:size(ECOC,2)
        if ECOC(i,j)~=0
           counter=counter*(1/(1+exp(ECOC(i,j)*(A(j)*x(j)+B(j))))); 
        end
    end
    counter=counter+alfa;
    counter=-1*log(counter);
    if counter<distan
        distan=counter;
        class=i;
    end
end

%##########################################################################

function d=LLW(x,y,W)

d=sum(-1*W.*(y.*x));

%##########################################################################

function d=ELW(x,y,W)

d=sum(W.*exp(-1*(y.*x)));

%##########################################################################
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

function ECOC=ecoc_one(ECOC,classes,data,Parameters,base,decoding,show_info)

validation=Parameters.validation;
w_validation=Parameters.w_validation;
epsilon=Parameters.epsilon;
iterations_one=Parameters.iterations_one;
folder_classifiers=Parameters.folder_classifiers;
ada_iterations=Parameters.ada_iterations;
one_mode=Parameters.one_mode;
steps_one=Parameters.steps_one;
iterations_sffs=Parameters.iterations_sffs;
steps_sffs=Parameters.steps_sffs;
criterion_sffs=Parameters.criterion_sffs;

[dataT,dataV]=compute_validation(data,classes,validation);
Learning(dataT,ECOC,base,folder_classifiers,classes,ada_iterations,1:size(ECOC,2));
[result,confusion_t]=Decoding(dataT,classes,ECOC,base,folder_classifiers,decoding);
[result,confusion_v]=Decoding(dataV,classes,ECOC,base,folder_classifiers,decoding);
error_t=(sum(diag(confusion_v))/(sum(sum(confusion_v)))*w_validation+(sum(diag(confusion_t))/sum(sum(confusion_t))))*(1-w_validation);
error_p=1;

t=1;
while (error_t>epsilon & error_t<=error_p & t<=iterations_one)
    [ECOC,c1(t),c2(t)]=find_partition(confusion_v,confusion_t,w_validation,dataT,ECOC,one_mode,show_info,iterations_sffs,steps_sffs,criterion_sffs);
    if (show_info)
        disp(ECOC);
    end
    Learning(dataT,ECOC,base,folder_classifiers,classes,ada_iterations,size(ECOC,2));
    [result,confusion_t]=Decoding(dataT,classes,ECOC,base,folder_classifiers,decoding);
    [result,confusion_v]=Decoding(dataV,classes,ECOC,base,folder_classifiers,decoding);
    error_p=error_t;
    error_t=(sum(diag(confusion_v))/(sum(sum(confusion_v)))*w_validation+(sum(diag(confusion_t))/sum(sum(confusion_t))))*(1-w_validation);
    error(1,t)=error_p;
    error(2,t)=error_t;
    if (show_info)
        disp(['%##########################################################################'])        
        disp(['Iteration Error_t Error_t-1 Epsilon Max_iterations Class_1 Class_2'])        
        disp(['%##########################################################################'])        
        for i=1:t
            disp([num2str(i) '      ' num2str(error(2,i)) '      ' num2str(error(1,i)) '      ' num2str(epsilon) '      ' num2str(iterations_one) '      ' num2str(c1(t)) '       ' num2str(c2(t))]);
        end
    end
    t=t+1;
end

%##########################################################################

function [ECOC,row,column]=find_partition(confusion_v,confusion_t,w_validation,dataT,ECOC,one_mode,show_info,iterations,steps,criterion)

confusion=confusion_v.*w_validation+confusion_t.*(1-w_validation);
confusion=(~(diag(ones([1 size(confusion,1)]),0))).*confusion;
for i=2:size(confusion,1)
    for j=1:i-1
        confusion(i,j)=confusion(i,j)+confusion(j,i);
    end
end
[maximum,row]=max(max(confusion));
[maximum,column]=max(confusion(:,row));
switch one_mode
    case 1,
        ECOC(row,size(ECOC,2)+1)=1;
        ECOC(column,size(ECOC,2))=-1;
    case 2,
        ECOC(:,size(ECOC,2)+1)=sffs(dataT,1:size(ECOC,1),iterations,steps,criterion,[row column],ECOC,show_info);
    otherwise,
        error('Exit: Partition selection mode (one_mode) for the ecoc-one coding design bad defined.');
end  

%##########################################################################

function [dataT,dataV]=compute_validation(data,classes,validation)

dataT=[];
dataV=[];
for i=1:length(classes)
    pos=find(data(:,size(data,2))==classes(i));
    amount=floor(length(pos)*(1-validation));
    dataT(size(dataT,1)+1:size(dataT,1)+amount,:)=data(pos(1:amount),:);
    dataV(size(dataT,1)+1:size(dataT,1)+length(pos)-amount,:)=data(pos(amount+1:length(pos)),:);
end

%##########################################################################
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

function ECOC=Forest(classes,data,criterion_sffs,iterations_sffs,number_trees,show_info)

ECOC=[];
for i=1:number_trees
    ECOC=rec_decoc(ECOC,1:length(classes),data,iterations_sffs,criterion_sffs,show_info);
end

%##########################################################################

function ECOC=rec_decoc(ECOC,classes,data,iterations_sffs,criterion_sffs,show_info)

if length(classes)>=3
    partition{1}=classes(1:ceil(length(classes)/2));
    partition{2}=classes(ceil(length(classes)/2)+1:length(classes));
    partition=sffs_decoc(ECOC,partition,data,iterations_sffs,criterion_sffs,show_info);
    column=size(ECOC,2)+1;
    for i=1:length(partition{1})
        ECOC(partition{1}(i),column)=1;
    end
    for i=1:length(partition{2})
        ECOC(partition{2}(i),column)=-1;
    end
    ECOC=rec_decoc(ECOC,partition{1},data,iterations_sffs,criterion_sffs,show_info);
    ECOC=rec_decoc(ECOC,partition{2},data,iterations_sffs,criterion_sffs,show_info);
else % only two classes
    if length(classes)==2
        column=size(ECOC,2)+1;
        ECOC(classes(1),column)=1;
        ECOC(classes(2),column)=-1;
    end
end

%##########################################################################

function partition=sffs_decoc(ECOC,partition,data,iterations,criterion,show_info)

data1=[];
for i=1:length(partition{1})
    data1=[data1 ; data(find(data(:,size(data,2))==partition{1}(i)),:)];
end
data2=[];
for i=1:length(partition{2})
    data2=[data2 ; data(find(data(:,size(data,2))==partition{2}(i)),:)];
end

switch criterion
    case 1,
        MI=compute_MI(data1, data2);
    otherwise,
        error('Exit: Mutual Information type bad defined.');
end

for i=1:iterations
    if show_info
        disp([num2str(iterations-i) ' iterations left for DECOC SFFS.']);
    end
    if mod(i,2)
        if length(partition{1})>1
            clas=ceil(rand*length(partition{1}));
            if clas==0
                clas=1;
            end
            data1_c=data1;
            data2_c=data2;
            data2_c=[data2_c ; data1(find(data1(:,size(data1,2))==partition{1}(clas)),:)];
            data1_c(find(data1(:,size(data1,2))==partition{1}(clas)),:)=[];
            switch criterion
                case 1,
                    MI_c=compute_MI(data1_c, data2_c);
                otherwise,
                    error('Exit: Mutual Information type bad defined.');
            end
            if MI_c<MI
                p2=[partition{2} partition{1}(clas)];
                p1=partition{1};
                p1(clas)=[];
                if no_previousD(ECOC,p1,p2)
                    if show_info
                        disp(['SFFS moving class ' num2str(partition{1}(clas))]);
                    end
                    data1=data1_c;
                    data2=data2_c;
                    partition{2}=[partition{2} partition{1}(clas)];
                    partition{1}(clas)=[];
                end
            end
        end
    else
        if length(partition{2})>1
            clas=ceil(rand*length(partition{2}));
            if clas==0
                clas=1;
            end
            data1_c=data1;
            data2_c=data2;
            data1_c=[data1_c ; data2(find(data2(:,size(data2,2))==partition{2}(clas)),:)];
            data2_c(find(data2(:,size(data2,2))==partition{2}(clas)),:)=[];
            switch criterion
                case 1,
                    MI_c=compute_MI(data1_c, data2_c);
                otherwise,
                    error('Exit: Mutual Information type bad defined.');
            end
            if MI_c<MI
                p1=[partition{1} partition{2}(clas)];
                p2=partition{2};
                p2(clas)=[];
                if no_previousD(ECOC,p1,p2)
                    if show_info
                        disp(['SFFS moving class ' num2str(partition{2}(clas))]);
                    end
                    data1=data1_c;
                    data2=data2_c;
                    partition{1}=[partition{1} partition{2}(clas)];
                    partition{2}(clas)=[];
                end
            end
        end
    end
end

%##########################################################################

function MI=compute_MI(data1,data2)

data=[data1 ; data2];
MI=0;
for i=1:size(data,2)-1
    data(:,i)=(data(:,i)-(min(data(:,i))))./(max(data(:,i))-min(data(:,i)));
end
data1=data(1:size(data1,1),:);
data2=data(size(data1,1)+1:size(data,1),:);
for i=1:size(data,2)-1
    h1=hist(data1(:,i)',0:0.1:1);
    h1=h1./sum(h1);
    h2=hist(data2(:,i)',0:0.1:1);
    h2=h2./sum(h2);
    MI=MI+sqrt(sum((h1-h2).^2));
end

%##########################################################################

function result=no_previousD(ECOC,p1,p2)

result=1;
vector=zeros([1 size(ECOC,1)]);
for i=1:length(p1)
    vector(p1(i))=1;
end
for i=1:length(p2)
    vector(p2(i))=-1;
end
for i=1:size(ECOC,2)
   if (sum(abs(ECOC(:,i)-vector'))==0)
       result=0;
   end
end

%##########################################################################
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

function part=sffs(data,classes,iterations,steps,criterion,groups,ECOC,show_info)

c_classes=classes;
data1=data(find(data(:,size(data,2))==groups(1)),:);
data2=data(find(data(:,size(data,2))==groups(2)),:);
[value,pos]=find(classes==groups(1));
classes(pos)=[];
[value,pos]=find(classes==groups(2));
classes(pos)=[];
partition{1}=[];
partition{2}=[];

MI=Inf;
for i=1:iterations
    if mod(i,2) % put
        if show_info
            disp([num2str(iterations-i) ' iterations left for SFFS. Including step.']);
        end
        class_c=[];
        for k=1:length(classes)
            if (~(ismember(classes(k),partition{1})) & ~(ismember(classes(k),partition{1})))
                class_c(length(class_c)+1)=classes(k);
            end
        end
        for j=1:steps
            num=ceil(rand*length(class_c));
            if num==0
                num=1;
            end
            if length(class_c)~=0
                class=class_c(num);
                data_c=data(find(data(:,size(data,2))==class),:);
                if mod(j,2) % first partition
                    switch criterion
                        case 1,
                            MI_c=compute_MI([data1 ; data_c],data2);
                        otherwise,
                            error('Exit: Mutual Information type bad defined.');
                    end
                else % second partition
                    switch criterion
                        case 1,
                            MI_c=compute_MI(data1, [data2 ; data_c]);
                        otherwise,
                            error('Exit: Mutual Information type bad defined.');
                    end
                end
                if MI_c<=MI
                    MI=MI_c;
                    if mod(j,2) % first partition
                        if no_previous(ECOC,[partition{1} class],partition{2},c_classes)
                            if show_info
                                disp(['Including class ' num2str(class)]);
                            end
                            partition{1}=[partition{1} class];
                            data1=[data1 ; data_c];
                            class_c(num)=[];
                        end
                    else % second partition
                        if no_previous(ECOC,partition{1},[partition{2} class],c_classes)
                            if show_info
                                disp(['Including class ' num2str(class)]);
                            end
                            partition{2}=[partition{2} class];
                            data1=[data2 ; data_c];
                            class_c(num)=[];
                        end
                    end
                end
            end
        end
    else % remove
        if show_info
            disp([num2str(iterations-i) ' iterations left for SFFS. Removing step.']);
        end
        for j=1:steps
            if mod(j,2) % first partition
                if length(partition{1})~=0
                    num=ceil(rand*length(partition{1}));
                    if num==0
                        num=1;
                    end
                    data_c=data1;
                    data_c(find(data1(:,size(data_c,2))==partition{1}(num)),:)=[];
                    switch criterion
                        case 1,
                            MI_c=compute_MI(data_c, data2);
                        otherwise,
                            error('Exit: Mutual Information type bad defined.');
                    end
                    if MI_c<MI
                        partition_c=partition{1};
                        partition_c(num)=[];
                        if no_previous(ECOC,partition_c,partition{2},c_classes)
                            if show_info
                                disp(['Removing class ' num2str(partition{1}(num))]);
                            end
                            MI=MI_c;
                            partition{1}(num)=[];
                            data1=data_c;
                        end
                    end
                end
            else % second partition
                if length(partition{2})~=0
                    num=ceil(rand*length(partition{2}));
                    if num==0
                        num=1;
                    end
                    data_c=data2;
                    data_c(find(data2(:,size(data_c,2))==partition{2}(num)),:)=[];
                    switch criterion
                        case 1,
                            MI_c=compute_MI(data1, data_c);
                        otherwise,
                            error('Exit: Mutual Information type bad defined.');
                    end
                    if MI_c<=MI
                        partition_c=partition{2};
                        partition_c(num)=[];
                        if no_previous(ECOC,partition{1},partition_c,c_classes)
                            if show_info
                                disp(['Removing class ' num2str(partition{2}(num))]);
                            end
                            MI=MI_c;
                            partition{2}(num)=[];
                            data2=data_c;
                        end
                    end
                end
            end
        end
    end
end

part=zeros([1 size(ECOC,1)])';
for i=1:length(partition{1})
    part(find(c_classes==partition{1}(i)))=1;
end
for i=1:length(partition{2})
    part(find(c_classes==partition{2}(i)))=-1;
end
part(groups(1))=1;
part(groups(2))=-1;

%##########################################################################

function result=no_previous(ECOC,p1,p2,classes)

result=1;
vector=zeros([1 size(ECOC,1)]);
for i=1:length(p1)
    vector(find(classes==p1(i)))=1;
end
for i=1:length(p2)
    vector(find(classes==p2(i)))=-1;
end
for i=1:size(ECOC,2)
   if (sum(abs(ECOC(:,i)-vector'))==0)
       result=0;
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
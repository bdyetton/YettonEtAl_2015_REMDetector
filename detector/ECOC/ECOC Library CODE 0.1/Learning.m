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

function Learning(data,ECOC,base,folder_classifiers,classes,ada_iterations,positions)

for i=positions
    FirstSet=[];
    SecondSet=[];
    for j=1:size(ECOC,1)
        if ECOC(j,i)==1
            pos=find(data(:,size(data,2))==classes(j));
            FirstSet(size(FirstSet,1)+1:size(FirstSet,1)+length(pos),:)=data(pos,1:size(data,2)-1);
        elseif ECOC(j,i)==-1
            pos=find(data(:,size(data,2))==classes(j));
            SecondSet(size(SecondSet,1)+1:size(SecondSet,1)+length(pos),:)=data(pos,1:size(data,2)-1);
        end
    end
    switch base
        case 'NMC' % Nearest Mean Classifier
            NMC_classifier=NMC(FirstSet,SecondSet);
            save([folder_classifiers '/NMC_classifier_' num2str(i,'%d') '.mat'],'NMC_classifier','FirstSet','SecondSet');
        case 'ADA' % Adaboost
            [alpha,feature,p,thr]=BoostROC(FirstSet,SecondSet,ada_iterations);
            save([folder_classifiers '/ADA_classifier_' num2str(i,'%d') '.mat'],'FirstSet','SecondSet','alpha','feature','p','thr');
        case 'CUSTOM' % Custom
            Custom_classifier=Custom_base(FirstSet,SecondSet);
            save([folder_classifiers '/Custom_classifier_' num2str(i,'%d') '.mat'],'Custom_classifier','FirstSet','SecondSet');
        otherwise
            error('Exit: Base classifier bad defined.');
     end
end
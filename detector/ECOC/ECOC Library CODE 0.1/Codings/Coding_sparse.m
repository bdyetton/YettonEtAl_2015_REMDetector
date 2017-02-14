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

function [ECOC]=Coding_sparse(classes,columns,iterations,zero_prob)

if (zero_prob<0 || zero_prob>=1)
        error('Exit: Probability of the symbol zero must be in the interval [0,1)');
end
        
ECOCs=zeros([length(classes) columns]);
iterations_count=iterations;
dist=0;
while iterations_count>0
    for j=1:length(classes)
        for k=1:columns
            randvalue=rand;
            if randvalue>zero_prob
                if randvalue>(zero_prob+(1-zero_prob)/2)
                    ECOCs(j,k)=1;
                else
                    ECOCs(j,k)=-1;
                end
            end
        end
    end
    condition=0;
    for z=1:columns
        if (sum(ECOCs(:,z)==1)==0 || sum(ECOCs(:,z)==-1)==0)
            condition=1;
        end
    end
    if condition==0
        iterations_count=iterations_count-1;
        for j=1:length(classes)-1
            for k=j+1:length(classes)
                distance=sum(abs((ECOCs(j,:)-ECOCs(k,:)).*ECOCs(k,:).*ECOCs(j,:)))/2;
                if distance>dist
                    dist=distance;
                    ECOC=ECOCs;
                end
            end
        end
    end
end
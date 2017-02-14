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

function classes=StrongEvalROC(data,alpha,feature,p,thr)

T=length(alpha);
accum_result=zeros(size(data,1),1);
thresh=0;
for i=1:T
    accum_result=accum_result+alpha(i)*(p(i)*data(:,feature(i)) < p(i)*thr(i));
    thresh=thresh+alpha(i);
end;
classes=accum_result>=thresh/2;
if classes==0
  classes=-1;  
end
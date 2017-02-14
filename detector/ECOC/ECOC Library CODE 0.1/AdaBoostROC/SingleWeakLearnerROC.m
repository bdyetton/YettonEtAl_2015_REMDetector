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

function [thr,p]=SingleWeakLearnerROC(c1,w1,c2,w2)

V=[c1;c2];
dummy=ones(size(V,1),1);
W=[w1 w2]'*ones(size(V,2),1)';
valsumW=sum(W);
Y=[ones(size(c1)); zeros(size(c2))];

[V_sort,ind] = sort(V);
W_sort = W(ind);
Y_sort = Y(ind);

P_cum = cumsum(Y_sort .* W_sort); 
P_cum = P_cum/valsumW(1);
N_cum = cumsum((1-Y_sort) .* W_sort);
N_cum = N_cum/valsumW(1);

PN_cum1 = ( (dummy*max(P_cum)-P_cum) + N_cum); 
PN_cum2 = ( (dummy*max(N_cum)-N_cum) + P_cum); 

[min1,thresh_ind1]= min(PN_cum1);
[min2,thresh_ind2]= min(PN_cum2);

thresh_ind(find(min1>min2))=thresh_ind2(find(min1>min2));
PN_cum(:,min1>min2)=PN_cum2(:,min1>min2);
thresh_ind(find(min1<=min2))=thresh_ind1(find(min1<=min2));
PN_cum(:,find(min1<=min2))=PN_cum1(:,find(min1<=min2));
thresh_ind(thresh_ind==size(V,1))=thresh_ind(thresh_ind==size(V,1))-1;

desplazamiento=0:size(V_sort,2)-1;
thr_ind=thresh_ind+desplazamiento*size(V_sort,1);
thresh = ( V_sort(thr_ind)+V_sort(thr_ind+1))/2;
p = 2 *( (P_cum(thr_ind)>N_cum(thr_ind)) -0.5);
thr=thresh;
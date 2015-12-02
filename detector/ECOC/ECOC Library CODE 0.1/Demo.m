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

disp('ECOCs Library. v1.0 - GPL License - Copyright (c) 2008 Sergio Escalera');

try
    load data_glass.mat
catch
    error('Error: No training data');
end

disp('Calling the main ECOC function with Glass data, one-versus-all coding, Hamming decoding, and Adaboost base classifier. No parameters are included in the call, so default values are selected:');

[result,confusion,ECOC,labels]=ECOCs(data,[],'OneVsAll','HD','ADA')

disp('Press any key to continue'), pause

disp('Calling the main ECOC function to classify previous design over the same data:');

disp('Parameters.ECOC=ECOC');
Parameters.ECOC=ECOC;
[result,confusion,ECOC,labels]=ECOCs([],data,'OneVsAll','HD','ADA',Parameters)

disp('Press any key to continue'), pause

disp('Perform the same steps using a Sparse Random design with a Linear Loss-Weighted decoding:');

[result,confusion,ECOC,labels]=ECOCs(data,[],'Random','LLW','NMC')

disp('Press any key to continue'), pause

disp('Parameters.ECOC=ECOC');
Parameters.ECOC=ECOC;
[result,confusion,ECOC,labels]=ECOCs([],data,'Random','LLW','NMC',Parameters)
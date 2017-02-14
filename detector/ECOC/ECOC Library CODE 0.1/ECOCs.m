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

function [result,confusion,ECOC,labels]=ECOCs(data,TestData,coding,decoding,base,Parameters)

%##########################################################################

params=6;
if (nargin<params-1)
    error('Exit: Incorrect number of parameters to function ECOCs.');
else
    if nargin==5
        % Parameters
        Parameters.folder_classifiers='classifiers';
        Parameters.show_info=1;
        Parameters.ECOC=[];
        Parameters.columns=10;
        Parameters.iterations=3000;
        Parameters.zero_prob=0.5;
        Parameters.validation=0.15;
        Parameters.w_validation=0.5;
        Parameters.epsilon=0.05;
        Parameters.iterations_one=10;
        Parameters.steps_one=5;
        Parameters.ECOC_initial='OneVsOne';
        Parameters.one_mode=2;
        Parameters.iterations_sffs=5;
        Parameters.steps_sffs=5;
        Parameters.criterion_sffs=1;
        Parameters.number_trees=3;
        Parameters.ada_iterations=50;
    else
        % Parameters
        if isfield(Parameters,'folder_classifiers')==0
            Parameters.folder_classifiers='classifiers';
        end
        if isfield(Parameters,'show_info')==0
            Parameters.show_info=1;
        end
        if isfield(Parameters,'ECOC')==0
            Parameters.ECOC=[];
        end
        %   Coding
        %       Sparse
        if isfield(Parameters,'columns')==0
            Parameters.columns=10;
        end
        if isfield(Parameters,'iterations')==0
            Parameters.iterations=3000;
        end
        if isfield(Parameters,'zero_prob')==0
            Parameters.zero_prob=0.5;
        end
        %       ECOC-ONE
        if isfield(Parameters,'validation')==0
            Parameters.validation=0.15;
        end
        if isfield(Parameters,'w_validation')==0
            Parameters.w_validation=0.5;
        end
        if isfield(Parameters,'epsilon')==0
            Parameters.epsilon=0.05;
        end
        if isfield(Parameters,'iterations_one')==0
            Parameters.iterations_one=20;
        end
        if isfield(Parameters,'steps_one')==0
            Parameters.steps_one=5;
        end
        if isfield(Parameters,'ECOC_initial')==0
            Parameters.ECOC_initial='OneVsOne';
        end
        if isfield(Parameters,'one_mode')==0
            Parameters.one_mode=2;
        end
        if isfield(Parameters,'iterations_sffs')==0
            Parameters.iterations_sffs=5;
        end
        if isfield(Parameters,'steps_sffs')==0
            Parameters.steps_sffs=5;
        end
        if isfield(Parameters,'criterion_sffs')==0
            Parameters.criterion_sffs=1;
        end
        %       Forest-ONE
        if isfield(Parameters,'number_trees')==0
            Parameters.number_trees=3;
        end
        %   Base classifier
        %       Discrete Adaboost
        if isfield(Parameters,'ada_iterations')==0
            Parameters.ada_iterations=50;
        end
    end
end

ECOC=Parameters.ECOC;
show_info=Parameters.show_info;

if size(data,1)~=0
    if (size(data,2)<2)
        error('Exit: Incorrect size of data.');
    end

    classes=unique(data(:,size(data,2)));
    number_classes=length(classes);

    if (number_classes<2)
        error('Exit: Incorrect number of classes.');
    end

    try
        mkdir(Parameters.folder_classifiers);
    catch
        error('Exit: Error defining folfer Parameters.folder_classifiers.');
    end

    switch coding, % Define the coding matrix
        case 'OneVsOne', % one-versus-one design
            ECOC=zeros([number_classes number_classes*(number_classes-1)/2]);
            counter=1;
            for i=1:number_classes-1
                for j=i+1:number_classes
                    ECOC(i,counter)=1;
                    ECOC(j,counter)=-1;
                    counter=counter+1;
                end
            end
        case 'OneVsAll', % one-versus-all design
            ECOC=-1*ones([number_classes number_classes]);
            for i=1:number_classes
                ECOC(i,i)=1;
            end
        case 'Random', % Sparse design
            if show_info
                disp(['Computing sparse coding matrix'])
            end
            [ECOC]=Coding_sparse(classes,Parameters.columns,Parameters.iterations,Parameters.zero_prob);
        case 'ECOCONE', % ECOC-ONE design
            try
                if ((Parameters.validation<=0) || (Parameters.validation>=1))
                    error('Exit: Size of validation subset must be between (0,1) for the ecoc-one coding design.');
                end
            catch
                error('Exit: Parameters.validation bad defined.');
            end
            try
                if ((Parameters.w_validation<=0) || (Parameters.w_validation>=1))
                    error('Exit: Weight of validation subset must be between (0,1) for the ecoc-one coding design.');
                end
            catch
                error('Exit: Parameters.w_validation bad defined.');
            end
            try
                if ((Parameters.epsilon<0) || (Parameters.epsilon>1))
                    error('Exit: Value of epsilon must be between 0 and 1 for the ecoc-one coding design.');
                end
            catch
                error('Exit: Parameters.epsilon bad defined.');
            end
            switch Parameters.ECOC_initial, % Define the initial coding matrix for ECOC-ONE
                case 'OneVsOne', % one-versus-one design
                    ECOC=zeros([number_classes number_classes*(number_classes-1)/2]);
                    counter=1;
                    for i=1:number_classes-1
                        for j=i+1:number_classes
                            ECOC(i,counter)=1;
                            ECOC(j,counter)=-1;
                            counter=counter+1;
                        end
                    end
                case 'OneVsAll', % one-versus-all design
                    ECOC=-1*ones([number_classes number_classes]);
                    for i=1:number_classes
                        ECOC(i,i)=1;
                    end
                case 'Random', % Sparse design
                    if show_info
                        disp(['Computing sparse coding matrix for ecoc-one initialization'])
                    end
                    [ECOC]=Coding_sparse(classes,Parameters.columns,Parameters.iterations,Parameters.zero_prob);
                otherwise,
                    ECOC=Parameters.ECOC;
            end
            if (size(ECOC,2)<1)
                error('Exit: At least an initial one-column matrix is required for the ecoc-one coding design.');
            end
            ECOC=ecoc_one(ECOC,classes,data,Parameters,base,decoding,show_info);
        case 'DECOC', % DECOC design
            if show_info
                disp(['Computing DECOC coding matrix'])
            end
            ECOC=DECOC(classes,data,Parameters.criterion_sffs,Parameters.iterations_sffs,show_info);
        case 'Forest', % Forest-ECOC design
            if show_info
                disp(['Computing Forest-ECOC coding matrix'])
            end
            ECOC=Forest(classes,data,Parameters.criterion_sffs,Parameters.iterations_sffs,Parameters.number_trees,show_info);
        otherwise,
            error('Exit: Coding design bad defined.');
    end
    if show_info
        disp(['Learning coding matrix :']);
        disp(ECOC)
    end
    Learning(data,ECOC,base,Parameters.folder_classifiers,classes,Parameters.ada_iterations,1:size(ECOC,2));
end

if size(TestData,1)~=0
    if show_info
        disp(['Testing ECOC design'])
    end
    if ((size(data,1)~=0) & (size(TestData,2)~=size(data,2)))
        error('Exit: Training and testing data dimensions do not match.');
    else
        if size(data,1)==0
            classes=1:size(ECOC,1);
        end
        if size(ECOC,1)==0
            error('Exit: ECOC matrix not defined.');
        else
            [result,confusion,labels]=Decoding(TestData,classes,ECOC,base,Parameters.folder_classifiers,decoding);
        end
    end
else
    labels=[];
    result=[];
    confusion=[];
end
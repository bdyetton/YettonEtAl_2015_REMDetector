clc
clear
close all


%% OpenTSTOOL Initialization
% CurrentFolder = pwd;
% if ismac
%     if  isempty(findstr(strcat(CurrentFolder,'/OpenTSTOOL/Mac/OpenTSTOOL/tstoolbox/demos'),path))
%         cd(strcat(CurrentFolder,'/OpenTSTOOL/Mac/OpenTSTOOL'))
%         settspath
%         tstoolInit
%         cd(CurrentFolder)
%     end
% elseif isunix
%     if  isempty(findstr(strcat(CurrentFolder,'/OpenTSTOOL/Linux/OpenTSTOOL/tstoolbox/demos'),path))
%         cd(strcat(CurrentFolder,'/OpenTSTOOL/Linux/OpenTSTOOL'))
%         settspath
%         tstoolInit
%         cd(CurrentFolder)
%     end
% elseif ispc
%     if  isempty(findstr(strcat(CurrentFolder,'\OpenTSTOOL\Windows\OpenTSTOOL\tstoolbox\demos'),path))
%         cd(strcat(CurrentFolder,'\OpenTSTOOL\Windows\OpenTSTOOL'))
%         settspath
%         tstoolInit
%         cd(CurrentFolder)
%     end
% end

%% Load Data

S = randn(1,10000);
label = 101:100:10000;
fs = 20;
Tw = 1*fs; % Window of analysis

N = length(S);
Nw = floor(N/Tw); % Number of windows

%% Embedding Dimension and Correlation Delay Estimation

Lr = 100*fs;  % Length of signal for m and tau calculation

Sr = S(1:Lr)';
[m, tau] = dimension_delay(Sr);
return

%% Similarity Features

% Reference signal construction:
Nr = 10; % Number of events to be used for reference construction
SW = [];
for n=1:Nr
    Sw = S(label(n)-Tw/2+1:label(n)+Tw/2);
    SW = [SW; Sw];
end
SMean = mean(SW);
Sref = SMean; % Reference signal

Sim_H = zeros(1,Nw); % Dynamical similarity index
Sim_F = zeros(1,Nw); % Fuzzy similarity index
Dis_B = zeros(1,Nw); % Bhattacharyya based dissimilarity index

for n=1:Nw
    Sw = S((n-1)*Tw+1:n*Tw); % Current window
    
    [Sim_H_w,Sim_F_w,Dis_B_w] = Similarity_features(Sw,Sref,m,tau);
    
    Sim_H(n) = Sim_H_w;
    Sim_F(n) = Sim_F_w;
    Dis_B(n) = Dis_B_w;
end

%% Recurrence Quantitative Analysis

v_min = 2;
l_min = 2;

REC  = zeros(1,Nw); % Recurrence rate
DET  = zeros(1,Nw); % Determinism
L    = zeros(1,Nw); % Averaged diagonal line length
Lm   = zeros(1,Nw); % Maximal length of the diagonal lines
LAM  = zeros(1,Nw); % Laminarity
TT   = zeros(1,Nw); % Trapping time
ENTR = zeros(1,Nw); % Entropy

for n=1:Nw
    Sw = S((n-1)*Tw+1:n*Tw); % Current window
    [REC_w,DET_w,L_w,Lm_w,LAM_w,TT_w,ENTR_w] = RQA_features(Sw,m,tau,v_min,l_min);
    
    REC(n)  = REC_w;
    DET(n)  = DET_w;
    L(n)    = L_w;
    Lm(n)   = Lm_w;
    LAM(n)  = LAM_w;
    TT(n)   = TT_w;
    ENTR(n) = ENTR_w;
end

%Each individually
%then as a set (RQA features/Similarity Features)
%All but old features
%All + old features

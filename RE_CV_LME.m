%% RE_EEG_LME
% We will use a Linear Mixed Effect Model
% The model will have as response the Results variable (Relative Power and
% CV); as Fixed effect the Nº of Sessions; and then a series of random
% effect (CNS, Subject, Cluster)
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

T = readtable("Results_CV.csv");      % CV for each band relative power

%% Fit a linear mixed-effect model for EEG features (MODEL #1)
% 
formula_alpha = 'alphaRP_CV~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
lme_alpha = fitlme(T,formula_alpha)

% formula_delta = 'deltaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_delta = fitlme(T,formula_delta)

% formula_theta = 'thetaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_theta = fitlme(T,formula_theta)

% formula_beta = 'betaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_beta = fitlme(T,formula_beta)


%%  Fit a linear mixed-effect model for EEG features (MODEL #2)
% Now we include cluster information
formula_alpha = 'alphaRP_CV~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_alpha_2 = fitlme(T,formula_alpha)
% 
% formula_delta = 'deltaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_delta = fitlme(T,formula_delta)

% formula_theta = 'thetaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_theta = fitlme(T,formula_theta)

% formula_beta = 'betaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_beta = fitlme(T,formula_beta)

%%
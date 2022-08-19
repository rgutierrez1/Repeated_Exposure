%% RE_LME
% We will use a Linear Mixed Effect Model
% The model will have as response the Results variable (Relative Power and
% CV); as Fixed effect the Nº of Sessions; and then a series of random
% effect (CNS, Subject, Cluster)
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

T = readtable("Results_EEG.csv");       % Band Relative Power Data
% T = readtable("Results_CV.csv");      % CV for each band relative power
%%
% idx_CNS = T.CNS == 1; % To select and filter CNS patients
% idx_No_CNS = T.CNS == 0; % To select and filter CNS patients
% 
% newTbl = T(idx_CNS,:); % For CNS patients
% newTbl = T(idx_No_CNS,:); % For No CNS Patients

%% Fit a linear mixed-effect model for EEG features

formula_alpha = 'alphaRP~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
% formula_delta = 'deltaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula_theta = 'thetaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula_beta = 'betaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula = 'alpha_max~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_alpha = fitlme(T,formula_alpha);
% lme_delta = fitlme(T,formula_delta);
% lme_theta = fitlme(T,formula_theta);
% lme_beta = fitlme(T,formula_beta);
lme_alpha
%% Get fit and residual data
F = fitted(lme_alpha);
R = response(lme_alpha);
plot(R,F,'rx')

%%
plotResiduals(lme_alpha,'fitted')

%% Find and remove outliers
outliers = find(residuals(lme_alpha) > 0.1 | residuals(lme_alpha) < -0.1);
lme_apha_v2 = fitlme(T,formula_alpha,'Exclude',outliers);
lme_apha_v2
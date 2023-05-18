%% RE_EEG_LME
% We will use a Linear Mixed Effect Model
% The model will have as response the Results variable (Relative Power and
% CV); as Fixed effect the Nº of Sessions; and then a series of random
% effect (CNS, Subject, Cluster)
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
cd '/Users/rodrigo/Codes/Repeated_Exposure';

%T = readtable("Results_SEF.csv");       % SEF results
%T = readtable("Results_PAM.csv");       % PAM results
T = readtable("Results_EEG.csv");       % Band Relative Power Data
%T = readtable("Results_CV.csv");      % CV for each band relative power
%% Fit a linear mixed-effect model for EEG features (MODEL #1)

formula_alpha = 'alphaRP~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
lme_alpha = fitlme(T,formula_alpha)
lme_alpha.Rsquared

formula_delta = 'deltaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_delta = fitlme(T,formula_delta)
lme_delta.Rsquared

formula_theta = 'thetaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_theta = fitlme(T,formula_theta)
lme_theta.Rsquared
% 
formula_beta = 'betaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_beta = fitlme(T,formula_beta)
lme_beta.Rsquared

% formula = 'alpha_max~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_alpha

%% Fit a linear mixed-effect model for EEG features (MODEL #2)
% Now we include et sevo information as a covariate (a second fixed effect)
formula_alpha = 'alphaRP~Sesi_n+etSevo+(1+Sesi_n|Sujeto)+(1|CNS)';
lme_alpha = fitlme(T,formula_alpha)
lme_alpha.Rsquared
%%  Fit a linear mixed-effect model for EEG features (MODEL #3)
% Now we include cluster information
formula_alpha_2 = 'alphaRP~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_alpha_2 = fitlme(T,formula_alpha_2)
lme_alpha_2.Rsquared

formula_delta_2 = 'deltaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_delta_2 = fitlme(T,formula_delta_2)
lme_delta_2.Rsquared

formula_theta_2 = 'thetaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_theta_2 = fitlme(T,formula_theta_2)
lme_theta_2.Rsquared

formula_beta_2 = 'betaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_beta_2 = fitlme(T,formula_beta_2)
lme_beta_2.Rsquared

%%
% Get fit and residual data
F = fitted(lme_alpha);
R = response(lme_alpha);
plot(R,F,'rx')

%%
plotResiduals(lme_alpha,'fitted')

%% Find and remove outliers
outliers = find(residuals(lme_alpha) > 0.1 | residuals(lme_alpha) < -0.1);
lme_apha_v2 = fitlme(T,formula_alpha,'Exclude',outliers);
lme_apha_v2

%% LME for PAM results

formula_Kmod = 'K_mod~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
Kmod_LME = fitlme(T,formula_Kmod)
Kmod_LME.Rsquared

formula_Phimod = 'Phi_mod~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
Phi_LME = fitlme(T,formula_Phimod)
Phi_LME.Rsquared

%% LME for SEF results
formula_SEF = 'sef~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)+(1+Sesi_n|Cluster)';
sef_LME = fitlme(T,formula_SEF)
sef_LME.Rsquared

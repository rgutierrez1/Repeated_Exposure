%% RE_EEG_LME
% We will use a Linear Mixed Effect Model
% The model will have as response the Results variable (Relative Power and
% CV); as Fixed effect the Nº of Sessions; and then a series of random
% effect (CNS, Subject, Cluster)
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

% T = readtable("EEG_Results_v1.csv");
T = readtable("Results_EEG.csv");       % Band Relative Power Data
% T = readtable("Results_CV.csv");      % CV for each band relative power
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
%%  Fit a linear mixed-effect model for EEG features (MODEL #2)
% Now we include cluster information
formula_alpha = 'alphaRP~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_alpha_2 = fitlme(T,formula_alpha)

formula_delta = 'deltaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_delta = fitlme(T,formula_delta)

formula_theta = 'thetaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_theta = fitlme(T,formula_theta)

formula_beta = 'betaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
lme_beta = fitlme(T,formula_beta)

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
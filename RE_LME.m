%% RE_LME
clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

T = readtable("EEG_Results.csv");
% T = readtable("CV_Results.csv");
%%
% idx_CNS = T.CNS == 1; % To select and filter CNS patients
% idx_No_CNS = T.CNS == 0; % To select and filter CNS patients
% 
% newTbl = T(idx_CNS,:); % For CNS patients
% newTbl = T(idx_No_CNS,:); % For No CNS Patients

%% Fit a linear mixed-effect model for EEG features

% formula = 'alphaRP~Sesi_n+(1|Sujeto)+(Sesi_n-1|Sujeto)';
% formula = 'alphaRP~Sesi_n+(Sesi_n|Sujeto)';
formula_alpha = 'alphaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula_delta = 'deltaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula_theta = 'thetaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula_beta = 'betaRP~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% formula = 'alpha_max~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_alpha = fitlme(T,formula_alpha);
% lme_delta = fitlme(T,formula_delta);
% lme_theta = fitlme(T,formula_theta);
% lme_beta = fitlme(T,formula_beta);
lme_alpha
%% Fit a linear mixed-effect model for EEG features
F = fitted(lme_alpha);
R = response(lme_alpha);
plot(R,F,'rx')

%%
plotResiduals(lme_alpha,'fitted')

%%
outliers = find(residuals(lme_alpha) > 0.1 | residuals(lme_alpha) < -0.1);

%%
lme_apha_v2 = fitlme(T,formula_alpha,'Exclude',outliers);
lme_apha_v2
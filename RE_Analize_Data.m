%% RE_Analize_Data
% Load csv file from Samuel

clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

%%

T = readtable("waves_newtimes.csv");

%%

idx = T.Sujeto == 1 & T.Sesi_n == 5;
newTbl = T(idx,:);

%%
EEG_parameters = newTbl(:,"alpha_max":end);

Mean_Parameters = mean(newTbl,1);
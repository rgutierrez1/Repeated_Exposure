%% RE_SEF
% SEF95 for each subject-session

clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
addpath(genpath('/Users/rodrigo/Documents/MATLAB/Toolbox_&_Functions/Chronux_2_11'));

cd '/Users/rodrigo/Codes/Repeated_Exposure';

T = readtable('Results_SEF.csv');

%% MT params
params.tapers = [2 3];        %[TW K] Time(T) = 5 segs, Bandwith(W) = 1 Hz, Tapers(K) = 2TW-1 = 5
params.pad = 0;               % Padding factor; -1 no padding; 0 to the next power of 2
params.Fs = [];
params.fpass = [1 40];
params.err = 0;               % Error calculation; 1: theorical; 2: Jackniffe
params.trialave = 0;          % A verage over trial
%
win = 4;                      % window length  
segave = 1;                   % average over segments for 1, dont average for 0
fq_resolution = 2*params.tapers(1)/win;     % calculate frequency resolution

%%
for k=1:133
    load (['P' num2str(T.Sujeto(k)) '.'  num2str(T.record(k)) '.mat'])
    disp(['Analyzing Subject ' num2str(T.Sujeto(k)) ' Session ' num2str(T.record(k))])
    params.Fs = Fs;
    time_init = T.time_init(k)*60*Fs;
    time_end = time_init + Fs*120;
    data = EEG.F7(time_init:time_end); 
    [S,f] = mtspectrumsegc(data,win,params,segave);
    SEF_95 = SEF95(S,f);
    T.sef(k) = SEF_95;
end
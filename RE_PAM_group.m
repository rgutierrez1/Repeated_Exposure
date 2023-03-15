%% RE_PAM_Group
% SS PAM to estimate the average Pmod and Kmod for each kid and session

clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
addpath(genpath('/Users/rodrigo/Documents/MATLAB/Toolbox_&_Functions/Chronux_2_11'));
addpath(genpath('/Users/rodrigo/Documents/MATLAB/Toolbox_&_Functions/SSP_PAC'));

cd '/Users/rodrigo/Codes/Repeated_Exposure';

T = readtable('Results_PAM.csv');

%%
% Initialize and fit oscillator model
convergenceTolerance=eps;
em_its=100;
doPlot=0;
namecur= 'RDT';

init_params=struct();
init_params.f_init     =  [1, 10];
init_params.a_init     =  [0.98, 0.98];
init_params.sigma2_init=  [1,1];
init_params.R          =  1;
init_params.NNharm     =  [1, 1];

Kappa_tot = [10,10]; slowID = 1; fastID = 2;


%% Obtain Kmod and Phimod by session for ALL SUBJECT

for k=1:144
    load (['P' num2str(T.Sujeto(k)) '.'  num2str(T.record(k)) '.mat'])
    time_init = T.time_init(k)*60*Fs;
    time_end = time_init + Fs*90;
    data = EEG.F7(time_init:time_end); 

    dur = length(data);
    dur_sec = dur/Fs;

    N = 2*floor(Fs);                              % Window length
    Nwind=floor(dur_sec/2);                     % Window Number
    tt= (1:Nwind*N);

    StaPointId = ((1:Nwind)-1)*N +1;
    EndPointId = StaPointId+N-1;

    y_t = data(1:Nwind*N);                      % The signal
    y_t=y_t';

    %
    modelOsc=ssp_decomp(y_t,Fs,StaPointId,EndPointId,em_its,convergenceTolerance, init_params,namecur,doPlot);
    [processed_ssp_pac,regressed_pac,~, X_t_tot] = ssp_pac_main(modelOsc,slowID,fastID,Kappa_tot);
    
    T.K_mod(k) = mean(processed_ssp_pac.K_mis(1,:));
    T.Phi_mod(k) = mean(processed_ssp_pac.Phi_mis(1,:));
    
end
%%
filename = 'PAM_results_2.csv';
writetable(T,filename);
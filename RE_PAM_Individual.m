%% RE_PAM_Individual
% SS PAM for 1 indivual and plot

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

for k=120
    load (['P' num2str(T.Sujeto(k)) '.'  num2str(T.record(k)) '.mat'])
    disp(['Analyzing Subject ' num2str(T.Sujeto(k)) ' Session ' num2str(T.record(k))])
    time_init = T.time_init(k)*60*Fs;
    time_end = time_init + Fs*120;
    data = EEG.F7(time_init:time_end); 
    
    dur = length(data);
    dur_sec = dur/Fs;
    
    N = 2*floor(Fs);                            % Window length
    Nwind=floor(dur_sec/2);                     % Window Number
    tt= (1:Nwind*N);
    
    StaPointId = ((1:Nwind)-1)*N +1;
    EndPointId = StaPointId+N-1;
    
    y_t = data(1:Nwind*N);                      % The signal
    y_t=y_t';
    
    %
    modelOsc=ssp_decomp(y_t,Fs,StaPointId,EndPointId,em_its,convergenceTolerance, init_params,namecur,doPlot);
    [processed_ssp_pac,regressed_pac,~, X_t_tot] = ssp_pac_main(modelOsc,slowID,fastID,Kappa_tot);
    
%     params.tapers = [3 5];
%     params.pad = 0;
%     params.Fs = Fs;
%     params.fpass = [1 40];
%     params.trialave = 0;
%     win = [2 1];                          
%     data = transpose(data);
%     
%     [S,t,f]= mtspecgramc(data,win,params);
    
        
    %
    tVect = processed_ssp_pac.tVect;
    pbins = processed_ssp_pac.pbins;
    figure
    hold on
    cmin = 0; cmax = 2/(2*pi);
    % cmin = 0.12; cmax = 0.2;
    imagesc(tVect ,pbins,processed_ssp_pac.PAC);
    col = redbluemap; colormap(col);
    colorbar('location', 'west')
    set(gca, 'clim', [cmin cmax]);
    %set(gca, 'clim', [0.1 0.2]);
    axis tight
    xlim([tVect(1) tVect(end)])
    ylabel('Phase (rad)')
    xlabel('[sec]')
    title('State Space PAM (window length 2s)', 'FontSize', 16)
    box on
end

%%


    subplot(2,1,1)
    pcolor(t, f, 10 * log10(S'))
    hold on
    axis xy
    caxis([-20 20])
    ylim([1 40])
    shading('interp')
    colormap ('jet')
    h1=colorbar;
    h1.Label.String = 'dB'; h1.Label.FontSize = 14; h1.Label.FontWeight = 'bold'; h1.Location = "west";
    title('State Space PAM (window length 2s)','FontSize',12,'FontWeight','bold')
    xlabel('Time (m)','FontSize',18,'FontWeight','bold')
    ylabel('Frequency (Hz)','FontSize',10,'FontWeight','bold')
    hold off
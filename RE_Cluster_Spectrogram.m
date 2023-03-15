%% RE_Cluster_Spectrograms
% MT average spectrogram for subject 22
clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
addpath(genpath('/Users/rodrigo/Documents/MATLAB/Toolbox_&_Functions/Chronux_2_11'));
cd '/Users/rodrigo/Codes/Repeated_Exposure';

Cluster_1 = [3,6,7,12,15,19,20,21,24];
% Cluster_2 = [2,9,11,13,16,17,18,22];
%%
params.tapers = [3 5];
params.pad = 0;
params.Fs = [];
params.fpass = [1 40];
params.err = [1 0.05];
params.trialave = 0;
win = [2 1]; 
%%
for k=1:length(Cluster_1)
    xx = Cluster_1(k);
    filename = ['P' num2str(xx) '_time_stamp.csv'];
    T = readtable(filename);
    Sall = zeros(1,112);
    for kk=1:size(T,1)
        load (['P' num2str(xx) '.' num2str(T.record(kk)) '.mat'])
        init = T.Var6(kk)*Fs*60;
        term = T.Var7(kk)*Fs*60;
        params.Fs = Fs;
        data = EEG.F7(init:term);
        [S,t,f]= mtspecgramc(data,win,params);
        Sall = vertcat(Sall, S);
    end
    subplot(10,1,k)
    Sall = Sall(2:end,:);
    a = size(Sall,1);
    b = max(T.session);
    t = linspace(1,b,a);
    pcolor(t, f, 10 * log10(Sall'))
    hold on
    axis xy
    caxis([-20 30])
    % caxis('auto')
    ylim([1 30])
    shading('interp')
    colormap ('jet')
    h1=colorbar;
    h1.Label.String = 'dB'; h1.Label.FontSize = 14; h1.Label.FontWeight = 'bold';
    lim1 = h1.Limits;
    % title('ID64 FP2','FontSize',14,'FontWeight','bold')
    xlabel('Time (sessions)','FontSize',8,'FontWeight','bold')
    ylabel('Frequency (Hz)','FontSize',8,'FontWeight','bold')
%     title('ID 9','FontSize',14,'FontWeight','bold')
    % set(get(h1,'title'),'string','dB','FontSize',14,'FontWeight','bold');
    % set(gca,'FontSize',12)
    hold off
    
end
%% P9
S_9 = zeros(1,224);
for k=1:10
    load (['P9.' num2str(k) '.mat'])
    init = T.Var6(k)*Fs*60;
    term = T.Var7(k)*Fs*60;
    params.Fs = Fs;
    data = EEG.F7(init:term);
    [S,t,f]= mtspecgramc(data,win,params);
    S_9 = vertcat(S_9, S);
end

%%
S_24 = zeros(1,224);
for k=1:12
    load (['P24.' num2str(k) '.mat'])
    init = TT.Var6(k)*Fs*60;
    term = TT.Var7(k)*Fs*60;
    params.Fs = Fs;
    data = EEG.F7(init:term);
    [S,t,f]= mtspecgramc(data,win,params);
    S_24 = vertcat(S_24, S);
end
%%
% t = 1:1:1298;
subplot(2,1,1)
S_9 = S_9(2:end,:);
t = linspace(1,28,580);
pcolor(t, f, 10 * log10(S_9'))
hold on
axis xy
caxis([-20 30])
% caxis('auto')
ylim([1 40])
shading('interp')
colormap ('jet')
h1=colorbar;
h1.Label.String = 'dB'; h1.Label.FontSize = 14; h1.Label.FontWeight = 'bold';
lim1 = h1.Limits;
% title('ID64 FP2','FontSize',14,'FontWeight','bold')
xlabel('Time (sessions)','FontSize',12,'FontWeight','bold')
ylabel('Frequency (Hz)','FontSize',12,'FontWeight','bold')
title('ID 9','FontSize',14,'FontWeight','bold')
% set(get(h1,'title'),'string','dB','FontSize',14,'FontWeight','bold');
% set(gca,'FontSize',12)
hold off

subplot(2,1,2)
S_24 = S_24(2:end,:);
t = linspace(1,34,696);
pcolor(t, f, 10 * log10(S_24'))
hold on
axis xy
caxis([-20 30])
ylim([1 40])
shading('interp')
colormap ('jet')
h1=colorbar;
h1.Label.String = 'dB'; h1.Label.FontSize = 14; h1.Label.FontWeight = 'bold';
lim1 = h1.Limits;
title('ID 24','FontSize',14,'FontWeight','bold')
xlabel('Time (sessions)','FontSize',12,'FontWeight','bold')
ylabel('Frequency (Hz)','FontSize',12,'FontWeight','bold')
hold off
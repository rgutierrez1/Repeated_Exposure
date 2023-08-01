%% RE_Protocol_Scheme
clear variables; clc;
addpath(genpath('~/Codes/Repeated_Exposure'));
addpath(genpath('~/Codes/Chronux_2_11'));
cd '~/Codes/Repeated_Exposure';

%%

load P22_EEG/P22.4.mat;

%%
params.tapers = [3 5];
params.pad = 0;
params.Fs = Fs;
params.fpass = [1 40];
params.err = [1 0.05];
params.trialave = 0;
win = [5 2];

data = EEG.F7;
[S,t,f]= mtspecgramc(data,win,params);

%%
sevo = zeros(10,2);

%%
subplot(3,1,1)
plot(sevo(:,1),sevo(:,2), 'LineWidth',2, 'Color', "#D95319")
hold on
ylabel('etSevoflurane (%)', 'FontSize',14, 'FontWeight','bold')
xlabel('Time (m)','FontSize',14, 'FontWeight','bold')
ylim([0 8])
xlim('tight')
grid on
hold off

t= t/60;
subplot(3,1,2)
pcolor(t, f, 10 * log10(S'))
hold on
axis xy
clim([-20 30])
% caxis('auto')
ylim([1 30])
shading('interp')
colormap ('jet')
h1=colorbar;
h1.Label.String = 'dB'; h1.Label.FontSize = 14; h1.Label.FontWeight = 'bold';
lim1 = h1.Limits;
xlabel('Time (m)','FontSize',14,'FontWeight','bold')
ylabel('Frequency (Hz)','FontSize',14,'FontWeight','bold')
hold off

init = 1100*Fs;
tend = init + (120*Fs);
data2 = data(init:tend);
tvect = linspace(0,120,length(data2));
subplot(3,1,3)
plot(tvect,data2)
xlabel('Time (s)','FontSize',14,'FontWeight','bold')
ylabel('Voltage (\muV)','FontSize',14,'FontWeight','bold')
ylim([-250 250])
axis tight
grid on
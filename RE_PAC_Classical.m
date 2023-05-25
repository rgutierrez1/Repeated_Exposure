%% RE_PAM_Classical
close all; clear all; clc

addpath(genpath('/Users/rodrigo/Documents/MATLAB/Toolbox_&_Functions/CFC_PAC'))
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'))
addpath(genpath('/Users/rodrigo/Codes/SS_PAM'))
cd '/Users/rodrigo/Codes/Repeated_Exposure';

T = readtable('Results_PAM.csv');

%%
k=10;
load (['P' num2str(T.Sujeto(k)) '.'  num2str(T.record(k)) '.mat'])


%%
time_init = T.time_init(k)*60*Fs;
time_end = time_init + Fs*120;
data = EEG.F7(time_init:time_end); 

[P,Q] = rat(100/Fs);
y_t = resample(data,P,Q);
Fs = 100;
%% Define non overlapping windows

Window_length = [120,30,6,2];


for i = 1:4
    wind_len_sec = Window_length(i);
    wind_len = wind_len_sec*Fs;
    
    Nwind=floor(length(y_t)./wind_len);
    
    startPointID=1+(0:Nwind-1)*wind_len_sec*Fs;
    endPointID=startPointID+wind_len_sec*Fs-1;
    
    %
    tvecmin = 0.5*(startPointID+endPointID)/(Fs*60);
    
    slowfreq = [0.1,1];
    fastfreq = [8,12];
    filter_order = 400;
    
    MI_KL = zeros(Nwind,1);
    
    tail=ceil(filter_order/2);
    endPointId_notail = endPointID-tail;
    
    phase_slow = zeros(1,sum(endPointId_notail-startPointID+1));
    ampli_fast = zeros(1,sum(endPointId_notail-startPointID+1));
    
    Npb = 18;
    pbins = linspace(-pi, pi, Npb);
    pbins2= linspace(-pi, pi, Npb-1);
    pac = zeros(Nwind,Npb-1);
    
    % Standard PAC

    [slow_tmp, tail_slow] = quickbandpass(y_t, Fs, slowfreq,filter_order);
    [fast_tmp, tail_fast] = quickbandpass(y_t, Fs, fastfreq,filter_order); 
    
    for tt = 1:Nwind
        disp([' Windows : ' , num2str(tt), '/' ,num2str(Nwind)   ])
                
%         sig_cur = detrend(y_t(1,startPointID(tt):endPointID(tt)));
%         [slow_tmp, tail_slow] = quickbandpass(sig_cur, Fs, slowfreq,filter_order);
%         [fast_tmp, tail_fast] = quickbandpass(sig_cur, Fs, fastfreq,filter_order);
        
%         x_slow(1,startPointID(tt):endPointID(tt))=slow_tmp;
%         x_fast(1,startPointID(tt):endPointID(tt))=fast_tmp;
%         y_obs(1,startPointID(tt):endPointID(tt))=sig_cur;
        
%         x_fast_hilb = hilbert(fast_tmp(1:end-tail_fast));
%         x_slow_hilb = hilbert(slow_tmp(1:end-tail_slow));
        x_fast_hilb = hilbert(fast_tmp(1,startPointID(tt):endPointID(tt)));
        x_slow_hilb = hilbert(slow_tmp(1,startPointID(tt):endPointID(tt)));
        
        amp   = abs(x_fast_hilb);
        phase = angle(x_slow_hilb);
        
        pa=phaseamp(amp,phase,pbins);
        pa = pa/(sum(pa)*(2*pi/(Npb-1)));
        pac (tt,:) = pa;
        
        MI_KL_tmp = sum(pa.*log2(pa.*(2*pi))*(2*pi/(Npb-1)));
    
        MI_KL(tt,1)=MI_KL_tmp;
        
        phase_slow (startPointID(tt):endPointID(tt)) = phase;
        ampli_fast (startPointID(tt):endPointID(tt)) = amp;
        
    end
     
    %
    cramge = 0.5/pi;
    cmin = 1/(2*pi)-cramge;
    cmax = 1/(2*pi)+cramge;
    
    subplot(5,1,i)
    imagesc((60*tvecmin) ,pbins2,pac');
    axis 'xy'
    col = redbluemap; colormap(col);
    colorbar('location', 'west')
    set(gca, 'clim', [cmin cmax]);
    axis tight
    ylabel('(rad)')
    xlabel('(min)')
    title(['Window length: ' num2str(Window_length(i)) ' sec'])
    box on

end

%%
phi_max = zeros(40,1);
for k = 1:40
    [M, I] = max(pac(k,:));
    phi_max(k,1) = pbins2(I);
end
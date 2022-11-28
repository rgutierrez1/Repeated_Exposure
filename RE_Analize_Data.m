%% RE_Analize_Data
% Load csv file from Samuel

clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

%%

T = readtable("waves_newtimes.csv");
Results = readtable("Results_EEG.csv"); % Give the ID and Sessions for the loop

%%
for k=1:147
    ID = Results.Sujeto(k);
    Session = Results.Sesi_n(k);
    idx = T.Sujeto == ID & T.Sesi_n == Session;
    newTbl = T(idx,:);
    EEG_parameters = newTbl(:,4:end);
    EEG_parameters_numb = EEG_parameters{:,:};
    Mean_Parameters = mean(EEG_parameters_numb,1,'omitnan');
    Std_Parameters = std(EEG_parameters_numb,1,'omitnan');
    CV_Parameters = Std_Parameters./Mean_Parameters;
    R = array2table(CV_Parameters);
    Results(k,3:7) = R;
end
%%
filename = "CV_Results.csv";
writetable(Results,filename);

%%
plot(Results.Sesi_n,Results.alphaRP,'o')
ylabel('Alpha Relative Power', 'FontSize',14)
xlabel('Session', 'FontSize',14)
title('All Data', 'FontSize',16)

%%
idx = Results.Cluster == 1;
Cluster_1 = Results(idx,:);

%%
idx = Results.Cluster == 2;
Cluster_2 = Results(idx,:);
%% RE_Linear_Regression
% We will use a Linear Model to describe the process to get 2 cluster
% Author: Rodrigo Gutierrez, MD, PhD

clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

T = readtable("EEG_Results.csv");
Subjects = [1,2,3,6,7,9,11,12,13,15,16,17,18,19,20,21,22,24]; % Subj 5 has only 2 sessions
%% Plot individual fit models
grayColor = [.7 .7 .7];

for k=1:length(Subjects)
    idx = Subjects(k);
    idx_subject = T.Sujeto == idx;
    individual_Tbl = T(idx_subject,:);
    mdl_alpha = fitlm(individual_Tbl.Sesi_n,individual_Tbl.alphaRP);
    txt = ['Subject ', num2str(idx)];
    plot(individual_Tbl.Sesi_n,mdl_alpha.Fitted,'Color',grayColor,'LineWidth',2,'DisplayName',txt)
    xlabel ('Sessions', 'FontSize',13,'FontName','Arial')
    ylabel ('Alpha Relative Power','FontSize',13,'FontName','Arial')
    xlim tight
    hold on
    if k==length(Subjects)
%         legend show
        title('Individual linear model fit ','FontSize',14)
    end
 end
%% To divide by "slope" cluster
% We divede using Cluster information derived from the GMM
idx_cluster = T.Cluster == 1;       % Select Cluster 1 (negative slope)
T_c1 = T(idx_cluster,:);
c1_alpha = fitlm(T_c1.Sesi_n,T_c1.alphaRP);

idx_cluster = T.Cluster == 2;       % Select Cluster 1 (negative slope)
T_c2 = T(idx_cluster,:);
c2_alpha = fitlm(T_c2.Sesi_n,T_c2.alphaRP);

%% Plot both clusters in separate LM
fig = figure();
c1 = plot(c1_alpha,'Marker','.','DisplayName','Cluster 1');
dataHandle = findobj(c1,'DisplayName','Data');
fitHandle = findobj(c1,'DisplayName','Fit');
cbHandles = findobj(c1,'DisplayName','Confidence bounds');
cbHandles = findobj(c1,'LineStyle',cbHandles.LineStyle, 'Color', cbHandles.Color);
dataHandle.Color = [0 0.4470 0.7410]; 
fitHandle.Color = [0 0.4470 0.7410]; %blue
fitHandle.LineWidth = 2; 
set(cbHandles, 'Color', [0 0.4470 0.7410], 'LineWidth', 2)

hold on
c2 = plot(c2_alpha,'Marker','.','DisplayName','Cluster 2');
dataHandle = findobj(c2,'DisplayName','Data');
fitHandle = findobj(c2,'DisplayName','Fit');
cbHandles = findobj(c2,'DisplayName','Confidence bounds');
cbHandles = findobj(c2,'LineStyle',cbHandles.LineStyle, 'Color', cbHandles.Color);
dataHandle.Color = [0.8500 0.3250 0.0980]; 
fitHandle.Color = [0.8500 0.3250 0.0980]; %orange
fitHandle.LineWidth = 2; 
set(cbHandles, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2)

xlabel ('Sessions', 'FontSize',13,'FontName','Arial')
ylabel ('Alpha Relative Power','FontSize',13,'FontName','Arial')
title('Clusters linear models fit ','FontSize',14)
str_1 = 'Cluster 1';
str_2 = 'Cluster 2';
text(30,0.37,str_1,'Color',[0 0.4470 0.7410],'FontSize',14,'FontWeight','bold')
text(30,0.34,str_2,'Color',[0.8500 0.3250 0.0980],'FontSize',14,'FontWeight','bold')
legend off
hold off
%% 
% to extract only CNS patients
idx_CNS = T.CNS == 1; % To select and filter CNS patients
idx_No_CNS = T.CNS == 0; % To select and filter CNS patients

% newTbl = T(idx_CNS,:); % For CNS patients
newTbl = T(idx_No_CNS,:);

%% LINEAR REGRESSION MODEL (Try specific variables in data input)
Data_Input = T.alphaRP;
mdl = fitlm(T.Sesi_n,Data_Input);
plot(mdl)
hold on
ylabel('Alpha Relative Power', 'FontSize',14)
xlabel('Sessions', 'FontSize',14)
title('All Subjects', 'FontSize',16)
p_value = mdl.Coefficients.pValue(2);
p_value = ['p = ' num2str(p_value)];
text(5,0.4,p_value,"FontSize",12)
hold off

%% Linear Model for Alpha Relative Power
mdl_alpha = fitlm(T.Sesi_n,T.alphaRP,'linear');
c2 = plot(mdl_alpha,'Marker','.');
hold on
ylabel('Alpha Relative Power', 'FontSize',14)
xlabel('Sessions', 'FontSize',14)
title('All patients', 'FontSize',16)
p_value = mdl_alpha.Coefficients.pValue(2);
p_value = ['p = ' num2str(p_value)];
text(27,0.4,p_value,"FontSize",12)
hold off

dataHandle = findobj(c2,'DisplayName','Data');
fitHandle = findobj(c2,'DisplayName','Fit');
cbHandles = findobj(c2,'DisplayName','Confidence bounds');
cbHandles = findobj(c2,'LineStyle',cbHandles.LineStyle, 'Color', cbHandles.Color);
dataHandle.Color = [0 0 0]; 
fitHandle.Color = [0 0 0]; %black
fitHandle.LineWidth = 2; 
set(cbHandles, 'Color', [0 0 0], 'LineWidth', 2)

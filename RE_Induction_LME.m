%% RE_Induction_LME
% We will use a Linear Mixed Effect Model
% The model will have as response the Results variable (Induction Time); as Fixed effect the Nº of Sessions; and then a series of random
% effect (CNS, Subject, Cluster)
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
cd '/Users/rodrigo/Codes/Repeated_Exposure';

T = readtable("Results_Induction_Time.csv");      % CV for each band relative power

%% 
% Make N by 2 matrix of fieldname + value type
variable_names_types = [["id", "double"]; ...
			["Coefficient", "double"]; ...
			["SE", "double"]; ...
			["tStat", "double"]; ...
			["pValue", "double"]; ...
			["R2", "double"]];
% Make table using fieldnames & value types from above
my_table = table('Size',[0,size(variable_names_types,1)],... 
	'VariableNames', variable_names_types(:,1),...
	'VariableTypes', variable_names_types(:,2));

%%
Subjects = [3,5,6,9,11,12,13,15,16,17,18,19,20,21,22,24];
Paper_ID = [2,3,4,6,7,8,9,10,11,12,13,14,15,16,17,18];
ColorSet = varycolor(length(Subjects));


for k=1:length(Subjects)
    idx = Subjects(k);
    idx_subject = T.Subject == idx;
    individual_Tbl = T(idx_subject,2:end);
    mdl_indtime = fitlm(individual_Tbl.Session,individual_Tbl.InductionTime);
    my_table(k,1) = array2table(Subjects(k));
    my_table(k,2:5) = mdl_indtime.Coefficients(2,:);
    my_table(k,6) = array2table(mdl_indtime.Rsquared.Adjusted);
    txt = ['Subject ', num2str(Paper_ID(k))];
    subplot(2,1,1)
    plot(individual_Tbl.Session,mdl_indtime.Fitted,'LineWidth',2,'Color',ColorSet(k,:),'DisplayName',txt)
    xlabel ('Sessions', 'FontSize',13,'FontName','Arial')
    ylabel ('Induction Time (s)','FontSize',13,'FontName','Arial')
    ylim([0 500])
    xlim tight
    hold on
    if k==length(Subjects)
        legend show
        title('Individual linear model fit ','FontSize',14)
    end
 end

%
mdl = fitlm(T.Session,T.InductionTime);
mdl;
subplot(2,1,2)
plot(mdl)
c1 = plot(mdl,'Marker','.','MarkerSize',10,'DisplayName','Cluster 1');
dataHandle = findobj(c1,'DisplayName','Data');
fitHandle = findobj(c1,'DisplayName','Fit');
cbHandles = findobj(c1,'DisplayName','Confidence bounds');
cbHandles = findobj(c1,'LineStyle',cbHandles.LineStyle, 'Color', cbHandles.Color);
dataHandle.Color = [0 0.4470 0.7410]; 
fitHandle.Color = [1 0 0]; %blue
fitHandle.LineWidth = 2; 
ylabel ('Induction Time (s)','FontSize',13,'FontName','Arial')
xlabel ('Sessions','FontSize',13,'FontName','Arial')
ylim([0 500])
set(cbHandles, 'Color', [0 0.4470 0.7410], 'LineWidth', 2)
%%
formula_1 = 'InductionTime~1+Session+(1+Session|Subject)+(Session|Anesthetist)';
formula_2 = 'InductionTime~1+Session+(1|Subject)+(Session|Anesthetist)';
formula_3 = 'InductionTime~1+Session+(1|Subject)';
formula_4 = 'InductionTime~1+Session+(1|Subject)+(Session|CNS)';
lme_1 = fitlme(T,formula_1)
lme_1.Rsquared
% lme_2 = fitlme(T,formula_2);
% lme_3 = fitlme(T,formula_3);
% lme_4 = fitlme(T,formula_4);
%% Fit a linear mixed-effect model for EEG features (MODEL #1)
% 
% formula_alpha = 'alphaRP_CV~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)';
% lme_alpha = fitlme(T,formula_alpha)

% formula_delta = 'deltaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_delta = fitlme(T,formula_delta)

% formula_theta = 'thetaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_theta = fitlme(T,formula_theta)

% formula_beta = 'betaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_beta = fitlme(T,formula_beta)


%%  Fit a linear mixed-effect model for EEG features (MODEL #2)
% Now we include cluster information
% formula_alpha = 'alphaRP_CV~Sesi_n+(1+Sesi_n|Sujeto)+(1|CNS)+(1|Cluster)';
% lme_alpha = fitlme(T,formula_alpha)
% 
% formula_delta = 'deltaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_delta = fitlme(T,formula_delta)

% formula_theta = 'thetaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
% lme_theta = fitlme(T,formula_theta)

formula_beta = 'betaRP_CV~Sesi_n+(Sesi_n|Sujeto)+(1|CNS)';
lme_beta = fitlme(T,formula_beta)

%% RE_Individual_lm
% We will use a Linear Model to describe the process to get 2 cluster
% Author: Rodrigo Gutierrez, MD, PhD

clear variables; clc;
addpath(genpath('/Users/rodrigo/MATLAB_Repository/Repeated_Exposure'));
cd '/Users/rodrigo/MATLAB_Repository/Repeated_Exposure';

T = readtable("Results_EEG.csv");
Subjects = [1,2,3,6,7,9,11,12,13,15,16,17,18,19,20,21,22,24]; % Subj 5 has only 2 sessions

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
for k=1:length(Subjects)
    idx = Subjects(k);
    idx_subject = T.Sujeto == idx;
    individual_Tbl = T(idx_subject,:);
    mdl_alpha = fitlm(individual_Tbl.Sesi_n,individual_Tbl.alphaRP);
    my_table(k,1) = array2table(Subjects(k));
    my_table(k,2:5) = mdl_alpha.Coefficients(2,:);
    my_table(k,6) = array2table(mdl_alpha.Rsquared.Adjusted);
 end
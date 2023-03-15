%% RE_EM_GMM
% We will use a Cluster Gaussian Mixture Data using Hard Clustering
% Author: Rodrigo Gutierrez, MD, PhD
clear variables; clc;
addpath(genpath('/Users/rodrigo/Codes/Repeated_Exposure'));
cd '/Users/rodrigo/Codes/Repeated_Exposure';

T = readtable("Results_Slopes.csv");
Slopes = T.Slope;
%%

options = statset('Display','final'); 
gm = fitgmdist(Slopes,2,'Options',options)

%%
idx = cluster(gm,Slopes);
cluster1 = (idx == 1); % |1| for cluster 1 membership
cluster2 = (idx == 2); % |2| for cluster 2 membership
%%
select_row_c1 = T.Cluster == 1;
select_row_c2 = T.Cluster == 2;

T_Cluster1 = T(select_row_c1,:);
T_Cluster2 = T(select_row_c2,:);
%% PLOT RESULTS

    x = linspace(-0.018,0.005,500);
    y_1 = normpdf(x,gm.mu(1),50*gm.Sigma(:,:,1));
    y_2 = normpdf(x,gm.mu(2),50*gm.Sigma(:,:,2));
    p1 = plot(x,(y_1/sum(y_1)),'LineWidth',2, 'Color','#0072BD');
    hold on
    p2 = plot(x,(y_2/sum(y_2)),'LineWidth',2, 'Color','#D95319');
   
    Slopes_c1 = Slopes(Slopes<-0.01);
    Slopes_c2 = Slopes(Slopes>-0.01);
    ax_index_c1 = repelem(0.001,length(Slopes_c1));
    ax_index_c2 = repelem(0.001,length(Slopes_c2));
    plot(Slopes_c1,ax_index_c1,'o','MarkerFaceColor','#D95319','MarkerSize',9)
    plot(Slopes_c2,ax_index_c2,'o','MarkerFaceColor','#0072BD','MarkerSize',9)

    legend([p1 p2],{'Cluster 1';'Cluster 2'},'FontSize',12)
    xlabel('Slopes','FontSize',13,'FontName','Arial')
    ylabel('Density','FontSize',13,'FontName','Arial')
    ylim ([0.001 0.50])
    title('log-likelihood predicted by a Gaussian Mixture Model','FontSize',14)




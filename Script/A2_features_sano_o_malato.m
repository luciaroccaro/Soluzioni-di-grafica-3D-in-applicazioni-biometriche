% script in cui selezioniamo n features per il Classificatore e le
% visualizziamo nello spazio in n dimensioni -> verifichiamo che un
% classificatore SVM sia implementabile

close all
clear variables
clc

addpath('Funzioni e WS','Ecografie')

% inizializziamo i vettori che conterranno i valori delle variabili
soglia_C = [];
soglia_e = [];
somma_e = [];

for i = 1:18
    if i<10
        type_subject = "lp"; % malati
        ID{i} = sprintf('0%d %s',i,type_subject);
    else
        type_subject = "s"; % sani
        ID{i} = sprintf('%d %s',i,type_subject);
    end
    
    % load delle depth
    file = sprintf('Ecografie/Dataset/%d_%s.mat',i,type_subject);
    load(file)
    clear file % pulizia delle variabili che non servono

    [X,Y] = saveXY(Z);
    [soglia_C(i),soglia_e(i),somma_e(i)] = variabili_SVM(X,Y,Z,"ON",ID{i});
  
    pause
    close all
    
end

features_SVM = [soglia_C' soglia_e' somma_e'];
% Salviamo la variabile features_SVM nel workspace chiamato 'features_SVM.mat'

%% visualizzazione features
figure
% Cmax
subplot (2,1,1)
bar(categorical(ID),soglia_C)
xlabel("feto")
ylabel("valore di C_{max}")
title('C_{max}')
% emax
subplot (2,1,2)
bar(categorical(ID),soglia_e)
xlabel("feto")
ylabel("valore di e_{max}")
title('e_{max}')
% somma e
figure
plot(categorical(ID),somma_e)
title('somma e')
xlabel("feto")
ylabel("valore della somma")

%% visualizzazione in 3D per SVM
figure 
% malati
scatter3(features_SVM(1:9,1),features_SVM(1:9,2),features_SVM(1:9,3),100,'MarkerEdgeColor','k','MarkerFaceColor','r'); 
hold on
% sani
scatter3(features_SVM(10:end,1),features_SVM(10:end,2),features_SVM(10:end,3),100,'MarkerEdgeColor','k','MarkerFaceColor','g');
xlabel('C_{max}')
ylabel('e_{max}')
zlabel('e_{tot}')
legend('Malati','Sani')
title('Visualizzazione dei dati in 3D')
hold off
% script in cui creiamo 18 classificatori diversi, allenandoli tramite 
% leave-one-out, e ne confrontiamo le prestazioni

close all
clear variables
clc

addpath('Funzioni e WS','Ecografie')

%% load delle features di tutti i feti e inizializzazioni
load('features_SVM.mat')
true_class = [];
for i = 1:18
    if i<10
        true_class = [true_class "M"];
    else
        true_class = [true_class "S"];
    end
    
end

Mdl = struct();
CM = zeros(2,2);

%% leave one out: trs composto da tutti gli elementi tranne il k-esimo
fprintf('LEAVE ONE OUT\n')
for k = 1:18
    fprintf ('iterazione %d: ', k)
    features_trs = [];
    true_class_trs = [];
    
    features_val_set = features_SVM(k,:);
    true_class_val_set = true_class(k);
    for i = 1:18
        if i ~= k
            features_trs = [features_trs; features_SVM(i,:)];
            true_class_trs = [true_class_trs; true_class(i)];
        end
    end
    Mdl(k).classificatore = fitcsvm(array2table(features_trs),true_class_trs);
    predicted_class(k) = predict(Mdl(k).classificatore,features_val_set);
    if predicted_class(k) == true_class_val_set
        fprintf('classificazione corretta\n')
    else
        fprintf('classificazione ERRATA:\n\t%s classificato come %s\n',true_class_val_set,predicted_class{k})
    end
    
end

% Salviamo Mdl nel workspace chiamato 'Classificatore_SVM.mat'


%% creazione della Confusion Matrix
CM = confusionmat(true_class,predicted_class);
figure
confusionchart(CM,["Malati","Sani"])
title('Confusion Matrix Test Set - Leave one Out')


% Ogni classificatore ottenuto con il leave-one-out dà origine ad una 
% Confusion Matrix. Le 18 confusion matrix ottenute sui 18 Test Set (ognuno
% composto dall'elemento escluso dal TRS) vengono poi unificate per 
% ottenere un'unica Confusion Matrix del Test Set.
% L’ipotesi per cui le CM possono essere unificate è che si ipotizza che 
% i k classificatori ottenuti non siano così diversi tra loro.

% commento: notiamo che l'unica iterazione in cui il classificatore
% sbaglia, è in ognuno dei 3 casi esaminati (leave-one-out e 2 k-fold) 
% quella in cui il feto numero 9 non fa parte del training set.

%% altre prove: K-fold
% k-fold: trs composto da tutti gli elementi tranne il k-esimo e il (k+9-esimo)
% fprintf('\nK-FOLD con cluster da 2 elementi - k e k+9\n')
% for k = 1:9
%     fprintf ('iterazione %d: ', k)
%     features_trs = [];
%     true_class_trs = [];
%     
%     features_val_set = [features_SVM(k,:); features_SVM(k+9,:)];
%     true_class_val_set = [true_class(k); true_class(k+9)];
%     for i = 1:18
%         if i ~= k && i ~= k+9 
%             features_trs = [features_trs; features_SVM(i,:)];
%             true_class_trs = [true_class_trs; true_class(i)];
%         end
%     end
%     Mdl = fitcsvm(array2table(features_trs),true_class_trs);
%     predicted_class = predict(Mdl,features_val_set);
%     if predicted_class == true_class_val_set
%         fprintf('classificazione corretta\n')
%     else
%         fprintf('classificazione ERRATA:\n\t%s classificato come %s',true_class_val_set(1),predicted_class{1})
%         fprintf('\n\t%s classificato come %s\n',true_class_val_set(2),predicted_class{2})
%     end
% end


% % k-fold: trs composto da tutti gli elementi tranne il k-esimo, il k+6-esimo e il k+12-esimo
% fprintf('\nK-FOLD con cluster da 3 elementi - k, k+6 e k+12\n')
% for k = 1:6
%     fprintf ('iterazione %d: ', k)
%     features_trs = [];
%     true_class_trs = [];
%     
%     features_val_set = [features_SVM(k,:); features_SVM(k+6,:); features_SVM(k+12,:)];
%     true_class_val_set = [true_class(k);true_class(k+6);true_class(k+12)];
%     for i = 1:18
%         if i ~= k && i ~= k+6 && i ~= k+12
%             features_trs = [features_trs; features_SVM(i,:)];
%             true_class_trs = [true_class_trs; true_class(i)];
%         end
%     end
%     Mdl = fitcsvm(array2table(features_trs),true_class_trs);
%     predicted_class = predict(Mdl,features_val_set);
%     if predicted_class == true_class_val_set
%         fprintf('classificazione corretta\n')
%     else
%         fprintf('classificazione ERRATA:\n\t%s classificato come %s\n',true_class_val_set(1),predicted_class{1})
%         fprintf('\t%s classificato come %s\n',true_class_val_set(2),predicted_class{2})
%         fprintf('\t%s classificato come %s\n',true_class_val_set(3),predicted_class{3})
%     end
%     
% end

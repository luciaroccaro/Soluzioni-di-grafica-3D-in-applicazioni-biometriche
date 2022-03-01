% Dopo aver creato i nostri classificatori, lo utilizziamo per 
% classificare tutti i feti. Per i malati discriminiamo tra uni e 
% bilaterale

close all
clear variables
clc

addpath('Funzioni e WS','Ecografie')

load('classificatore_SVM.mat')
peaks = struct();
true_class = [];

for i = 1:18
    if i < 10
        type_subject = "lp"; % malati
        if (i == 3 || i == 4 || i == 6)
            true_class = [true_class "MB"];
        elseif (i == 7 || i == 9) 
            true_class = [true_class "MUdx"];
        else
            true_class = [true_class "MUsx"];
        end
    else
        type_subject = "s"; % sani
        true_class = [true_class "S"];
    end
    
    % load delle depth
    file = sprintf('Ecografie/Dataset/%d_%s.mat',i,type_subject);
    load(file)
    clear file % pulizia delle variabili che non servono

    [X,Y] = saveXY(Z);
    
    % calcolo delle variabili per il primo classficatore: SVM
    [soglia_C(i),soglia_e(i),somma_e(i)] = variabili_SVM(X,Y,Z,"OFF");
    features_SVM(i,:) = [soglia_C(i) soglia_e(i) somma_e(i)];
    
    % per classificare gli elementi usiamo uno dei 17 classificatori che
    % non commettono errori (ovvero uno qualsiasi ad eccezione del nono)
    % decidiamo quindi di utilizzare il classificatore SVM numero 1
    predicted_class(i) = predict(Mdl(1).classificatore,features_SVM(i,:));
    
    % se il feto è malato
    if predicted_class(i) == "M"
        fprintf ("Il feto %d presenta CL ",i)
        
        % calcolo delle variabili per il secondo classficatore: sogliatura
        [peaks,Z_s] = variabili_uni_bi(X,Y,Z,i,peaks,"OFF");

        % se ha 2 minimi è bilaterale
        if length(peaks(i).min_amount) == 2
            fprintf ("bilaterale.\n")
            predicted_class{i} = 'MB';
        else % se ha 1 minimo è unilaterale
            predicted_class{i} = 'MU';
            if peaks(i).posmin > ceil(size(Z_s,2)/2) 
                fprintf ("unilaterale sinistro.\n")
                predicted_class{i} = 'MUsx';
            elseif peaks(i).posmin < ceil(size(Z_s,2)/2)
                fprintf ("unilaterale destro.\n")
                predicted_class{i} = 'MUdx';
            else % se il minimo coincide con il prn -> unilaterale centrale
                predicted_class{i} = 'MU_unknown';
            end
        end
    else % se il feto è sano
        fprintf("Il feto %d è sano.\n",i)
    end
end

%% confusion matrix
CM_Dataset = confusionmat(true_class,predicted_class);
figure
confusionchart(CM_Dataset,["Malati - Unilaterale SX","Malati - Bilaterale","Malati - Unilaterale DX","Sani"])
title('Confusion Matrix - Primo (1) e Secondo Classificatore - Dataset')

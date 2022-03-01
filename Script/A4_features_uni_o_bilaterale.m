% in questo script si cerca un parametro per discriminare tra il caso di CL
% unilaterale e quello bilaterale

clear variables
close all
clc

addpath('Funzioni e WS','Ecografie')

figure
legend_mal = [];
legend_mal_bilaterale = [];
legend_mal_unilaterale = [];
legend_ben = [];
peaks = struct();

count_ben = 0;
count_mal_bi = 0;
count_mal_uni = 0;

% estraiamo per il Training set un feto per ogni tipologia di CL 
% (unilaterale dx e sx, bilaterale) e un feto sano
TRS = [1,3,9,15];
count = 0;
for i = TRS

count = count+1;

if i<10
    type_subject = "lp"; % malati
    ID{count} = sprintf('0%d %s',i,type_subject);
else
    type_subject = "s"; % sani
    ID{count} = sprintf('%d %s',i,type_subject);
end

% load delle depth
file = sprintf('Ecografie/Dataset/%d_%s.mat',i,type_subject);
load(file)
clear path file % pulizia delle variabili che non servono

[X,Y] = saveXY(Z);

% calcolo delle features
[peaks,Z_s,Z_sum_x,delta_col] = variabili_uni_bi(X,Y,Z,count,peaks,"ON",ID);

% plottiamo discriminando tra maligni uni/bilaterali e benigni
% creazione dell'asse x rispetto alla posizione del pronasale
asse_x_plot = linspace(-fix(delta_col/2),fix(delta_col/2),delta_col+1);
if type_subject == "lp"
    
    if i == 3 % CL bilaterale
    legend_mal_bilaterale = [legend_mal_bilaterale; ID{count}];
    count_mal_bi = count_mal_bi+1;
    figure (2)
    subplot(1,3,1)
    mal_bi(count_mal_bi) = plot(asse_x_plot, Z_sum_x);
    title ('somma ROI per colonne - Malato bilaterale')
    xlabel ('posizione rispetto al prn')
    ylabel ('valore della somma')
    hold on
    plot(asse_x_plot(peaks(count).posmax), peaks(count).max_amount, '.r')
    plot(asse_x_plot(peaks(count).posmin), peaks(count).min_amount, '.k')
    ylim([0 20]) % specifico limiti asse y
    % plotto l'asse centrale x = 0 (posizione prn)
    plot([0, 0], [min(ylim), max(ylim)], 'k:', 'LineWidth', 0.1);
    % inserimento della legenda
    legend (mal_bi, legend_mal_bilaterale, 'Location','southeast')

    
    else % CL unilaterale
    legend_mal_unilaterale = [legend_mal_unilaterale; ID{count}];
    count_mal_uni = count_mal_uni+1;
    figure (2)
    subplot(1,3,2)
    title ('somma ROI per colonne - Malato unilaterale')
    mal_uni(count_mal_uni) = plot(asse_x_plot, Z_sum_x);
    legend (legend_mal_unilaterale, 'Location','southeast')
    xlabel ('posizione rispetto al prn')
    ylabel ('valore della somma')
    hold on
    plot(asse_x_plot(peaks(count).posmax), peaks(count).max_amount, '.r')
    plot(asse_x_plot(peaks(count).posmin), peaks(count).min_amount, '.k')
    if i == 9
        ylim([0 20]) % specifico limiti asse y
        % plotto l'asse centrale x = 0 (posizione prn)
        plot([0, 0], [min(ylim), max(ylim)], 'k:', 'LineWidth', 0.1);
        % inserimento della legenda
        legend (mal_uni, legend_mal_unilaterale, 'Location','southeast')
    end
    
    end
end

if type_subject == "s" % sani
    legend_ben = [legend_ben; ID{count}];
    count_ben = count_ben+1;
    figure (2)
    subplot(1,3,3)
    ben(count_ben) = plot(asse_x_plot, Z_sum_x);
    hold on
    xlabel ('posizione rispetto al prn')
    ylabel ('valore della somma')
    title ('somma ROI per colonne - Sano')
    plot(asse_x_plot(peaks(count).posmax), peaks(count).max_amount, '.r')
    plot(asse_x_plot(peaks(count).posmin), peaks(count).min_amount, '.g')
    ylim([0 20]) % specifico limiti asse y
    % plotto l'asse centrale x = 0 (posizione prn)
    plot([0, 0], [min(ylim), max(ylim)], 'k:', 'LineWidth', 0.1);
    % inserimento della legenda
    legend (ben, legend_ben, 'Location','southeast')

end
end

hold off

% da questi grafici si nota la differenza tra i maligni uni e bilaterali:
% effettuando una somma per colonne della sottomatrice Z_s contenente la
% zona del labbro superiore, si trovano dei valori di minimo in
% corrispondenza dei tagli nel labbro. contando i punti di minimo e massimo
% relativi quindi si può distinguere tra labbro leporino uni e bilaterale.

% da qui ricaviamo la nostra condizione: se nella sottomatrice troviamo 2
% minimi, il feto è affetto da labbro leporino bilaterale, altrimenti è 
% unilaterale. In caso unilaterale identifichiamo il lato grazie alla 
% posizione del minimo rispetto a quella del pronasale (centro della 
% sottomatrice).

% Effettuiamo questo controllo solamente in caso il classificatore abbia 
% classificato il feto come malato.
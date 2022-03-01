function [peaks,Z_s,Z_sum_x,delta_col] = variabili_uni_bi(X,Y,Z,count,peaks,plot_parameter,ID)

%% individuazione della sottomatrice contenente la zona di ricerca del CL
% ricerca automatica del pronasale
[prn,x_prn,y_prn] = find_prn(Z);

% le righe sono la y, le colonne sono la x
% abbassiamo il rettangolo rispetto al prn per eliminare il contributo 
% del naso da questa analisi
riga_i = y_prn-ceil(0.15*y_prn); 
col_i = x_prn;

delta_righe = fix(size(Y,2)/7.5);
delta_col = fix(size(X,1)/3.5);

% plot dell'area esaminata solo se plot_parameter = 'ON'
if plot_parameter == "ON"
    
    figure (1)
    subplot(2,2,count)
    surface(X,Y,Z)
    shading interp % commentare per visualizzare la griglia nera
    title(['Depth Map con ROI - feto ',ID{count}])
    hold on
    x = [riga_i, (riga_i-delta_righe), (riga_i-delta_righe), riga_i, riga_i];
    y = [col_i-fix(delta_col/2), col_i-fix(delta_col/2), col_i+fix(delta_col/2), col_i+fix(delta_col/2), col_i-fix(delta_col/2)];
    for k = 1:length(x)-1
        plot3([y(k),y(k+1)],[x(k),x(k+1)], [prn,prn], 'b-', 'LineWidth', 2);
    end
    xlabel('asse X')
    ylabel('asse Y')  
    zlabel('asse Z')
    legend('','ROI','','')
    hold off

end

%% isolamento della sottomatrice e valutazione
% Z_s è la sottomatrice che esaminiamo
Z_s = Z(riga_i-delta_righe:riga_i,col_i-fix(delta_col/2):col_i+fix(delta_col/2));
% normalizziamo con min-max scaling per poter confrontare i valori dei
% diversi feti
Z_s = (Z_s - min(min(Z_s)))/(max(max(Z_s))-min(min(Z_s)));

% somma per colonne
Z_sum_x = sum(Z_s);

% smooth per renderla meno spigolosa
for k = 2:length(Z_sum_x)-1
    Z_sum_x(k) = mean(Z_sum_x(k-1:k+1));
end

% cerchiamo minimi e massimi. inseriamo il parametro di prominenza per 
% evitare di riconoscere i picchi non troppo pronunciati -> falsi max e min
[peaks(count).max_amount, peaks(count).posmax] = findpeaks(Z_sum_x,'MinPeakProminence',0.15);
[peaks(count).min_amount, peaks(count).posmin] = findpeaks(-Z_sum_x,'MinPeakProminence',0.15);

% riporto i minimi nella posizione giusta
peaks(count).min_amount = -peaks(count).min_amount;

end
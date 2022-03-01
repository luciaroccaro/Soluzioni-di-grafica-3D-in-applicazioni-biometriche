function [soglia_C,soglia_e,somma_e] = variabili_SVM(X,Y,Z,plot_parameter,ID)
% funzione che calcola e restituisce le variabili che utilizziamo per il
% classificatore

% variabili in ingresso:
%   - matrici X,Y,Z
%   - parametro 'ID': identificativo del feto in esame

[e,C] = geometricaldescriptors(Z);

%% individuazione del rettangolo contenente la zona di ricerca del CL

% ricerca automatica del pronasale
[prn,x_prn,y_prn] = find_prn(Z);

% le righe sono la y, le colonne sono la x
riga_i = y_prn;
col_i = x_prn;

delta_righe = fix(size(Y,2)/5);
delta_col = fix(size(X,1)/4);

%% calcolo dei punti di interesse -> Cmax ed emax

% CURVEDNESS: trovo il punto di massimo
C_s = C(riga_i-delta_righe:riga_i,col_i-fix(delta_col/2):col_i+fix(delta_col/2));
Cmax = (max(max(C_s)));
[xC_find,yC_find] = find(C == Cmax);
xCmax = X(xC_find,yC_find);
yCmax = Y(xC_find,yC_find);
% plot della sottomatrice
% if plot_parameter == "ON"
% figure(2)
% surf(C_s), colorbar
% xlabel('asse X')
% ylabel('asse Y')  
% zlabel('C')
% title (['C_s ',ID])
% end

soglia_C = Cmax;

% plot del massimo sulla C
% if plot_parameter == "ON"
% figure
% surface(X,Y,C), colorbar
% xlabel('asse X')
% ylabel('asse Y')  
% zlabel('C')
% title('Cmax su Z_{s}')
% hold on 
% plot3(xCmax,yCmax,Cmax,'r.', 'markers', 30)
% end

% COEFFICIENTE e: trovo il punto di massimo
e_s = e(riga_i-delta_righe:riga_i,col_i-fix(delta_col/2):col_i+fix(delta_col/2));
emax = (max(max(e_s)));
[xe_find,ye_find] = find(e == emax);
xemax = X(xe_find,ye_find);
yemax = Y(xe_find,ye_find);
% plot della sottomatrice
% if plot_parameter == "ON"
% figure
% surf(e_s), colorbar
% xlabel('asse X')
% ylabel('asse Y')  
% zlabel('e')
% title (['e_s ',ID])
% end

soglia_e = emax;

% plot del massimo sulla e
% if plot_parameter == "ON"
% figure
% surface(X,Y,e), colorbar
% xlabel('asse X')
% ylabel('asse Y')  
% zlabel('e')
% title('e')
% hold on 
% plot3(xemax,yemax,emax,'r.', 'markers', 30)
% end

%% plot dei punti di massimo sulla Depth Map
if plot_parameter == "ON"
    figure (1)
    surface(X,Y,Z)
    shading interp % commentare per visualizzare la griglia nera
    title(['Depth Map con Descrittori - feto ',ID])
    hold on
    plot3(xCmax,yCmax,Z(xC_find,yC_find),'r.', 'markers', 50)
    plot3(xemax,yemax,Z(xe_find,ye_find),'g.', 'markers', 30)
    x = [riga_i, (riga_i-delta_righe), (riga_i-delta_righe), riga_i, riga_i];
    y = [col_i-fix(delta_col/2), col_i-fix(delta_col/2), col_i+fix(delta_col/2), col_i+fix(delta_col/2), col_i-fix(delta_col/2)];
    for i = 1:length(x)-1
        plot3([y(i),y(i+1)],[x(i),x(i+1)], [prn,prn], 'b-', 'LineWidth', 2);
    end
    xlabel('asse X')
    ylabel('asse Y')  
    zlabel('asse Z')
    legend('','C_{max}','e_{max}','ROI','','')
    hold off
end
%% somma dei valori positivi di e nella sottomatrice e_s
somma_e = sum(sum(e_s(e_s > 0)));

end
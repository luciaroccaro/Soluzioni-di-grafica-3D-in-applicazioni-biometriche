function [prn,x_prn,y_prn] = find_prn(Z)
% funzione per il calcolo automatico del pronasale

prn1 = max(max(Z));
[riga_prn1,col_prn1] = find(Z == prn1);
% isoliamo una matrice d'appoggio in cui eliminiamo il massimo e il suo
% intorno. da questa matrice cerchiamo un secondo massimo
delta = 2;
Z_app = Z;
for i = riga_prn1-delta:riga_prn1+delta
    for j = col_prn1-delta:col_prn1+delta
        Z_app(i,j) = NaN;
    end
end

prn2 = max(max(Z_app));
[riga_prn2,col_prn2] = find(Z==prn2);

eucdist_prn = sqrt((col_prn1-col_prn2)^2+(riga_prn1-riga_prn2)^2);
soglia_verticale = fix(size(Z,1)/10);
% se il naso è dritto, nel caso peggiore si trova il secondo massimo ad una
% distanza euclidea pari a sqrt(2*(delta+1)^2). Se la distanza è maggiore, 
% significa che ci sono due massimi relativi per il naso -> prendiamo il 
% punto medio tra i due massmi relativi per identificare il pronasale

% imponiamo anche una soglia di discostamento verticale massimo tra i due
% punti individuati, oltre la quale è irragionevole pensare che si tratti
% di un secondo punto sul naso
if eucdist_prn <= sqrt(2*(delta+1)^2) || abs(riga_prn2-riga_prn1) > soglia_verticale
    % il pronasale è il massimo della matrice Z
    prn = prn1;
    x_prn = col_prn1;
    y_prn = riga_prn1;
else 
    % il pronasale è la media tra i due punti
    x_prn = ceil(mean([col_prn1,col_prn2]));
    y_prn = ceil(mean([riga_prn1,riga_prn2]));
    prn = Z(y_prn,x_prn);
end

end
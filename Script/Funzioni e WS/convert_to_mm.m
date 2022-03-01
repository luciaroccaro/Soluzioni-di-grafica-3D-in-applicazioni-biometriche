function dist_mm = convert_to_mm(dist,prn,sl)
% funzione che converte la distanza tra due punti della depth map in mm

% effettuiamo la conversione facendo una proporzione tra la distanza da
% convertire e la distanza pronasale-sublabiale, nota dalla letteratura

% riferimento -> Goldstein I, Tamir A, Weiner Z, Jakobi P. Dimensions of 
% the fetal facial profile in normal pregnancy. Ultrasound Obstet Gynecol. 
% 2010 Feb;35(2):191-4. doi: 10.1002/uog.7441. PMID: 19856329.

% poiché un solo feto (di cui non conosciamo l'ID) è alla 22esima 
% settimana, mentre tutti gli altri sono alla 32esima, scegliamo di 
% utilizzare come riferimento la distanza prn_sl alla 32esima settimana.

GA = 32; % età gestazionale
% dist_mm_a = 0.1*(-37.98 + 7.54*GA);
% dist_mm_d = 0.1*(1.65 + 2.95*GA);
% dist_prn_sl_mm = dist_mm_a + dist_mm_d;

[ma,qa,md,qd] = linear_regression_paper();
dist_mm_a = ma*GA + qa;
dist_mm_d = md*GA + qd;
dist_prn_sl_mm = dist_mm_a + dist_mm_d;

dist_prn_sl = euclideandistance(prn,sl);

% effettuiamo la proporzione
% dist_prn_sl: dist_prn_sl_mm = dist:dist_mm
dist_mm = (dist*dist_prn_sl_mm)/dist_prn_sl;

end
function [ma,qa,md,qd] = linear_regression_paper()

% riferimento -> Goldstein I, Tamir A, Weiner Z, Jakobi P. Dimensions of 
% the fetal facial profile in normal pregnancy. Ultrasound Obstet Gynecol. 
% 2010 Feb;35(2):191-4. doi: 10.1002/uog.7441. PMID: 19856329.

% vettori dei dati su cui fare regressione lineare:
% x = valori medi degli estremi delle fasce di età gestazionale
% y = valore delle distanze medie alle varie fasce

% tabella a -> tip of the nose to mouth (prn-sto)
xa = [(15.4+15), (15.9+15.5), (16.9+16), (18.9+17), (20.9+19), (22.9+21), (23.9+23), (24.9+24), (26.9+25)]/2;
ya = [7.58 8.09 8.26 9.55 10.93 13.05 13.68 14.72 15.74];

% regressione linerare a
a = fitlm(xa,ya);

qa = a.Coefficients.Estimate(1);
ma = a.Coefficients.Estimate(2);

% tabella d -> mouth to upper concavity of chin (sto-sl)
xd = xa;
yd = [4.65 4.50 5.13 5.18 6.09 6.97 7.23 7.15 8.06];

% regressione linerare d
d = fitlm(xd,yd);

qd = d.Coefficients.Estimate(1);
md = d.Coefficients.Estimate(2);

end
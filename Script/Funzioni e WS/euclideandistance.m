function [eucdist] = euclideandistance(pixel_start,pixel_end)
% funzione che calcola la distanza euclidea tra due punti della depth map

% la conversione in mm viene effettuata in seguito, a partire dallo script 
% principale

xI = pixel_start.Position(1);
yI = pixel_start.Position(2);
zI = pixel_start.Position(3);

xF = pixel_end.Position(1);
yF = pixel_end.Position(2);
zF = pixel_end.Position(3);

eucdist = sqrt( (xI - xF)^2 + (yI - yF)^2 + (zI - zF)^2 );

end
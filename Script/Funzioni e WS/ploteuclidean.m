function ploteuclidean(punto_iniziale,punto_finale,color_parameter)

% funzione per plottare le distanze euclidee. i punti in ingresso sono in
% formato struct (ottenuti da 'Export Cursor Data to Workspace')

% CONTROLLO PARAMETRI OPZIONALI
% se non viene inserito il parametro di colore, allora di default esso
% viene impostato come nero

if ~exist('color_parameter','var')
  color_parameter = 'k';
end


% diff = punto_finale-punto_iniziale;
pts = [punto_iniziale.Position; punto_finale.Position];

hold on
plot3(pts(:,1),pts(:,2),pts(:,3),'k-')
line(pts(:,1),pts(:,2),pts(:,3),'Color',color_parameter,'LineWidth',3)
hold off

end


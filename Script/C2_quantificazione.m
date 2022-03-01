% script per quantificare le lesioni

clear variables
close all
clc

addpath('Funzioni e WS','Ecografie')

% consideriamo solamente i soggetti malati
for i = 1:9 
    file = sprintf('Ecografie/Malati con LM/%d_landmark.mat',i);
    load(file)
    clear file % pulizia delle variabili che non servono
    
    [X,Y] = saveXY(Z);
    subplot(3,3,i)
    surface(X,Y,Z)
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('asse Z')
    title(sprintf('Feto %d - Distanze Euclidee',i))
    
    %% calcolo delle distanze e conversione in mm
    if type_lesion == "unisx" || type_lesion == "unidx" % unilaterale
        altezza = euclideandistance(top,bot);
        altezza = convert_to_mm(altezza,prn,sl);
        larghezza = euclideandistance(sx,dx);
        larghezza = convert_to_mm(larghezza,prn,sl);
        
        % plot
        ploteuclidean(top,bot,'r')
        ploteuclidean(sx,dx,'k')
        
    else % bilaterale
        % lesione destra
        altezza_right = euclideandistance(top_right,bot_right);
        larghezza_right = euclideandistance(sx_right,dx_right);
        
        altezza_right = convert_to_mm(altezza_right,prn,sl);
        larghezza_right = convert_to_mm(larghezza_right,prn,sl);
        
        % lesione sinistra
        altezza_left = euclideandistance(top_left,bot_left);
        larghezza_left = euclideandistance(sx_left,dx_left);
        
        altezza_left = convert_to_mm(altezza_left,prn,sl);
        larghezza_left = convert_to_mm(larghezza_left,prn,sl);
        
        % plot
        ploteuclidean(top_right,bot_right,'r')
        ploteuclidean(sx_right,dx_right,'k')
        ploteuclidean(top_left,bot_left,'r')
        ploteuclidean(sx_left,dx_left,'k')
        
    end
    
    % legenda del subplot
    legend('','','Cranio-Caudale','','Trasversale')
    
    %% visualizzazione delle distanze nella Command Window
    if type_lesion == "unidx"
        lato = "destro";
    elseif type_lesion == "unisx"
        lato = "sinistro";
    end
    
    if type_lesion == "unidx" || type_lesion == "unisx" % unilaterale
        fprintf('Il feto %d presenta CL unilaterale %s.\n',i,lato)
        fprintf('Dimensioni del difetto:\n\tLarghezza: %.2f mm\n\tAltezza: %.2f mm\n\n',larghezza,altezza)
    else % bilaterale
        fprintf('Il feto %d presenta CL bilaterale.\n',i)
        fprintf('Dimensioni del difetto sinistro:\n\tLarghezza: %.2f mm\n\tAltezza: %.2f mm\n',larghezza_left,altezza_left)
        fprintf('Dimensioni del difetto destro:\n\tLarghezza: %.2f mm\n\tAltezza: %.2f mm\n\n',larghezza_right,altezza_right)
    end
    
end


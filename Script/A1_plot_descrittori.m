% script che calcola e visualizza i descrittori geometrici per ogni feto

close all
clear variables
clc

addpath('Funzioni e WS','Ecografie')

for i = 1:18
    if i<10
        type_subject = "lp"; % malati
        ID{i} = sprintf('0%d %s',i,type_subject);
    else
        type_subject = "s"; % sani
        ID{i} = sprintf('%d %s',i,type_subject);
    end
    
    % load delle depth
    file = sprintf('Ecografie/Dataset/%d_%s.mat',i,type_subject);
    load(file)
    clear file % pulizia delle variabili che non servono

    [X,Y] = saveXY(Z);
    
    [e,C,K,k1,k2,f,g,H,S] = geometricaldescriptors(Z);

    %% visualizzazione
    figure
    subplot(3,3,1)
    surface(X,Y,K), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('K')
    title(['K feto ' ID{i}])
    
    subplot(3,3,2)
    surface(X,Y,k1), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('k1')
    title(['k1 feto ' ID{i}])

    subplot(3,3,3)       
    surface(X,Y,k2), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y') 
    zlabel('k2')
    title(['k2 feto ' ID{i}])
    
    subplot(3,3,4)
    surface(X,Y,e), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y') 
    zlabel('e')
    title(['e feto ' ID{i}])

    subplot(3,3,5)
    surface(X,Y,f), colorbar 
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('f')
    title(['f feto ' ID{i}])

    subplot(3,3,6)
    surface(X,Y,g), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('g')
    title(['g feto ' ID{i}])
    
    subplot(3,3,7)
    surface(X,Y,H), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')   
    zlabel('H')
    title(['H feto ' ID{i}])

    subplot(3,3,8)
    surface(X,Y,S), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')  
    zlabel('S')
    title(['S feto ' ID{i}])

    subplot(3,3,9)
    surface(X,Y,C), colorbar
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')  
    zlabel('C')
    title(['C feto ' ID{i}])
    
    pause
    close all
    
end
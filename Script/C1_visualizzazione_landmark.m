% script per visualizzare i landmark posizionati a mano su ogni feto malato

clear variables
close all
clc

addpath('Funzioni e WS','Ecografie')

for i = 1:9 % apriamo a turno tutti i soggetti aventi labbro leporino
    file = sprintf('Ecografie/Malati con LM/%d_landmark.mat',i);
    load(file)
    clear path file % pulizia delle variabili che non servono
    [X,Y] = saveXY(Z);
    
    % plot del pronasale e del sublabiale
    subplot(3,3,i)
    surface(X,Y,Z)
    shading interp % commentare per visualizzare la griglia nera
    xlabel('asse X')
    ylabel('asse Y')
    zlabel('asse Z')
    hold on
    % pronasale e sublabiale
    plot_landmark(sl, '.c')
    plot_landmark(prn, '.k')
    
    % landmark sulle lesioni
    if type_lesion == "unisx" || type_lesion == "unidx" % unilaterale
        plot_landmark(dx, '.y')
        plot_landmark(sx, '.y')
        plot_landmark(top, '.r')
        plot_landmark(bot, '.r')
    else % bilaterale
        % lesione destra
        plot_landmark(dx_right, '.y')
        plot_landmark(sx_right, '.y')
        plot_landmark(top_right, '.r')
        plot_landmark(bot_right, '.r')
        
        % lesione sinistra
        plot_landmark(dx_left, '.y')
        plot_landmark(sx_left, '.y')
        plot_landmark(top_left, '.r')
        plot_landmark(bot_left, '.r')
    end
    
    legend('','sl','prn','orizzontali','','verticali')
    title (sprintf('Feto %d - Landmark',i))
    hold off
    
end

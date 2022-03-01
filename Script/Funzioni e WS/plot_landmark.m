function plot_landmark(input_struct, color_parameter, dim_parameter)
% funzione che permette di plottare un punto nello spazio
% i parametri color_parameter e dim_parameter sono opzionali

% definizione dei punti del parametro dalla struct
x_in = input_struct.Position(1);
y_in = input_struct.Position(2);
z_in = input_struct.Position(3);

% Controllo parametri opzionali
 if ~exist('color_parameter','var')
      color_parameter = '.r';
 end
 
 if ~exist('dim_parameter','var')
      dim_parameter = 20;
 end

% plot del punto
hold on
plot3(x_in, y_in, z_in, color_parameter, 'Markers', dim_parameter)
hold off
end


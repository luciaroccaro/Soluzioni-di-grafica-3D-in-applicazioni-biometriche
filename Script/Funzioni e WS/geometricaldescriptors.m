function [e,C,K,k1,k2,f,g,H,S] = geometricaldescriptors(Z)
% funzione che calcola i descrittori geometrici

%% parametri base
% la funzione gradient calcola le derivate
Zx = gradient(Z);
Zy = gradient(Z')';

% calcolo delle derivate seconde
Zxx = gradient(Zx);
Zyy = gradient(Zy')';
Zxy = gradient(Zx')';

%% coefficienti della prima forma fondamentale
E = 1+Zx.^2;
F = Zx.*Zy;
G = 1+Zy.^2;

%% coefficienti della seconda forma fondamentale
nom = sqrt(1+Zx.^2+Zy.^2);
e = Zxx./nom;
f = Zxy./nom;
g = Zyy./nom;

%% mean curvature
H = (e.*G-2*f.*F+g.*E)./(2*(E.*G-F.^2));

%% gaussian curvature
K = (e.*g-f.^2)./(E.*G-F.^2);

%% curvature principali
k1 = H + sqrt(H.^2-K);
k2 = H - sqrt(H.^2-K);

%% indici di Shape e Curvedness
S = -(2/pi)*atan((k1+k2)./(k1-k2));
C = sqrt((k1.^2+k2.^2)/2);

end
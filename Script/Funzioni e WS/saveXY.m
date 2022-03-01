function [X,Y] = saveXY(Z)
% funzione che salva le matrici X e Y a partire dalla matrice Z

imax = size(Z,1);
jmax = size(Z,2);

for i=1:imax
    for j=1:jmax
        X(i,j)=j;
    end
end

for i=1:imax
    for j=1:jmax
        Y(i,j)=i;
    end
end

end
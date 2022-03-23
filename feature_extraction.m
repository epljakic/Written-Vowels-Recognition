function P = Obelezja(X)
% Funkcija koja nam vraca vrednosti obelezja nasih slova
Y=double(X);

% Binarizacija
T = 0.8;
Y(Y<T*max(max(Y))) = 0;
Y(Y>=T*max(max(Y))) = 255;

% Predobrada slike
[nr, nc] = size(Y);

% Otklanjanje okvira
poc = 1;
while (poc<nr) && (sum(Y(poc,:))/nc<235)
    poc = poc+1;
end

kraj = nr;
while (kraj>1) && (sum(Y(kraj,:))/nc<235)
    kraj = kraj-1;
end

levo = 1;
while (levo<nc) && (sum(Y(:,levo))/nr<235)
    levo = levo+1;
end

desno = nc;
while (desno>1) && (sum(Y(:,desno))/nr<235)
    desno = desno-1;
end

X = X(poc:kraj,levo:desno);
Y = Y(poc:kraj,levo:desno);
[nr, nc] = size(X);

% Otklanjanje belih segmenata
poc = 1;
while (poc<nr) && (sum(Y(poc,:))/nc>250) || ...
        ((sum(Y(poc,:))/nc<250) && (sum(Y(poc+1,:))/nc>250))
    poc = poc+1;
end

kraj = nr;
while (kraj>1) && (sum(Y(kraj,:))/nc>250) || ...
        ((sum(Y(kraj,:))/nc<250) && (sum(Y(kraj-1,:))/nc>250))
    kraj = kraj-1;
end

levo = 1;
while (levo<nc) && (sum(Y(:,levo))/nr>250) || ...
        ((sum(Y(:,levo))/nr<250) && (sum(Y(:,levo+1))/nr>250))
    levo = levo+1;
end

desno = nc;
while (desno>1) && (sum(Y(:,desno))/nr>250) || ...
        ((sum(Y(:,desno))/nr<250) && (sum(Y(:,desno-1))/nr>250))
    desno = desno-1;
end

X = X(poc:kraj,levo:desno);
Y = Y(poc:kraj,levo:desno);
[nr, nc] = size(Y);

% Obelezja
P(1,1) = 2*mean(mean(Y(round(1/3*nr):round(2/3*nr), round(1/3*nc):round(2/3*nc))));
P(1,2) = 255*mean(mean(Y(:, 1:round(1/2*nc))))/mean(mean(Y(:, round(1/2*nc):nc))) + mean(mean(Y(round(4/5*nr):nr, :))); 
P(1,3) = 255*mean(mean(Y(1:round(1/2*nr), :)))/mean(mean(Y(round(1/2*nr):nr, :))) + mean(mean(Y(round(4/5*nr):nr, :)));

end
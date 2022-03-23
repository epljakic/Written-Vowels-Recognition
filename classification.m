clc, clear, close all
%% Ucitavanje svih slova
% Prolazimo kroz sva slova A
x = dir('bazaA*.bmp');      %ucitali sve slike sa slovom A;
for i = 1 : max(size(x))
    X = imread(x(i).name); 
    P1(:, i) = prvi_zadatak_obelezja(X);
end

y = dir('bazaE*.bmp');      %ucitali sve slike sa slovom E;
for i = 1 : max(size(y))
    Y = imread(y(i).name); 
    P2(:, i) = prvi_zadatak_obelezja(Y);
end

z = dir('bazaI*.bmp');      %ucitali sve slike sa slovom I;
for i = 1 : max(size(z))
    Z = imread(z(i).name); 
    P3(:, i) = prvi_zadatak_obelezja(Z);
end

u = dir('bazaO*.bmp');      %ucitali sve slike sa slovom O;
for i = 1 : max(size(u))
    U = imread(u(i).name); 
    P4(:, i) = prvi_zadatak_obelezja(U);
end

v = dir('bazaU*.bmp');      %ucitali sve slike sa slovom U;
for i = 1 : max(size(v))
    V = imread(v(i).name); 
    P5(:, i) = prvi_zadatak_obelezja(V);
end

%% Iscrtavanje obelezja
figure(1)
plot3(P1(1,:), P1(2,:), P1(3,:), 'k*');hold on 
plot3(P2(1,:), P2(2,:), P2(3,:), 'rx');        
plot3(P3(1,:), P3(2,:), P3(3,:), 'go');        
plot3(P4(1,:), P4(2,:), P4(3,:), 'bx');        
plot3(P5(1,:), P5(2,:), P5(3,:), 'mo');   
xlabel('obelezje 1');
ylabel('obelezje 2');
zlabel('obelezje 3');

title('Odbirci samoglasnika');
legend('A', 'E', 'I', 'O', 'U', 'Location','northwest');

%% Podela podataka na obucavajuci i testirajuci skup
% Od 120 slova, biramo 100 za obucavanje i 20 za testiranje
N = 120;
No = 100;
% Obucavajuci i testirajuci skup
O1 = P1(:, 1:No);  T1 = P1(:, No+1:N);
O2 = P2(:, 1:No);  T2 = P2(:, No+1:N);
O3 = P3(:, 1:No);  T3 = P3(:, No+1:N);
O4 = P4(:, 1:No);  T4 = P4(:, No+1:N);
O5 = P5(:, 1:No);  T5 = P5(:, No+1:N);

% Test vise hipoteza
% Za test vise hipoteza potrebne su nam funkcije gustine verovatnoce
% Za fgv cemo pretpostaviti da su normalno raspodeljenje, pa cemo traziti
% koji fgv je za datu sliku najveci i na osnovu toga doneti odluku kojoj
% klasi pripada dati odbirak
M1 = mean(O1,2); S1 = cov(O1');
M2 = mean(O2,2); S2 = cov(O2');
M3 = mean(O3,2); S3 = cov(O3');
M4 = mean(O4,2); S4 = cov(O4');
M5 = mean(O5,2); S5 = cov(O5');

Mk = zeros(5); %matrica konfuzije

% Testiranje klasifikatora, belezimo da li je odluka ispravna ili ne
% Pretpostavicemo da su apriorne verovatnoce pojave klasa jednake
% P1 = P2 = P3 = P4 = P5
for kl = 1:5
    if kl == 1
        T = T1;
        disp('1');
    elseif kl == 2
        disp('2');
        T = T2;
    elseif kl == 3
        disp('3');
        T = T3;
    elseif kl == 4
        disp('4');
        T = T4;
    else
        T = T5;
        disp('5');
    end      
    for i = 1:N-No
        p = T(:,i);
        f1 = 1/(2*pi)/det(S1)^0.5*exp(-0.5*(p-M1)'*inv(S1)*(p-M1));
        f2 = 1/(2*pi)/det(S2)^0.5*exp(-0.5*(p-M2)'*inv(S2)*(p-M2));
        f3 = 1/(2*pi)/det(S3)^0.5*exp(-0.5*(p-M3)'*inv(S3)*(p-M3));
        f4 = 1/(2*pi)/det(S4)^0.5*exp(-0.5*(p-M4)'*inv(S4)*(p-M4));
        f5 = 1/(2*pi)/det(S5)^0.5*exp(-0.5*(p-M5)'*inv(S5)*(p-M5));
        m = max([f1 f2 f3 f4 f5]); %maksimum daje odluku kojoj klasi ce pripadati
        
        if m == f1        %klasifikator doneo odluku da je u pitanju klasa 1
            Mk(kl,1) = Mk(kl,1)+1;
            disp('Odluka je : 1');
        elseif m == f2    %klasifikator doneo odluku da je klasa 2
            Mk(kl,2) = Mk(kl,2)+1;
            disp('Odluka je : 2');
        elseif m == f3    %klasifikator doneo odluku da je klasa 3
            Mk(kl,3) = Mk(kl,3)+1;
            disp('Odluka je : 3');
        elseif m == f4    %klasifikator doneo odluku da je klasa 4
            Mk(kl,4) = Mk(kl,4)+1;
            disp('Odluka je : 4');
        else              %klasifikator doneo odluku da je klasa 5
            Mk(kl,5) = Mk(kl,5)+1;
            disp('Odluka je : 5');
        end
    end
end
% Prikaz matrice konfuzije
Mk
disp(['Greska iznosi: ' num2str((sum(sum(Mk))-trace(Mk))/sum(sum(Mk)))]);
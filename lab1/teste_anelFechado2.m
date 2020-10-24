
%%% Script para testar o controlador %%%
clear all, close, clc

Ref = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2];

% Ref = zeros(1,1000);
% Ref(1:200) = 2;
% Ref(200:400) = 4;
% Ref(400:600) = 3;
% Ref(600:800) = 4.5;
% Ref(800:1000) = 3;

% ARX(2,4,1)
load arx241.mat
A = arx241.A;
B = arx241.B;

p = eye(7); %matriz identidade n*n (n é a dimensao do vetor de parametrizacao)
[F, G, H]=tuning(A,B)  % Parâetros do controlador 
na=1;
nb=4;
nk=1;
Ni = max(na,nb+nk);
Nmax=length(Ref);
U =zeros(Nmax,1);
disp('Em modo controlo!') 

y = zeros(10,1); %criei eu 

for index = Ni:Nmax
    u(index,1) = controlador(Ref(index), F, G, H, y(index-2:index,1)) 
    u(index,1) = max(min(u(index,1),5),0) % Saturação da excitação
    y(index+1,1) = -A(2)*y(index,1)-A(3)*y(index-1,1) -A(4)*y(index-2,1) + B(1)*u(index,1) + B(2)*u(index-1,1) + B(3)*u(index-2,1)
end
subplot(2,1,1), plot(y(Ni:end))
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acção de controlo'), xlabel('Amostra')











